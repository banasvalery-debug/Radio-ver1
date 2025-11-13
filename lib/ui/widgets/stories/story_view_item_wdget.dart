import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:story_view/story_view.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:voicetruth/data/constants/app_images.dart';
import 'package:voicetruth/data/constants/app_strings.dart';
import 'package:voicetruth/data/constants/app_textstyles.dart';
import 'package:voicetruth/data/provider/api/stories_provider.dart';
import 'package:voicetruth/model/remote/remote_configs/remote_config_model.dart';
import 'package:voicetruth/model/remote/stories/story_model.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/ui/screens/home/stories/slide_widget.dart';
import 'package:voicetruth/ui/widgets/stories/likestory_widget.dart';
import 'package:voicetruth/ui/widgets/stories/story_custom_button.dart';
import 'package:voicetruth/utils/hex_color.dart';
import 'package:voicetruth/utils/logger.dart';

import 'bookmark_animation_widget.dart';
import 'hook_stories.dart';

class StoryViewItemWidget extends StatefulWidget {
  final VoidCallback nextPage, closePage;
  final StoryModel story;
  final Function(bool paused) setPaused;
  final Function(StoryController storyController) setController;
  const StoryViewItemWidget(
      {Key? key,
      required this.nextPage,
      required this.story,
        required this.setController,
      required this.setPaused,
        required this.closePage
      })
      : super(key: key);

  @override
  _StoryViewItemWidgetState createState() => _StoryViewItemWidgetState();
}

class _StoryViewItemWidgetState extends State<StoryViewItemWidget> {

  late ValueNotifier<int> page;
  late ValueNotifier<bool?> likedNotifier;

  late StoryController _storyController;

  double bottom = 94;
  @override
  void initState() {
    page = ValueNotifier(0);
    likedNotifier = ValueNotifier(widget.story.is_liked);

    _storyController = StoryController();
    widget.setController(_storyController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(AppNavigation.context).padding;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: size.h1 * bottom,
            child: StoryView(
              controller: _storyController,
              inline: true,
              storyItems: [
                ...widget.story.slides.map((e) => StoryItem(
                      SlideWidget(
                        slide: e,
                        storyController: _storyController,
                        bottom: bottom,
                      ),
                      shown: e.viewed,
                      duration: Duration(milliseconds: (e.media.duration*1000).round()),
                    ))
              ],
              onComplete: widget.nextPage,
              onStoryShow: (item) {
                /// Определяем на каком сторисе мы сейчас находимся
                final slide = (item.view as SlideWidget).slide;
                page.value = widget.story.slides.indexOf(slide);

                Future.delayed(Duration(milliseconds: 100), (){
                  app.stories.makeSlideWatched(widget.story, slide);
                });
              },
            ),
          ),
          /// Показываем кнопку на этом экране, так как внутри StoryView нельзя создать кликабельный виджет
          ValueListenableBuilder<int>(
            valueListenable: page,
            builder: (context, page, c){
              final slide = widget.story.slides[page];
              if(slide.button?.is_show??false)
                return Positioned(
                    bottom: size.h1 * (141), // bottom + 47
                    left: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        if (slide.button!.action != null) {
                          if (slide.button!.action!.is_web) {
                            String url = slide.button!.action!.url;
                            if (!url.startsWith("http")) url = "https://$url";
                            launch(url);
                          }
                        }
                      },
                      behavior: HitTestBehavior.opaque,
                      child: StoryCustomButton(button: slide.button!,),
                    ));
              return Positioned(left: 0, top: 0,child: SizedBox());
            },
          ),
          /// Нижний бар с кнопками лайк/дизлайк "сохранить историю"
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
              child: Container(
                // padding: EdgeInsets.only(bottom: padding.bottom),
                color: Colors.black,
                child: SizedBox(
                  height: size.h1 * bottom,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: size.h1 * 13),
                        height: size.h1 * 50,
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: size.w1 * 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ValueListenableBuilder<bool?>(
                                  valueListenable: likedNotifier,
                                  builder: (context, value, c){
                                    return Row(
                                      children: [
                                        LikeStoryWidget(story: widget.story, isLike: false,
                                          liked: value,
                                          setLike: (bool? liked) {
                                            likedNotifier.value = liked;
                                          },),
                                        SizedBox(
                                          width: size.w1 * 8,
                                        ),
                                        Text(
                                          "",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        SizedBox(
                                          width: size.w1 * 8,
                                        ),
                                        LikeStoryWidget(story: widget.story, isLike: true,
                                          liked: value,
                                          setLike: (bool? liked) {
                                            likedNotifier.value = liked;
                                          },),
                                      ],
                                    );
                                  }
                              ),
                              Row(
                                children: [
                                  BookmarkAnimationWidget(story: widget.story,),
                                  SizedBox(width: size.w1 * 17),
                                  InkWell(
                                    onTap: (){
                                     _shareStory();
                                    },
                                    child: SvgPicture.asset(
                                      app.getAssetsFolder(AppImages.share_icon, true),
                                      width: size.w1 * 18,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: padding.top + 25,
            right: size.w1 * 15,
            child: IconButton(
                onPressed: widget.closePage,
                icon: SvgPicture.asset(
                    app.getAssetsFolder(AppImages.cancel_white_icon, true))),
          )
        ],
      ),
    );
  }

  Future<void> _shareStory()async{
    final remoteJson = RemoteConfig.instance.getString(AppStrings.share_app_story_json);
    final model = jsonDecode(remoteJson);
    final config = RemoteConfigModel.fromJson(model);

    widget.setPaused(true);
    await showDialog(context: context, builder: (context){
      return ShareStoryWidget(config: config, story: widget.story,
      storyController: _storyController,);
    });
    widget.setPaused(false);
  }


  @override
  void dispose() {
    logger.i("DISPOSE StoryView ${widget.story.id}");
    _storyController.dispose();
    super.dispose();
  }
}

