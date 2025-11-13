import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WaveFormVisualizerPainter extends CustomPainter{
  final Uint8List buffer;

  WaveFormVisualizerPainter(this.buffer);
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height, width = size.width;
    final n = buffer.length;

    Paint paint = Paint()..color = Colors.black..strokeWidth = 1;

    Offset? prevOffset;

    int l=0;
    for(int i=1;i<n-1;i++){
      final pos = buffer[i];
      final prevPos = buffer[i-1], nextPos = buffer[i+1];
      if(pos > prevPos && pos > nextPos){
        l++;
      }
      if(pos < prevPos && pos < nextPos){
        l++;
      }
    }

    if(l>1023) canvas.drawLine(Offset(0, height/2), Offset(width, height/2), paint);
    else {
      for (int i = 0; i < n; i++) {
        final pos = buffer[i];
        final h1 = height / 255;
        final offset = Offset(width / n * i, h1 * (255 - pos));
        if (prevOffset != null) {
          canvas.drawLine(prevOffset, offset, paint);
        }
        prevOffset = offset;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}