import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:voicetruth/data/constants/app_images.dart';
import 'package:voicetruth/model/remote/stories/story_model.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/app_navigation.dart';

class BookmarkAnimationWidget extends StatefulWidget {
  final StoryModel story;
  const BookmarkAnimationWidget({Key? key,required this.story}) : super(key: key);

  @override
  _BookmarkAnimationWidgetState createState() => _BookmarkAnimationWidgetState();
}

class _BookmarkAnimationWidgetState extends State<BookmarkAnimationWidget> with SingleTickerProviderStateMixin{
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 800),
        value: widget.story.is_favourite ? 0.5 : 0
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if (!app.isAuthorized) {
          AppNavigation.toAuth();
        } else {
          _setFavourite();
        }
      },
      child: SizedBox(
        height: size.w1 * 22,
          child: Lottie.asset(
              AppImages.bookmark_anim,
            controller: _animationController,
          )
      ),
    );
    // return InkWell(
    //     onTap: () async {
    //       if (!app.isAuthorized) {
    //         AppNavigation.toAuth();
    //       } else {
    //         _setFavourite();
    //       }
    //     },
    //     child: Icon(
    //       Icons.bookmark,
    //       color: Colors.white.withOpacity(
    //           widget.story.is_favourite ? 1 : 0.64),
    //     ));
  }

  _setFavourite(){
    app.stories.saveStory(
        !widget.story.is_favourite,
        widget.story);
    widget.story.is_favourite = !widget.story.is_favourite;
    _makeAnimation();
  }

  _makeAnimation(){
    if(widget.story.is_favourite){
      _animationController.value = 0;
      _animationController.animateTo(0.5);
    }
    else{
      _animationController.value = 0.5;
      _animationController.animateTo(1);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
