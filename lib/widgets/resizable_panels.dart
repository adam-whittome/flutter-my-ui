import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_my_ui/widgets/theme.dart';
import 'package:provider/provider.dart';

class _ResizablePanelLayoutDelegate extends MultiChildLayoutDelegate {
  final Axis axis;
  final List<double> weights;

  _ResizablePanelLayoutDelegate({required this.axis, required this.weights});

  @override
  void performLayout(Size size) {
    double axisOffset = 0;
    weights.forEachIndexed((index, weight) {
      if (axis == Axis.horizontal) {
        positionChild(index, Offset(axisOffset, 0));
        layoutChild(index, BoxConstraints(
          minWidth: weight * size.width, maxWidth: weight * size.width,
          minHeight: size.height, maxHeight: size.height
        ));
        axisOffset += weight * size.width;
      } else {
        positionChild(index, Offset(0, axisOffset));
        layoutChild(index, BoxConstraints(
          minWidth: size.width, maxWidth: size.width,
          minHeight: weight * size.height, maxHeight: weight * size.height
        ));
        axisOffset += weight * size.height;
      }
    });
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) => true;
}

class _ResizablePanelGripLayoutDelegate extends MultiChildLayoutDelegate {
  final Axis axis;
  final List<double> weights;
  final double gripSize;

  _ResizablePanelGripLayoutDelegate({required this.axis, required this.weights, required this.gripSize});

  @override
  void performLayout(Size size) {
    double axisOffset = -gripSize / 2;
    weights.sublist(0, weights.length - 1).forEachIndexed((index, weight) {
      if (axis == Axis.horizontal) {
        axisOffset += weight * size.width;
        positionChild(index, Offset(axisOffset, 0));
        layoutChild(index, BoxConstraints(
          minWidth: gripSize, maxWidth: gripSize,
          minHeight: size.height, maxHeight: size.height
        ));
      } else {
        axisOffset += weight * size.height;
        positionChild(index, Offset(0, axisOffset));
        layoutChild(index, BoxConstraints(
          minWidth: size.width, maxWidth: size.width,
          minHeight: gripSize, maxHeight: gripSize
        ));
      }
    });
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) => true;
}

class ResizablePanelGroup extends StatefulWidget {
  final Axis axis;
  final List<ResizablePanel> panels;
  final double gripSize;
  final Widget grip;

  const ResizablePanelGroup({super.key, required this.axis, required this.panels, required this.gripSize, required this.grip});

  @override
  State<ResizablePanelGroup> createState() => _ResizablePanelGroupState();
}

enum ResizingState {
  none,
  hovered,
  draggedInRegion,
  draggedOutOfRegion,
}

class _ResizablePanelGroupState extends State<ResizablePanelGroup> {
  late List<double> weights;
  ResizingState state = ResizingState.none;

  @override
  void initState() {
    super.initState();
    double totalFlexSize = widget.panels.fold(0.0, (accumulator, panel) => accumulator + panel.flex);
    weights = widget.panels.map((panel) => panel.flex / totalFlexSize).toList();
  }

  double panelTotalWeightSize(int index) =>
    weights.sublist(0, index).fold(0.0, (double accumulator, double weight) => accumulator + weight);

  void transitionState(ResizingState to) {
    setState(() {
      state = to;
    });
  }

  void tryTransitionState(ResizingState from, ResizingState to) {
    if (state == from) {
      setState(() {
        state = to;
      });
    }
  }

  void onPanUpdate(DragUpdateDetails details, BoxConstraints constraints, int index) {
    Offset globalPosition = (context.findRenderObject()! as RenderBox).localToGlobal(Offset.zero);
    double weightOffset = panelTotalWeightSize(index);
    double totalDoubleWeight = weights[index] + weights[index + 1];
    Offset targetOffset = details.globalPosition - globalPosition;
    double targetWeight = (widget.axis == Axis.horizontal ? targetOffset.dx / constraints.minWidth : targetOffset.dy / constraints.minHeight) - weightOffset;
    targetWeight = targetWeight.clamp(
      max(0, widget.panels[index].resizeConstraints.min),
      min(totalDoubleWeight, widget.panels[index].resizeConstraints.max),
    );
    setState(() {
      weights[index] = targetWeight;
      weights[index + 1] = totalDoubleWeight - targetWeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return MouseRegion(
          cursor: switch (state) {
            ResizingState.none => MouseCursor.defer,
            ResizingState.hovered || ResizingState.draggedInRegion || ResizingState.draggedOutOfRegion =>
              widget.axis == Axis.horizontal ? SystemMouseCursors.resizeColumn : SystemMouseCursors.resizeRow,
          },
          child: Stack(
            children: [
              CustomMultiChildLayout(
                delegate: _ResizablePanelLayoutDelegate(
                  weights: weights,
                  axis: widget.axis,
                ),
                children: widget.panels.mapIndexed((index, panel) =>
                  LayoutId(
                    id: index,
                    child: panel.child,
                  )
                ).toList(),
              ),
              CustomMultiChildLayout(
                delegate: _ResizablePanelGripLayoutDelegate(
                  weights: weights,
                  axis: widget.axis,
                  gripSize: widget.gripSize,
                ),
                children: widget.panels.sublist(0, widget.panels.length - 1).mapIndexed((index, _) =>
                  LayoutId(
                    id: index,
                    child: GestureDetector(
                      onPanStart: (event) => transitionState(ResizingState.draggedInRegion),
                      onPanUpdate: (details) => onPanUpdate(details, constraints, index),
                      onPanEnd: (event) {
                        tryTransitionState(ResizingState.draggedInRegion, ResizingState.hovered);
                        tryTransitionState(ResizingState.draggedOutOfRegion, ResizingState.none);
                      },
                      child: MouseRegion(
                        onEnter: (event) {
                          tryTransitionState(ResizingState.none, ResizingState.hovered);
                          tryTransitionState(ResizingState.draggedOutOfRegion, ResizingState.draggedInRegion);
                        },
                        onExit: (event) {
                          tryTransitionState(ResizingState.hovered, ResizingState.none);
                          tryTransitionState(ResizingState.draggedInRegion, ResizingState.draggedOutOfRegion);
                        },
                        child: SizedBox(
                          width: widget.axis == Axis.horizontal ? widget.gripSize : constraints.minWidth,
                          height: widget.axis == Axis.vertical ? widget.gripSize : constraints.minHeight,
                          child: widget.grip,
                        ),
                      ),
                    ),
                  ),
                ).toList(),
              ),
            ],
          ),
        );
      }
    );
  }
}


class ResizeConstraints {
  final double min;
  final double max;

  const ResizeConstraints({required this.min, required this.max});
}


class ResizablePanel {
  final double flex;
  final ResizeConstraints resizeConstraints;
  final Widget child;

  const ResizablePanel({
    this.flex = 1,
    this.resizeConstraints = const ResizeConstraints(min: 0, max: 1),
    required this.child,
  });
}

class Grip extends StatelessWidget {
  final Axis axis;

  const Grip({super.key, required this.axis});

  @override
  Widget build(BuildContext context) {
    Theme theme = Provider.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: Color(0x00000000),
          child: Center(
            child: SizedBox(
              width: axis == Axis.horizontal ? 1 : constraints.minWidth,
              height: axis == Axis.vertical ? 1 : constraints.minHeight,
              child: Container(
                color: theme.colorScheme.separatorColor,
              ),
            ),
          ),
        );
      }
    );
  }
}
