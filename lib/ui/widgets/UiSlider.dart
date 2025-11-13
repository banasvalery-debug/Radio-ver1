import 'package:flutter/material.dart';

import 'package:voicetruth/state/app.dart';

import 'SliderThumb.dart';

class UiSlider extends StatelessWidget {
  final void Function(double) onChange;
  final double value;

  const UiSlider({
    required this.value,
    required this.onChange,
  });

  @override
  build(context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: app.theme.getColor('primaryColor'),
        inactiveTrackColor: app.theme.getColor('secondaryColor'),
        trackShape: RectangularSliderTrackShape(),
        trackHeight: 2.0,
        thumbColor: app.theme.getColor('primaryColor'),
        thumbShape: CustomSliderThumbCircle(),
        overlayColor: app.theme.getColor('secondaryColor').withOpacity(0.8),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width - 90,
        child: Slider(value: this.value, onChanged: this.onChange),
      ),
    );
  }
}
