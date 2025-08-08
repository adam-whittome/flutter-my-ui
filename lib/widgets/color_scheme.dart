import 'dart:ui';

class ColorScheme {
  final Color backgroundPrimaryColor;
  final Color backgroundSecondaryColor;
  final Color backgroundTertiaryColor;
  final Color backgroundQuaternaryColor;

  final Color buttonColor;
  final Color buttonHoveredColor;
  final Color buttonPressedColor;

  final Color separatorColor;

  final Color foregroundPrimaryColor;

  const ColorScheme({
    required this.backgroundPrimaryColor,
    required this.backgroundSecondaryColor,
    required this.backgroundTertiaryColor,
    required this.backgroundQuaternaryColor,
    required this.buttonColor,
    required this.buttonHoveredColor,
    required this.buttonPressedColor,
    required this.separatorColor,
    required this.foregroundPrimaryColor,
  });

  factory ColorScheme.light() => ColorScheme(
    backgroundPrimaryColor: Color.fromARGB(255, 252, 255, 252),
    backgroundSecondaryColor: Color.fromARGB(255, 228, 227, 227),
    backgroundTertiaryColor: Color.fromARGB(255, 211, 211, 211),
    backgroundQuaternaryColor: Color.fromARGB(255, 207, 202, 201),

    buttonColor: Color.fromARGB(255, 221, 218, 218),
    buttonHoveredColor: Color.fromARGB(255, 202, 199, 199),
    buttonPressedColor: Color.fromARGB(255, 165, 164, 163),

    separatorColor: Color.fromARGB(255, 180, 180, 180),

    foregroundPrimaryColor: Color.fromARGB(255, 0, 0, 0),
  );
}
