import 'package:flutter/widgets.dart';
import 'package:flutter_my_ui/widgets/button_style.dart';
import 'package:flutter_my_ui/widgets/color_scheme.dart';

class Theme extends ChangeNotifier {
  final ColorScheme colorScheme;
  final ButtonStyle buttonStyle;
  final ButtonStyle? ghostButtonStyle;
  final TextStyle textStyle;

  Theme({
    required this.colorScheme,
    required this.buttonStyle,
    this.ghostButtonStyle,
    required this.textStyle
  });

  factory Theme.light() {
    final ColorScheme colorScheme = ColorScheme.light();
    return Theme(
      colorScheme: colorScheme,
      buttonStyle: ButtonStyle(
        color: colorScheme.buttonColor,
        colorOnHover: colorScheme.buttonHoveredColor,
        colorOnPress: colorScheme.buttonPressedColor,
      ),
      ghostButtonStyle: ButtonStyle(
        color: Color.fromARGB(0, 0, 0, 0),
        colorOnHover: colorScheme.buttonColor,
        colorOnPress: colorScheme.buttonPressedColor,
      ),
      textStyle: TextStyle(
        color: colorScheme.foregroundPrimaryColor
      )
    );
  }
}
