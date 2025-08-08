import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

class Clickable extends StatefulWidget {
  final void Function(TapDownDetails)? onClickDown;
  final void Function(TapUpDetails)? onClickUp;
  final void Function(PointerEnterEvent)? onEnter;
  final void Function(PointerExitEvent)? onExit;

  final Widget Function(BuildContext, Widget?, ClickableState)? builder;
  final Widget? child;

  const Clickable({super.key, this.onClickDown, this.onClickUp, this.onEnter, this.onExit, this.builder, this.child});

  @override
  State<Clickable> createState() => _ClickableState();
}

enum ClickableState {
  none,
  hovered,
  clicked,
}

class _ClickableState extends State<Clickable> {
  ClickableState state = ClickableState.none;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (event) {
        if (widget.onClickDown != null) {
          widget.onClickDown!(event);
        }
        setState(() {
          state = ClickableState.clicked;
        });
      },
      onTapUp: (event) {
        if (widget.onClickUp != null) {
          widget.onClickUp!(event);
        }
        setState(() {
          state = ClickableState.hovered;
        });
      },
      child: MouseRegion(
        onEnter: (event) {
          if (widget.onEnter != null) {
            widget.onEnter!(event);
          }
          setState(() {
            state = ClickableState.hovered;
          });
        },
        onExit: (event) {
          if (widget.onExit != null) {
            widget.onExit!(event);
          }
          setState(() {
            state = ClickableState.none;
          });
        },
        cursor: switch (state) {
          ClickableState.none => MouseCursor.defer,
          ClickableState.hovered || ClickableState.clicked => SystemMouseCursors.click,
        },
        child: widget.builder != null ? widget.builder!(context, widget.child, state) : widget.child,
      ),
    );
  }
}