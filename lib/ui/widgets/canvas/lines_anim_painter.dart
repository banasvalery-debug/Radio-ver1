import 'dart:ffi';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vm;
import 'dart:math' as math;

import 'package:voicetruth/data/constants/app_colors.dart';
import 'package:voicetruth/ui/widgets/small_widgets/gradient_shadow.dart';

class SiriPainterCanvas extends CustomPainter{

  double K = 4;
  // int NO_OF_CURVES = 3;
  // var widths = [ 0.4, 0.6, 0.3];
  // var offsets = <double>[ 1, 4, -3];
  // var amplitudes = [ 0.5, 0.7, 0.2 ];
  // var phases = [ 0, 0, 0];
  double globalAmplitude = 1;

  late Size size;

  final double volume;

  SiriPainterCanvas(this.volume);

  @override
  void paint(Canvas canvas, Size size) {
    this.size = size;
    drawBackLine(canvas, size);
    drawWaves(canvas, size, AppColors.purpleBlue);
    drawWaves(canvas, size, AppColors.indigoBlue, divide: 2, leftMargin: 10);
    drawWaves(canvas, size, AppColors.indigoBlue, divide: 2, leftMargin: 10, reverse: true);
    drawWaves(canvas, size, AppColors.pink, divide: 3, leftMargin: 20);
    drawWaves(canvas, size, AppColors.pink, divide: 3, leftMargin: 20, reverse: true);
  }
  drawBackLine(Canvas canvas, Size size){
    final paint = Paint()..color = Colors.transparent..strokeWidth = 1;
    canvas.drawLine(Offset(0, size.height/2), Offset(size.width, size.height/2), paint);
  }
  drawWaves(Canvas canvas, Size size, Color color,
      {double divide = 1, double leftMargin = 4, bool reverse = false}){
    final path = Path();
    final path2 = Path();

    final paint = Paint();
    paint.color = color.withOpacity(1 * 0.3);
    paint.strokeWidth = 1;

    // double lx = 0, ly = 0;
    double margin = size.width/leftMargin - (reverse ? -size.width * 0.03 : size.width * 0.02);
    path.moveTo((reverse ? size.width : 0) + margin, size.height/2);
    path2.moveTo((reverse ? size.width : 0) + margin, size.height/2);
    final width = size.width / leftMargin * divide;
    for (double i = -2; i <= 2; i += 0.01){
      var x =(reverse ? size.width - width - margin : 0) + (reverse ? -1 : 1) * margin + width + (width * i);
      var y = _ypos(i, volume: volume, divide: divide) +( size.height / 2);
      var y2 = _ypos(i, reverse: -1, volume: volume, divide: divide) +( size.height / 2);
      path.lineTo(x, y);
      path2.lineTo(x, y2);
    }
    canvas.drawPath(path, paint);
    canvas.drawPath(path2, paint);
  }

  double _globalAttFn(x) {   return math.pow(K / (K + math.pow(x, 2)), K) as double;}
  double _ypos(i, {int reverse = 1, double volume = 0, double divide = 1}) {
    double y = 0;
      var t = 0; // offset
      var k = 1 / 0.5 * divide; // widths
      var x = (i * k) - t;
      y += (volume/divide/3 * math.sin(x - 2) * _globalAttFn(x)).abs(); //amplitude
    return /*canvasHeightMax*/ reverse * size.height * globalAmplitude * y;
  }


  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}

