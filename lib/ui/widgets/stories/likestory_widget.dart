import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:voicetruth/data/constants/app_images.dart';
import 'package:voicetruth/data/provider/api/stories_provider.dart';
import 'package:voicetruth/model/remote/stories/story_model.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/utils/logger.dart';

class LikeStoryWidget extends StatefulWidget {
  final StoryModel story;
  final bool isLike;
  final Function(bool? liked) setLike;
  final bool? liked;
  const LikeStoryWidget({Key? key, required this.story,required this.isLike,required this.setLike, this.liked}) : super(key: key);

  @override
  _LikeStoryWidgetState createState() => _LikeStoryWidgetState();
}

class _LikeStoryWidgetState extends State<LikeStoryWidget> {
  bool? get liked => widget.liked;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(!widget.isLike){
      return InkWell(
          onTap: () {
            if (!app.isAuthorized)
              AppNavigation.toAuth();
            else
              _setLike(false);
          },
          child: SvgPicture.asset(
            app.getAssetsFolder(
                AppImages.dislike_icon, true),
            width: size.w1 * 15,
            color: Colors.white.withOpacity(
                !(liked ?? true) ? 1 : 0.64),
          ));
    }
    else{
      return InkWell(
          onTap: () {
            if (!app.isAuthorized)
              AppNavigation.toAuth();
            else
              _setLike(true);
          },
          child: SvgPicture.asset(
            app.getAssetsFolder(
                AppImages.like_icon, true),
            width: size.w1 * 15,
            color: Colors.white.withOpacity(
                liked ?? false ? 1 : 0.64),
          ));
    }
  }

  _setLike(bool like) {
    instanceStoriesProvider.likeStory(like, widget.story.id);
    if(liked != true){
      if(like) widget.story.likes_count = (widget.story.likes_count??0) + 1;
    }
    if(liked == true){
      if(!like) widget.story.likes_count = (widget.story.likes_count??0) - 1;
    }
    logger.i(widget.story.likes_count);
    widget.setLike(like);
    widget.story.is_liked = like;
  }
}
