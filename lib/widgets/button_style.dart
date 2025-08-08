import 'package:flutter/widgets.dart';

class ButtonStyle {
  final Color color;
  final Color colorOnHover;
  final Color colorOnPress;
  
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;

  const ButtonStyle({
    required this.color,
    required this.colorOnHover,
    required this.colorOnPress,
    this.padding = const EdgeInsetsGeometry.all(3),
    this.borderRadius = const BorderRadiusGeometry.all(Radius.circular(3))
  });
}
