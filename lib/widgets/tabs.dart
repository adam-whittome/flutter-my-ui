import 'package:flutter/widgets.dart';
import 'package:my_ui/widgets.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class Tabs extends StatefulWidget {
  final List<Tab> tabs;

  const Tabs({super.key, required this.tabs});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int selectedTabIndex = 0;

  void selectTab(int index) {
    setState(() {
      selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Theme theme = Provider.of(context);
    return Column(
      children: [
        Container(
          color: theme.colorScheme.backgroundSecondaryColor,
          child: Padding(
            padding: EdgeInsetsGeometry.only(left: 5, right: 5, top: 5),
            child: Row(
              spacing: 3,
              children: widget.tabs.mapIndexed((int index, Tab tab) =>
                Clickable(
                  onClickUp: (_) => selectTab(index),
                  child: TabHeader(
                    selected: selectedTabIndex == index,
                    child: tab.tabChild,
                  ) 
                )
              ).toList(),
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: theme.colorScheme.backgroundPrimaryColor,
            child: widget.tabs[selectedTabIndex].child,
          )
        )
      ],
    );
  }
}

class TabHeader extends StatelessWidget {
  final bool selected;
  final Widget? child;

  const TabHeader({super.key, required this.selected, this.child});

  @override
  Widget build(BuildContext context) {
    Theme theme = Provider.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: selected ? theme.colorScheme.backgroundPrimaryColor : theme.colorScheme.backgroundTertiaryColor,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.all(3),
        child: child,
      ),
    );
  }
}

class Tab {
  final Widget? tabChild;
  final Widget? child;

  const Tab({this.tabChild, this.child});
}
