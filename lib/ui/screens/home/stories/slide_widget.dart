import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/story_view.dart';
import 'package:voicetruth/data/constants/app_textstyles.dart';
import 'package:voicetruth/model/remote/stories/slide_model.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/ui/widgets/stories/story_custom_button.dart';
import 'package:voicetruth/utils/hex_color.dart';

class SlideWidget extends StatefulWidget {
  final SlideModel slide;
  final StoryController storyController;
  final double bottom;
  const SlideWidget({Key? key,required this.slide,required this.storyController, this.bottom : 0}) : super(key: key);

  @override
  _SlideWidgetState createState() => _SlideWidgetState();
}

class _SlideWidgetState extends State<SlideWidget> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black
      ),
      child: Stack(
        children: [
          Positioned.fill(child: _getContent()),

          Positioned(
            /// выситываем расстояние для margin снизу
            bottom: size.h1 * (141 - widget.bottom),
              left: 0,
            right: 0,
            child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if((widget.slide.title??"").isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.w1 * 24),
                      child: Text(widget.slide.title!, style: AppTextStyles.white28w700,),
                    ),
                    if((widget.slide.description??"").isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.w1 * 18),
                      child: Html(
                          data: widget.slide.description,
                        style: {
                            "p": Style(
                              fontSize: FontSize(AppTextStyles.white14w400.fontSize),
                              color: AppTextStyles.white14w400.color
                            ),
                        },
                      ),
                    ),
                    ///Показвыаем здесь кнопку, но так как она не кликабельна делаем opacity: 0
                    if(widget.slide.button?.is_show??false)
                      Opacity(
                        opacity: 0,
                        child: StoryCustomButton(button: widget.slide.button!),
                      )
                  ],
                )
            ),
          )
        ],
      ),
    );
  }

  Widget _getContent(){
    if(widget.slide.media.isVideo)
      return StoryVideo.url(widget.slide.media.path, controller: widget.storyController, fit: widget.slide.media.isVertical ? BoxFit.cover : null);
    return _getImage();
  }

  Widget _getImage(){
    return Image.network(
      widget.slide.background,
      fit: BoxFit.cover,
      frameBuilder: (context, child, frame, wasSynchronized){
        return Container(
          color: Colors.black,
          child: child,
        );
      },
      loadingBuilder: ( context,  child, loadingProgress) {
        if (loadingProgress == null) {
          try{widget.storyController.play();}catch(e){}
          return child;
        }
        try{widget.storyController.pause();}catch(e){}
        return Container(
          color: Colors.black,
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null ?
              loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

final uu = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4";
