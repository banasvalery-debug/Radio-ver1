// @dart=2.12
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_svg/svg.dart';
import 'package:siri_wave/siri_wave.dart';
import 'package:voicetruth/data/constants/app_colors.dart';
import 'package:voicetruth/data/constants/app_images.dart';

import 'package:voicetruth/model/Track.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/ui/widgets/wave/siri_wave_widget.dart';

class PlayerWidget extends StatefulWidget {
  final bool isPlayer;
  final bool isDonation;
  final Function(VoidCallback recalc) setRecalcAnimation;
  const PlayerWidget({Key? key, this.isPlayer : true, this.isDonation : false, required this.setRecalcAnimation}) : super(key: key);

  @override
  createState() => PlayerWidgetState();
}

class PlayerWidgetState extends State<PlayerWidget> with TickerProviderStateMixin {
  late AnimationController _animationController;
  StreamSubscription? playbackStateSubscription;
  Track? prevTrack;
  bool canClick = true;

  static const double continuousRadius = 70;

  late SiriWaveController _siriWaveController;
  late AnimationController _siriAnimationController;

  DateTime lastWave = DateTime(1980);
  double speed = 0.1;

  double mMin = 0.375, mMax = 0.6;

  void _setAmplitude(double val)async{
    // _siriWaveController.setSpeed(speed);

    val = double.parse(val.toStringAsFixed(2));
    if(val>1 || val < 0) val = 0;

    final now = DateTime.now();

    if(now.difference(lastWave) > Duration(milliseconds: 100)){
      lastWave = DateTime.now();

      if(val > 0) {
        if(mounted)
          _siriAnimationController.animateTo(val);
      }
    }
  }

  void _onSoundLevelUpdate(Int8List event){
    final val = _getVolume(event);
    // print(val);
    _setAmplitude(val);
  }

  bool _isTimeLeft(){
    final dif = lastWave.difference(DateTime.now());
    return dif < Duration(milliseconds: -100);
  }

  @override
  void initState() {
    super.initState();

    _siriWaveController = SiriWaveController(amplitude: 0, speed: speed);
    _siriAnimationController = AnimationController(value: 0.0, duration: Duration(milliseconds: 1000), vsync: this);
    _siriAnimationController.addListener(() {
      /// Выставляем амплитуду для siriWave
      _siriWaveController.setAmplitude(_siriAnimationController.value);
    });

    /// Получаем информацию об амплитудах звука /// Временно отключено
    app.soundLevelStream.listen((event) {
      _onSoundLevelUpdate(event);
    });

    if (playbackStateSubscription == null) {
      playbackStateSubscription = AudioService.playbackStateStream.listen((event) {
        if (event.processingState == AudioProcessingState.error) {
          _showError('');
        }
        setState(() {});
      });
    }

    _animationController = AnimationController(vsync: this, lowerBound: 0);
    _animationController.reset();

    //prevTrack = new Track();

    recalcAnimationDurationLine();

    widget.setRecalcAnimation(recalcAnimationDurationLine);
  }

