import 'dart:math';
import 'dart:typed_data';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:voicetruth/data/constants/app_colors.dart';
import 'package:voicetruth/data/constants/app_textstyles.dart';
import 'package:voicetruth/model/remote/stories/story_model.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/ui/screens/home/stories/stories_screen.dart';
import 'package:voicetruth/ui/widgets/player/PlayerWidget.dart';

class StoryItemWidget extends StatefulWidget {
  final StoryModel storyModel;
  final Color backgroundColor;
  final String? url;
  final String? text;
  final Widget? child;
  final bool withCenter, unread;
  final bool isFavourite;

  final bool isClickable;
  final Function(bool) setClick;
  const StoryItemWidget({Key? key, this.backgroundColor: AppColors.blue, this.url, this.text, this.child, this.withCenter:true, this.unread : false,required this.storyModel, this.isFavourite : false,
    required this.isClickable,
    required this.setClick}) : super(key: key);

  @override
  _StoryItemWidgetState createState() => _StoryItemWidgetState();
}

class _StoryItemWidgetState extends State<StoryItemWidget> with TickerProviderStateMixin {
  late AnimationController _animationController, _scaleAnimation;
  late bool isLoading;
  @override
  void initState() {
    isLoading = false;
    _animationController = AnimationController(vsync: this);
    _scaleAnimation = AnimationController(vsync: this);
    Future.delayed(Duration(milliseconds: 550), (){
      // _startAnimation();
    });
    super.initState();
  }
  /// Анимация прогрузки
  void _startAnimation() {
    if(mounted) {
      _animationController.stop();
      _animationController.reset();
      _animationController.repeat(
        period: Duration(seconds: 2),
      );
    }
  }
  /// Анимация нажатия Scale
  void _startScaleAnimation(){
    if(mounted) {
      _scaleAnimation.reset();
      _scaleAnimation.duration = Duration(milliseconds: 100);
      _scaleAnimation.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final body = GestureDetector(
      onTap: ()async{
        _startScaleAnimation();
        await Future.delayed(Duration(milliseconds: 50));
        _openStory(context);
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, c) {
          final value = _scaleAnimation.value;
          final scale = (value < 0.5 ? value : 1-value) * 0.2;
          return Transform.scale(
            scale: 1 - scale,
              child: c!
          );
        },
        child: Container(
          height: size.w1 * 97,
          width: size.w1 * 97,
          padding: widget.unread || isLoading ? EdgeInsets.all(size.w1) : null,
          child: Stack(
            children: [
              if(widget.unread || isLoading)
                Positioned.fill(
                  child: CustomPaint(
                    painter: _ArcProgressIndicatorPainter(animation: _animationController, isLoaded: !isLoading),
                  ),
                ),
              Card(
                color: Colors.transparent,
                elevation: 0,
                margin: EdgeInsets.zero,
                child: Hero(
                  tag: "story${widget.storyModel.id}",
                  child: Padding(
                    padding: EdgeInsets.all(widget.unread || isLoading ? size.w1 * 2.5 : 0),
                    child: Material(
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(size.w1 * 45),
                      ),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: widget.backgroundColor,
                        ),
                        child: Stack(
                          children: [
                            if(widget.url!=null)
                              Positioned.fill(child: Image.network(
                                widget.url!, fit: BoxFit.cover,
                                errorBuilder: (context, c, st)=>SizedBox(),
                              )),
                            if(widget.storyModel.title.isNotEmpty)
                              Positioned(
                                bottom: size.w1 * 10,
                                left: size.w1 * 12, right: 0,
                                child: Text(widget.storyModel.title, style: AppTextStyles.white10w500,textAlign: TextAlign.left,),
                              ),
                            if(widget.child!=null)
                              Positioned(
                                top: size.w1 * 15,
                                left: size.w1 * 10,
                                child: widget.child!,
                              ),
                          ],
                        ),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return widget.withCenter ? Center(
      child: body,
    ) : body;
  }

  _openStory(BuildContext context)async{
    if(widget.isClickable) {
      _setLoading(true);
      _startAnimation();

      widget.setClick(false);
      if (widget.storyModel.slides.length > 0) {
        var slide = widget.storyModel.slides.first;
        if(!widget.storyModel.full_viewed){
          slide = widget.storyModel.slides.firstWhere((element) => !element.viewed);
        }
        if(!slide.media.isVideo) {
          final precache = await precacheImage(
              NetworkImage(slide.background), context);
        }
        Future.microtask(()async{
          bool wasPlaying = false;
          if(AudioService.playbackState.playing == true){
            app.player.pause();
            wasPlaying = true;
          }
          await AppNavigation.toStories(widget.storyModel, widget.isFavourite);
          if(wasPlaying){
            app.player.play();
          }
        });
      }
      widget.setClick(true);

      _setLoading(false);
    }
  }

  _setLoading(bool loading){
    // if(mounted)
    setState(() {
      isLoading = loading;
    });
  }


  @override
  void dispose() {
    _animationController.dispose();
    _scaleAnimation.dispose();
    super.dispose();
  }
}

/// Отрисованный ContinousProgress Indicator
/// Логика взята из ContinousRectangleBorder
class _ArcProgressIndicatorPainter extends CustomPainter {
  final Animation<double> animation;
  final bool isLoaded;

  _ArcProgressIndicatorPainter({required this.animation, this.isLoaded : true}) : super(repaint: animation);

  @override
  bool shouldRepaint(_ArcProgressIndicatorPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final percentage = isLoaded ? 1 : animation.value;

    final theme = AppNavigation.theme;
    final bluePaint = Paint()
      ..color = AppColors.darkBlue
      ..strokeWidth = AppNavigation.sizeScales.w1 * 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

      final path = Path();
      final width = size.width, height = size.height;
      final tradius = AppNavigation.sizeScales.w1 * (45 * 1.1);
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
        final length = metric.length * (percentage);
        var nextLength = currentLength + metric.length;
        final isLastSegment = nextLength > length;
        if (isLastSegment) {
          final remainingLength = length - currentLength;
          final pathSegment = metric.extractPath(0.0, remainingLength,);
          resPath.addPath(pathSegment, Offset.zero,);
          break;
        } else {
          final pathSegment = metric.extractPath(0.0, metric.length);
          resPath.addPath(pathSegment, Offset.zero);
        }
        currentLength = nextLength;
      }
      // canvas.drawPath(path, greyPaint);
      canvas.drawPath(resPath, bluePaint);
  }
}
