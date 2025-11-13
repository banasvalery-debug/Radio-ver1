import 'package:flutter/material.dart';
import 'package:voicetruth/data/constants/app_colors.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class CustomWaveWidget extends StatelessWidget {
  final double volume;
  const CustomWaveWidget({Key? key, this.volume:0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WaveWidget(
      config: CustomConfig(
        gradients: [
          [AppColors.purpleBlue, AppColors.dark.withOpacity(0.6)],
          [AppColors.indigoBlue, AppColors.indigoBlue.withOpacity(0.6)],
          [AppColors.blue, AppColors.blue.withOpacity(0.6)],
          [AppColors.lBlue, AppColors.lBlue.withOpacity(0.6)],
        ],
        durations: [8000,7500,3000,4000],//[35000, 19000, 10000, 6000],
        heightPercentages: [volume==0 ? 1 : getVolume(1), getVolume(0.8), getVolume(0.7),getVolume(0.6)],//[0.30, 0.33, 0.35, 0.40],
        blur: MaskFilter.blur(BlurStyle.solid, 0),
        gradientBegin: Alignment.bottomLeft,
        gradientEnd: Alignment.topRight,
      ),
      waveAmplitude: 1,
      heightPercentange: 0.5,
      size: Size(
        double.infinity,
        double.infinity,
      ),
    );
  }

  getVolume(double v)=>1-(v*volume);
}
