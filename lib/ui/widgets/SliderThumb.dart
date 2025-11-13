import 'package:flutter/material.dart';

import '../../state/app.dart';

class CustomSliderThumbCircle extends SliderComponentShape {
  final double thumbRadius;
  final int min;
  final int max;

  const CustomSliderThumbCircle({
    this.thumbRadius = 0.0,
    this.min = 0,
    this.max = 10,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(30);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double>? activationAnimation,
    Animation<double>? enableAnimation,
    bool? isDiscrete,
    TextPainter? labelPainter,
    RenderBox? parentBox,
    SliderThemeData? sliderTheme,
    TextDirection? textDirection,
    double? value,
    double? textScaleFactor,
    Size? sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final paint = Paint()
      ..color = app.theme.getColor('primaryColor') //Thumb Background Color
      ..style = PaintingStyle.fill;

    final paintBg = Paint()
      ..color = app.theme.getColor('background') //Thumb Background Color
      ..style = PaintingStyle.fill;

    RRect rrectBg = RRect.fromRectAndRadius(
        Rect.fromLTRB(center.dx - 6, center.dy - 9, center.dx + 6, center.dy + 9), Radius.circular(8));
    canvas.drawRRect(rrectBg, paintBg);

    RRect rrect = RRect.fromRectAndRadius(
        Rect.fromLTRB(center.dx - 4, center.dy - 7, center.dx + 4, center.dy + 7), Radius.circular(8));
    canvas.drawRRect(rrect, paint);
  }

  String getValue(double value) {
    return (min + (max - min) * value).round().toString();
  }
}
