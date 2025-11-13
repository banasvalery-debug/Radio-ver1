import 'dart:math';

import 'package:flutter/material.dart';
import 'package:siri_wave/siri_wave.dart';
import 'package:voicetruth/data/constants/app_colors.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/ui/widgets/canvas/custom_siri_wave.dart';
import 'package:voicetruth/ui/widgets/canvas/siri_wave_painter.dart';

class NewSiriWaveWidget extends StatefulWidget {
  final SiriWaveController controller;
  const NewSiriWaveWidget({Key? key,required this.controller}) : super(key: key);

  @override
  _NewSiriWaveWidgetState createState() => _NewSiriWaveWidgetState();
}

class _NewSiriWaveWidgetState extends State<NewSiriWaveWidget> {
  @override
  Widget build(BuildContext context) {
    return OverflowBox(
      minHeight: size.h1 * 100,
      maxHeight: size.h1 * 800,
      child: SizedBox(
        height: size.h1 * 800,
        child: CustomSiriWave(
          controller: widget.controller,
          options: SiriWaveOptions(
            height: size.h1 * 800,
            width: size.width,
            backgroundColor: Colors.transparent
          ),
          style: SiriWaveStyle.ios_9,
        ),
      ),
    );
  }
}


class SiriWaveWidget extends StatelessWidget {
  final double volume;
  final Color color;
  final double phase;
  const SiriWaveWidget({Key? key, this.volume : 0, this.color : Colors.red, this.phase : 0.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for(int i=0;i<30 ;i++)
          _getSingleWave(i)
      ],
    );
  }

  _getSingleWave(int count){
    var progress = 1.0 - count / 50;
    var normedAmplitude = 1.5 * progress * volume;
    var alphaComponent = min(1.0, (progress / 3 * 2) + 1 / 2);
    alphaComponent = max(0, alphaComponent);
    return Positioned.fill(
        child: CustomPaint(
          painter: CustomSiriWavePainter(
            phase: phase,
            volume: normedAmplitude,
            color: color.withOpacity(alphaComponent),
            strokeWidth: 1.5 / (count + 1)
          ),
        )
    );
  }
}

class CustomSiriWaveWidget extends StatefulWidget {
  final double vol;
  const CustomSiriWaveWidget({Key? key, this.vol : 0}) : super(key: key);

  @override
  _CustomSiriWaveWidgetState createState() => _CustomSiriWaveWidgetState();
}

class _CustomSiriWaveWidgetState extends State<CustomSiriWaveWidget> with SingleTickerProviderStateMixin{
  late AnimationController _phaseAnimation;

  @override
  void initState() {
    _phaseAnimation =  AnimationController(vsync: this);
    _phaseAnimation.repeat(min: 0, max: 1, reverse: true, period: Duration(seconds: 1000));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: _phaseAnimation.value, end: _phaseAnimation.value),
        duration: Duration(seconds: 1),
        builder: (context, val, child){
          return Stack(
            children: [
              Positioned.fill(
                child: SiriWaveWidget(
                  volume: widget.vol/1.5,
                  phase: val * 4500,
                  color: AppColors.indigoBlue,
                ),
              ),
              Positioned.fill(
                child: SiriWaveWidget(
                  volume: widget.vol,
                  phase: val * 1400,
                  color: AppColors.purpleBlue,
                ),
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    _phaseAnimation.dispose();
    super.dispose();
  }
}
