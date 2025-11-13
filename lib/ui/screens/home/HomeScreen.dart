import 'dart:async';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:voicetruth/data/constants/app_colors.dart';
import 'package:voicetruth/data/constants/app_images.dart';
import 'package:voicetruth/data/provider/api/auth_profile_provider.dart';
import 'package:voicetruth/model/remote/stories/story_model.dart';

import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/ui/widgets/bottom/BottomMenuWidget.dart';
import 'package:voicetruth/ui/widgets/bottom/call_to_stream_widget.dart';
import 'package:voicetruth/ui/widgets/buttons/ui_elevated_button.dart';
import 'package:voicetruth/ui/widgets/canvas/noise_anim_widget.dart';
import 'package:voicetruth/ui/widgets/chat/chat_widget.dart';
import 'package:voicetruth/ui/widgets/dialogs/error_dialog.dart';
import 'package:voicetruth/ui/widgets/drawer/DrawerContent.dart';
import 'package:voicetruth/ui/widgets/drawer/main_drawer.dart';
import 'package:voicetruth/ui/widgets/player/PlayerWidget.dart';
import 'package:voicetruth/ui/widgets/player/StatusBarWidget.dart';
import 'package:voicetruth/ui/widgets/stories/stories_folder_item.dart';
import 'package:voicetruth/ui/widgets/stories/story_item_widget.dart';
import 'package:voicetruth/ui/widgets/top/TopMenuWidget.dart';
import 'package:voicetruth/ui/widgets/top/donation_widget.dart';
import 'package:voicetruth/ui/widgets/wave/custom_wave_widget.dart';
import 'package:voicetruth/utils/CustomAppThemeData.dart';
import 'package:voicetruth/utils/app_theme_notifier.dart';
import 'package:loader_overlay/loader_overlay.dart';

class HomeErrorScreen extends StatelessWidget {
  const HomeErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: app.dataLoadedStream,
        builder: (context, snapshot){
        ///Проверяем прогрузились ли данные с интернета
          final loaded = snapshot.data??app.loaded;
          ///Переходим на HomeScreen
          if(loaded){
            Future.microtask(() => AppNavigation.toHome());
            return Scaffold();
          }
          ///Выдаем страница ошибки подключения
          return _reloadWidget(context);
        }
    );
  }

  Widget _reloadWidget(BuildContext context){
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.w1 * 24),
          child: ErrorCustomDialog(
            buttonText: "Обновить",
            description: "Если у вас возникают проблемы с подключением и не можете перейти в приложения, попробуйте его обновить.",
            asset: app.getAssetsFolder(AppImages.error_icon, true),
            onPressed: ()async{
              context.loaderOverlay.show();
              await app.init();
              context.loaderOverlay.hide();
            },
          ),
        ),
      ),
    );
  }
}

