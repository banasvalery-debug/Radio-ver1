import 'package:another_transformer_page_view/another_transformer_page_view.dart';
import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:voicetruth/model/remote/stories/story_model.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/ui/widgets/stories/story_view_item_wdget.dart';
import 'package:voicetruth/utils/logger.dart';

class StoriesScreen extends StatefulWidget {
  final StoryModel story;
  final bool isFavourite;
  final bool showBackground;
  const StoriesScreen({Key? key,required this.story, this.isFavourite : false, this.showBackground : false}) : super(key: key);

  @override
  _StoriesScreenState createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> with SingleTickerProviderStateMixin {

  double currentPageValue = 0;

  bool dragging = false;
  double startPosition = 0, nowPosition = 0;

  late TransformerPageController _pageController;
  late List<StoryController?> _storyControllers;

  late Widget _body;

  late int _page;

  bool paused = false;

  late ValueNotifier<bool> _closingNotifier;


  @override
  void initState() {
    super.initState();

    _page = _getIndex();

    _storyControllers = [...stories.map((e) => null)];

    /// Указываем страница выбранного сториса
    _pageController = TransformerPageController(
        itemCount: stories.length,
      initialPage: _page
    );

    _closingNotifier = ValueNotifier(false);

    _setWidgets();
  }

  int _getIndex(){
    return stories.indexOf(widget.story);
  }

  /// Сохраняем виджет стэйт
  void _setWidgets(){
    _body = GestureDetector(
      /// Вертикальный Gesture, для скрытия сториса свайпом
      onVerticalDragStart: (d){
        // Ставим на паузу когда сторис двигается
        _pauseOrPlay(true);
        final pos = d.globalPosition;
        setState(() {startPosition = pos.dy;nowPosition = pos.dy;});
      },
      onVerticalDragUpdate: (d){
        final pos = d.globalPosition;
        setState(() {nowPosition = pos.dy;});
      },
      onVerticalDragEnd: (d){
        // Ставим на плэй когда сторис не двигается
        _pauseOrPlay(false);
        if((nowPosition-startPosition).abs()>150) _closeStories();
        else setState(() {startPosition = 0; nowPosition = 0;});},
      child: TransformerPageView.children(
        pageController: _pageController,
        physics: ClampingScrollPhysics(),
        transformer: PageTransformerBuilder(builder: (c, info){
          final pos = info.position??0;
          final width = size.width;
          final posPos = pos.abs();

          // Ставим на паузу когда сторис двигается
          if(posPos>0 && posPos<1) _pauseOrPlay(true);
          // Ставим на плэй когда сторис не двигается
          else if(!paused) _pauseOrPlay(false);
          return Stack(
            children: [
              ValueListenableBuilder<bool>(
                valueListenable: _closingNotifier,
                builder: (context, val, c) {
                  if(val) return SizedBox();
                  return Positioned.fill(
                      child: Container(
                        color: Colors.black,
                      )
                  );
                }
              ),
              Container(
                child: Opacity(
                  opacity: pos>=0 ? 1 : 1-posPos,
                  child: Transform.translate(
                    offset: Offset(pos>=0 ? 0 : (width * posPos),0),
                    child: Transform.scale(
                      scale: pos>=0 ? 1 : 1 - ( 0.1 * posPos ),
                      child: c,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
        onPageChanged: (page){
          if(page!=null) _page = page;
          setState(() {});
        },
        children: [
          for(int i=0;i<stories.length;i++)
            Stack(
              children: [
                StoryViewItemWidget(
                  story: stories[i],
                  nextPage: nextPage,
                  closePage: _closeStories,
                  setController: (controller){
                    /// Костыль - из-за анимации приходится ставить на паузу, из-за того что используем Hero, виджет инициализируется множество раз
                    _pauseOrPlay(true);

                    logger.i("${_storyControllers[i]} SS");
                    /// Для каждого сториса сохраняем его StoryController
                    _storyControllers[i] = controller;

                    logger.i("Set Controller ${_storyControllers[i]} $i ${stories[i].id}\n");
                  },
                  setPaused: (paused){
                    logger.i("SET PAUSED $paused");
                    this.paused = paused;
                    _pauseOrPlay(paused);
                  },
                ),
              ],
            ),
        ],
      )
    );
  }

  List<StoryModel> get stories => widget.isFavourite ? app.stories.favouriteStories : app.stories.stories;

  @override
  Widget build(BuildContext context) {
    final val = nowPosition - startPosition;
    return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: val, end: val),
        duration: Duration(milliseconds: 100),
        builder: (context, v, c){
          final d = 1 - (v/150).abs();
          final height = AppNavigation.sizeScales.height;
          final s = (height - (v).abs())/height;
          return Transform.scale(
            scale: s,
            child: Transform.translate(
              offset: Offset(0,nowPosition-startPosition),
              child: Hero(
                  tag: "story${stories[_page].id}",
                  child: _body
              ),
            ),
          );
        }
    );
  }

  void nextPage(){
    final page = (_pageController.page??0).round();
    if(page < stories.length - 1){
      _pageController.animateToPage(page + 1, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    }
    else {
      if(nowPosition == 0)
      _closeStories();
    }
  }

  void _closeStories(){
    _closingNotifier.value = true;

    AppNavigation.pop();
    _storyControllers.forEach((e) {
      e?.pause();
      e?.dispose();
    });
  }

  _pauseOrPlay(bool pause){
    try{
      if(pause){
        _storyControllers.forEach((e) {
          /// Bad state, after calling close. Оборачиваем в try из-за такой ошибки
          try {
            e?.pause();
          }catch(e){}
        });
      }
      else{
        final page = _pageController.page?.round();
        if(page!=null){
          _storyControllers[page]?.play();
        }
      }
    }catch(e){
      logger.e("ERROR", e);
    }
  }
}