// class LinesAnimPainter extends CustomPainter{
//
//   final double Function(double ,double, double) lerp = (a, b, n) => (1 - n) * a + n * b;
//   var time = 0;
//   var devicePixelRatio =  /*window.devicePixelRatio ??*/ 1.0;
//   final simplex = vm.SimplexNoise();
//   var steps = 100;
//   var amplitude = 30;
//   var lines = 40;
//
//   late Size size;
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     this.size = size;
//     draw(canvas);
//   }
//
//   List<List<double>>drawLine(startY, t, seed) {
//     var step = size.width / steps;
//     var x = -step;
//     var y = 0.0;
//     var arr = <List<double>>[];
//     for (int i = 0; i <= steps; i++) {
//     var n = simplex.noise2D((time * 0.001 + seed + i) * 0.02, (startY + time * t) * 0.0003);
//     x += step;
//
//     var amp = math.min(i, 40);
//     if (i > steps - 40) amp = steps - i;
//     y = startY + n * amp;
//     arr.add([x, y]);
//     }
//     return arr;
//   }
//
//   draw(Canvas canvas){
//     var p1 = drawLine(size.height / 2, 1.1, 100);
//     var p2 = drawLine(size.height / 2, 1.3, 200);
//     var p3 = drawLine(size.height / 2, 1, 300);
//     var p4 = drawLine(size.height / 2, 1.2, 150);
//
//     List<Path> pathes = [];
//
//     for (int r = 0; r <= lines; r++) {
//       double h = double.parse("${(130 + r + time * 0.01).floor()}");
//       // ctx.strokeStyle = `hsla(${h}, 50%, 50%, .5)`
//       Paint paint = Paint();
//       paint.strokeWidth = h;
//       paint.shader = ui.Gradient.linear(Offset(0,0), Offset(size.width,size.height/1.7), [
//         AppColors.purpleBlue,
//         AppColors.purpleBlue.withOpacity(0)
//       ]);
//       // document.body.style.backgroundColor = `hsl(${h}, 40%, 90%)`
//       var s = 1 / lines;
//       // ctx.beginPath();
//       Path path = Path();
//       for (int i = 0; i <= steps; i++) {
//         var type = i == 0;// ? 'moveTo' : 'lineTo';
//         double x = lerp(p1[i][0], p2[i][0], r * s);
//         double y = lerp(p1[i][1], p2[i][1], r * s);
//         if(type) path.moveTo(x, y);
//         else path.lineTo(x, y);
//         // ctx[type](x, y);
//         }
//         // ctx.stroke()
//       canvas.drawPath(path, paint);
//       }
//
//       for (int r = 1; r <= lines; r++) {
//         double h = double.parse("${(130 + lines + r + time * 0.01).floor()}");
//         // ctx.strokeStyle = `hsla(${h}, 50%, 50%, .5)`
//         Paint paint = Paint();
//         paint.strokeWidth = h;
//         paint.shader = ui.Gradient.linear(Offset(0,0), Offset(size.width,size.height/1.7), [
//           AppColors.indigoBlue,
//           AppColors.indigoBlue.withOpacity(0)
//         ]);
//         // document.body.style.backgroundColor = `hsl(${h}, 40%, 90%)`
//         double s = 1 / lines;
//         // ctx.beginPath()
//         Path path = Path();
//         for (int i = 0; i <= steps; i++) {
//           bool type = i == 0;// ? 'moveTo' : 'lineTo'
//           double x = lerp(p2[i][0], p3[i][0], r * s);
//           double y = lerp(p2[i][1], p3[i][1], r * s);
//           if(type) path.moveTo(x, y);
//           else path.lineTo(x, y);
//           // ctx[type](x, y)
//         }
//         canvas.drawPath(path, paint);
//         // ctx.stroke()
//       }
//     for (int r = 1; r <= lines; r++) {
//       double h = double.parse("${(130 + lines + r + time * 0.01).floor()}");
//       // ctx.strokeStyle = `hsla(${h}, 50%, 50%, .5)`
//       Paint paint = Paint();
//       paint.strokeWidth = h;
//       paint.shader = ui.Gradient.linear(Offset(0,0), Offset(0,size.height/1.7), [
//         AppColors.blue,
//         AppColors.blue.withOpacity(0)
//       ]);
//       // document.body.style.backgroundColor = `hsl(${h}, 40%, 90%)`
//       double s = 1 / lines;
//       // ctx.beginPath()
//       Path path = Path();
//       for (int i = 0; i <= steps; i++) {
//         bool type = i == 0;// ? 'moveTo' : 'lineTo'
//         double x = lerp(p3[i][0], p4[i][0], r * s);
//         double y = lerp(p3[i][1], p4[i][1], r * s);
//         if(type) path.moveTo(x, y);
//         else path.lineTo(x, y);
//         // ctx[type](x, y)
//       }
//       canvas.drawPath(path, paint);
//       // ctx.stroke()
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
//
// }
//