class PlayerMainWidget extends StatelessWidget {
  final Widget child;
  const PlayerMainWidget({Key? key,required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class TrackListWidget extends StatelessWidget {
  final Widget child;
  const TrackListWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}




class HomeScreen extends StatefulWidget {
  @override
  createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final GlobalKey<PlayerWidgetState> _playerWidgetState = GlobalKey<PlayerWidgetState>();
  VoidCallback? _recalcAnimationDurationLine;
  Timer? _loadPlaybackInfoTimer;

  bool sound = false;

  bool isPlayer = true;

  late bool isClickable = true;

  late int _page;
  late PageController _pageController;
  late Widget _chatWidget;

  CustomAppThemeData get theme => CustomAppThemeData.of(context);

  @override
  void initState() {
    super.initState();

    ///Проверяем авторизацию
    app.checkAuthorization().then((value){
      /// Переносим страницу если информация об авторизация получалось слишком долго
      try{
        if(app.isAuthorized && _page!=1){
          _pageController.jumpToPage(1);
          _page = 1;
        }
      }catch(e){
      }
    });

    ///Если пользователь авторизован то открываем 1 страницу, так как 0 будет чат, если неавторизован выдаем 0, так как чата не будет
    _page = app.isAuthorized ? 1 : 0;
    _pageController = PageController(initialPage: app.isAuthorized ? 1 : 0);

    _chatWidget = ChatWidget(
      onBackPressed: closeChat,
    );

    ///Получаем истории
    app.stories.getStories();
    ///Получаем сохраненные истории
    app.stories.getFavouriteStories();
    ///Получаем информацию о профиле
    app.getProfile();

    // Обновляем данные по станции
    _loadPlaybackInfoTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      app.stories.getStories();
      app.getStations();
      await app.currentStation.value!.loadData();
      if(_recalcAnimationDurationLine!=null) _recalcAnimationDurationLine!();
      if(mounted) setState(() {});
    });

    /// Отправляем FCM токен на сервер
    FirebaseMessaging.instance.getToken().then((value){
      if(app.isAuthorized) if(value!=null) instanceAuthProfileProvider.userFcmTokenAttach(value);
    });

   context.loaderOverlay.hide();
  }

  void openDrawer(){
    _pageController.animateToPage(app.isAuthorized ? 2 : 1, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }
  void closeDrawer(){
    _pageController.animateToPage(app.isAuthorized ? 1 : 0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void openChat(){
    _pageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }
  void closeChat(){
    _pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      if(app.isAuthorized) _chatWidget,
      PlayerMainWidget(child: _content()),
      TrackListWidget(
        child: DecoratedBox(
            decoration: BoxDecoration(
                color: theme.drawerBack
            ),
            child: DrawerContent(onBack: closeDrawer,)
        ),
      )
    ];
    // throw Exception("Page test exception");
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: ClampingScrollPhysics(),
        children: pages,
        onPageChanged: (page){
          FocusScope.of(context).unfocus();
          _page = page;
          Sentry.addBreadcrumb(Breadcrumb(
            message: "PageView page changed",
            category: "pageview navigation",
            data: {
              "widget": pages[page],
              "page": pages[page] is ChatWidget ? "chat" :
                  pages[page] is PlayerMainWidget ? "player" : "tracklist"
            }
          ));
        },
      ),
    );

  }

  Widget _content(){
    //Выставляем параметр если донаты включены, пока нету информации с бэка
    bool isDonation = false;

    final _donateWithStories = SizedBox(
      height: size.w1 * 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          if(isDonation == true) DonationWidget(),
          SizedBox(width: size.w1 * 15,),
          ///Стрим историй
          StreamBuilder<List<StoryModel>>(
              stream: app.stories.storiesStream,
              builder: (context, snapshot){
                final stories = snapshot.data ?? app.stories.stories;
                return Row(
                  children: [
                    for(int i=0;i<stories.length;i++)
                      ...[
                        StoryItemWidget(
                          // key: GlobalKey(),
                          url: stories[i].preview,
                          text: stories[i].title,
                          unread: !stories[i].full_viewed,
                          storyModel: stories[i],
                          isClickable: isClickable,
                          setClick: (v) {
                            isClickable = v;
                            setState(() {});
                          },
                        ),
                        SizedBox(width: size.w1 * 15,),
                      ]
                  ],
                );
              }
          ),
          /// Стрим сохраненных историй
          StreamBuilder(
              stream: app.stories.favStoriesStream,
              builder: (context, s){
                if(app.stories.favouriteStories.length==0) return SizedBox();
                return StoriesFolderItem();
              }),

          SizedBox(width: size.w1 * 15,),
        ],
      ),
    );

    return _frame(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          children: [
            Column(
              children: [
                SizedBox(height: size.h1 * 4),
                TopMenuWidget(
                  isPlayer: isPlayer,
                  onChangePlayer: (v) => setState(() => isPlayer = v),
                  onDrawer: () => openDrawer(),
                  onChat: () => openChat(),
                ),
                if(size.height >= 600)
                ...[SizedBox(height: size.height * 0.034), _donateWithStories]
              ],
            ),
          ],
        ),
        ///Если размер экрана слишком маленький
        if(size.height < 600) _donateWithStories,
        ValueListenableBuilder(
          valueListenable: app.currentStation,
          builder: (context, c, d){
            return PlayerWidget(
                isDonation: isDonation || true,
                 /// Скрываем пока показ волны не настроен на ios
                 isPlayer: true || !(app.currentStation.value?.in_live??false),
              setRecalcAnimation: (callback){
                  _recalcAnimationDurationLine = callback;
              },
            );
          },
        ),
        StatusBarWidget(),
        if(size.height < 600) BottomMenuWidget(),
        Column(
          children: [
            ///Если размер экрана достаточно большой чтобы разместить все виджеты по дизайну
            if(size.height >=600) ...[BottomMenuWidget(), SizedBox(height: size.height * 0.05)],
            Padding(
              padding: EdgeInsets.only(bottom: size.h1 * 28),
              child: CallToStreamWidget(),
            ),
          ],
        ),
      ],
    ));
  }
  Widget _frame(Widget child){
    return ClipRect(
      child: Stack(
        children: [
          Positioned.fill(child: Container(color: theme.background,)),
          Positioned(
            left: 0, right: 0,
            top: 0, bottom: 0,
            child: SafeArea(child: child,),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _loadPlaybackInfoTimer?.cancel();
    app.dispose();
    super.dispose();
  }
}