  /// Высчитываем время текущего трека
  void recalcAnimationDurationLine() {
    if(app.currentStation.value==null) return;
    List<Track> getTrackList = app.currentStation.value!.getTrackList();

    if (getTrackList.length > 0) {
      Track getFirstTrack = app.currentStation.value!.getTrackList()[0];

      // print("start: ${getFirstTrack.startTime}, end: ${getFirstTrack.endTime}");
      Duration trackLeftDuration = getFirstTrack.endTime.difference(getFirstTrack.startTime);

      int diffTime = getFirstTrack.endTime.difference(DateTime.now().toUtc().add(Duration(hours: 3))).inMilliseconds;

      double calc = -(diffTime - int.parse(app.currentStation.value!.playback?.len ?? '')) /
          int.parse(app.currentStation.value!.playback?.len ?? '');
      if(mounted) {
        if (prevTrack?.index != getFirstTrack.index) {
          prevTrack = getFirstTrack;
          _animationController.reset();
        }
        if (_animationController.value <= calc ||
            true) { //Проверять оставшиеся время и обновлять AnimationController в любом случае
          _animationController.duration = trackLeftDuration;
          _animationController.forward(from: calc);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if(!app.player.playing){
      Future.microtask(() => _setAmplitude(0));
    }
    return Container(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: size.w1 * 150,
          maxHeight: size.w1 * 275,
        ),
        child: widget.isPlayer ? _mainPlayer : _customWave ///_wave Анимация волны, пока скрываем и показываем обложку  TODO create Wave visualization
      ),
    );
  }
  Widget get _mainPlayer{
    final height = widget.isDonation ? 157 : 199;
  final placeholder = SvgPicture.asset(AppImages.logo_text);
  // final placeholder = Image.asset("assets/general/default-poster.png", fit: BoxFit.cover);
   return SizedBox(
     height: size.w1 * height,
     child: Center(
       child: SizedBox(
         height: size.w1 * height,
         width: size.w1 * height,
         child: Stack(
           children: [
             /// Обложка
             Center(
               child: Container(
                 width: size.w1 * height * 0.94,
                 height: size.w1 * height * 0.94,
                 child: Material(
                   shape: ContinuousRectangleBorder(
                     borderRadius: BorderRadius.circular(size.w1 * continuousRadius),
                   ),
                   clipBehavior: Clip.antiAliasWithSaveLayer,
                   child: app.currentStation.value?.current_artwork == null
                       ? placeholder
                       : Image.network(
                     app.currentStation.value!.current_artwork!+"?id=2", fit: BoxFit.cover,
                     loadingBuilder: (c, w, event){
                       if(event==null) return w;
                       return placeholder;
                     },
                     errorBuilder: (c,w,_){
                       return placeholder;
                     },
                   ),
                 ),
               ),
             ),
             /// ProgressIndicator текущего трека по времени
             Center(
               child: new SizedBox(
                 width: size.w1 * 199,
                 height: size.w1 * 199,
                 child: AnimatedBuilder(
                   animation: CurvedAnimation(
                     parent: _animationController,
                     curve: Curves.fastLinearToSlowEaseIn,
                   ),
                   builder: (context, child) {
                     return new CustomPaint(
                       painter: new _ArcPainter(_animationController.value),
                     );
                   },
                 ),
               ),
             ),
           ],
         ),
       ),
     ),
   );
  }

  /// Концепт анимации волны
  Widget get _customWave =>
      SizedBox(
    height: size.h1 * 100,
    width: double.infinity,
    child: Stack(
      children: [
        NewSiriWaveWidget(
          controller: _siriWaveController,
        ),
      ],
    ),
  );

  double _getVolume(Int8List waveData){
    if(app.player.loading || !app.player.playing){
      return 0;
    }
    final byteData = ByteData.sublistView(waveData);
    int value = byteData.getInt16(0, Endian.little);
    final result = value.abs() / 255;
    return result > 1 ? 0 : result;
  }

  Future<void> _showError(String? message) async {
    final String defaultErrorMessage = 'Ошибка воспроизведения. Попробуйте позже';
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          if (Platform.isIOS) {
            return CupertinoAlertDialog(
              title: const Text('Ошибка'),
              content: Text(message ?? defaultErrorMessage),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          } else {
            return AlertDialog(
              title: const Text('Ошибка'),
              content: Text(message ?? defaultErrorMessage),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          }
        });
  }

  @override
  void dispose() {
    playbackStateSubscription?.cancel();
    _animationController.dispose();
    _siriAnimationController.dispose();
    super.dispose();
  }
}

class _ArcPainter extends CustomPainter {
  final double fraction;

  _ArcPainter(this.fraction);

  @override
  bool shouldRepaint(_ArcPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final theme = AppNavigation.theme;
    final greyPaint = Paint()
      ..color = theme.buttonColor.withOpacity(0.08)
      ..strokeWidth = AppNavigation.sizeScales.w1 * 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final bluePaint = Paint()
      ..color = AppColors.darkBlue
      ..strokeWidth = AppNavigation.sizeScales.w1 * 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

      final path = Path();
      final width = size.width, height = size.height;
      final tradius = AppNavigation.sizeScales.w1 * (PlayerWidgetState.continuousRadius * 1.1);
      final left = 0.0, top = 0.0, right = width, bottom = height;
      path
        ..moveTo(right - tradius, top)
        ..cubicTo(right, top, right, top, right, top + tradius)
        ..lineTo(right, bottom - tradius)
        ..cubicTo(right, bottom, right, bottom, right - tradius, bottom)
        ..lineTo(left + tradius, bottom)
        ..cubicTo(left, bottom, left, bottom, left, bottom - tradius)
        ..lineTo(left, top + tradius)
        ..cubicTo(left, top, left, top, left + tradius, top)
        ..close();
      final resPath = new Path();

      var currentLength = 0.0;
      var metricsIterator = path.computeMetrics().iterator;
      while (metricsIterator.moveNext()) {
        var metric = metricsIterator.current;
        final length = metric.length * (fraction);
        var nextLength = currentLength + metric.length;
        final isLastSegment = nextLength > length;
        if (isLastSegment) {
          final remainingLength = length - currentLength;
          final pathSegment = metric.extractPath(0.0, remainingLength);
          resPath.addPath(pathSegment, Offset.zero);
          break;
        } else {
          final pathSegment = metric.extractPath(0.0, metric.length);
          resPath.addPath(pathSegment, Offset.zero);
        }
        currentLength = nextLength;
      }
      canvas.drawPath(path, greyPaint);
      canvas.drawPath(resPath, bluePaint);
  }
}
