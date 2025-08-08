import 'package:flutter/widgets.dart';
import 'package:my_ui/widgets.dart';
import 'package:provider/provider.dart';

class Button extends StatelessWidget {
  final Widget child;
  final ButtonStyle? style;

  final void Function()? onPress;

  const Button({
    super.key,
    required this.child,
    this.style,
    
    this.onPress
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style;
    if (this.style == null) {
      style = Provider.of<Theme>(context).buttonStyle;
    } else {
      style = this.style!;
    }
    return Clickable(
      builder: (_, child, clickableState) => DecoratedBox(
        decoration: BoxDecoration(
          color: switch (clickableState) {
            ClickableState.none => style.color,
            ClickableState.hovered => style.colorOnHover,
            ClickableState.clicked => style.colorOnPress,
          },
          borderRadius: style.borderRadius,
        ),
        child: Padding(
          padding: style.padding,
          child: child
        ),
      ),
      child: child,
    );
  }
}