import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSiriWavePainter extends CustomPainter{

  final double volume;
  final Color color;
  final double strokeWidth;
  final double phase;

  CustomSiriWavePainter({this.volume: 0, this.color : Colors.red, this.strokeWidth : 1, this.phase : 1});

  @override
  void paint(Canvas canvas, Size size) {

    final normedAmplitude = volume;
    final frequency = 1;
    final phase = this.phase;

    final path = Path();
    var maxAmplitude = size.height / 2;
    var mid = size.width / 2;
    final paint = Paint()..color = color..strokeWidth = strokeWidth;
    double? prevY;
    for(double i=0;i<size.width;i++){
      var scaling = -1 * pow(1 / mid * (i - mid) , 2) + 1;
      var y = scaling * maxAmplitude * normedAmplitude * sin((2 * pi) * frequency * (i / size.width) + phase) + (size.height / 2);
      if(prevY!=null){
        canvas.drawLine(Offset(i-1,prevY), Offset(i,y), paint);
      }
      prevY = y;
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}