class ShareStoryWidget extends StatefulWidget {
  final RemoteConfigModel config;
  final StoryModel story;
  final StoryController? storyController;
  const ShareStoryWidget({Key? key,required this.config,required this.story, this.storyController}) : super(key: key);

  @override
  _ShareStoryWidgetState createState() => _ShareStoryWidgetState();
}

class _ShareStoryWidgetState extends State<ShareStoryWidget> with WidgetsBindingObserver{

  RemoteConfigModel get config => widget.config;

  @override
  void initState() {
    logger.i("SHARE INIT");
    WidgetsBinding.instance?.addObserver(this);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _share();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    /// Костыль чтобы остановить сторис
    if(Platform.isAndroid)
    Future.microtask(()async{
      for(int i=0;i<10;i++){
        logger.i("STATUSSTORY ${widget.storyController?.playbackNotifier.valueWrapper?.value}");
        final status = widget.storyController?.playbackNotifier.valueWrapper?.value;
        if(status!=null){
          if(status!=PlaybackState.pause){
            widget.storyController?.pause();
          }
        }
        await Future.delayed(Duration(milliseconds: 100));
      }
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      AppNavigation.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  _share(){
    var text = config.text;
    var linkUrl = config.linkUrl;
    text = text?.replaceAll("{id}", "${widget.story.id}");
    linkUrl = linkUrl?.replaceAll("{id}", "${widget.story.id}");
    if(app.isAuthorized && app.user.value!=null){
      text = text?.replaceAll("{uid}", app.user.value!.id.toString());
      linkUrl = linkUrl?.replaceAll("{uid}", app.user.value!.id.toString());
    }
    FlutterShare.share(
        title: config.title??"",
        chooserTitle: Platform.isAndroid ? config.title : null,
        text: text,
        linkUrl: linkUrl,
      onCallback: Platform.isIOS
          ? (t){AppNavigation.pop();}
          : null
    );
  }
}
