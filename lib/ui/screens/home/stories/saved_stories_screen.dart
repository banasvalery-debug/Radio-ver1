import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:voicetruth/data/constants/app_images.dart';
import 'package:voicetruth/model/remote/stories/story_model.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/ui/widgets/drawer/DrawerContent.dart';
import 'package:voicetruth/ui/widgets/stories/story_item_widget.dart';
import 'package:voicetruth/utils/CustomAppThemeData.dart';

class SavedStoriesScreen extends StatefulWidget {
  const SavedStoriesScreen({Key? key}) : super(key: key);

  @override
  _SavedStoriesScreenState createState() => _SavedStoriesScreenState();
}

class _SavedStoriesScreenState extends State<SavedStoriesScreen>
    with TickerProviderStateMixin {
  CustomAppThemeData get theme => AppNavigation.theme;

  bool isEdit = false;

  late bool isClickable = true;

  late AnimationController animationController;
  late Animation<double> animation;
  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      lowerBound: 0.8,
      value: 0,
      upperBound: 1,
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..addListener(() => setState(() {}));
    animation = CurvedAnimation(
        parent: animationController, curve: Curves.elasticInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.secondaryBackground,
      appBar: AppBar(
        backgroundColor: theme.secondaryBackground,
        elevation: 0,
        leading: TextButton(
          onPressed: AppNavigation.pop,
          child: Text(
            "Закрыть",
            style:
                theme.textTheme.dark16w600.copyWith(color: theme.primaryColor),
          ),
        ),
        centerTitle: true,
        title: Text(
          "Сохраненные",
          style: theme.textTheme.dark16w600,
        ),
        actions: [
          TextButton(
            onPressed: _isEditPressed,
            child: Text(
              isEdit ? "Готово" : "Изменить",
              style: theme.textTheme.dark16w600
                  .copyWith(color: theme.primaryColor),
            ),
          )
        ],
        leadingWidth: size.w1 * 100,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.w1 * 14),
        child: ListView(
          children: [
            SizedBox(
              height: size.h1 * 6,
            ),
            StreamBuilder<List<StoryModel>>(
              stream: app.stories.favStoriesStream,
              builder: (context, snapshot) {
                return Wrap(
                  runSpacing: size.h1 * 20,
                  alignment: WrapAlignment.spaceAround,
                  children: [
                    ...app.stories.favouriteStories.map((e) {
                      final child = Stack(
                        children: [
                          StoryItemWidget(
                            isFavourite: true,
                            storyModel: e,
                            withCenter: false,
                            unread: false,
                            url: e.preview,
                            text: e.title,
                            setClick: (v) {
                              isClickable = v;
                              setState(() {});
                            },
                            isClickable: isClickable,
                          ),
                          if (isEdit)
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                transform: Matrix4.translationValues(
                                    size.w1 * -4, size.w1 * -4, 0),
                                height: size.w1 * 24,
                                width: size.w1 * 24,
                                child: GestureDetector(
                                    onTap: () {
                                      app.stories.saveStory(false, e);
                                    },
                                    child: SvgPicture.asset(app.getAssetsFolder(
                                        "cancel_icon_filled${theme.isDark ? "_dark" : ""}.svg",
                                        true))),
                              ),
                            ),
                        ],
                      );
                      return SizedBox(
                        height: size.w1 * 97,
                        width: size.w1 * 97,
                        child: Transform.scale(
                          scale:
                              animationController.isAnimating ? animation.value : 1,
                          child:animationController.isAnimating ? RotationTransition(
                            turns: animation,
                            child: child,
                          ) : child,
                        ),
                      );
                    }),
                    for(int i=0;i<app.stories.favouriteStories.length%3;i++)
                      SizedBox(width: size.w1 * 97,)
                  ],
                );
              }
            ),
          ],
        ),
      ),
    );
  }

  double get value => animationController.value;

  _isEditPressed() {
    setState(() => isEdit = !isEdit);
    if (isEdit)
      animationController.repeat(reverse: true);
    else {
      animationController.value = 0;
      animationController.stop();
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class StoryItemClass {
  final bool unread;
  final String? photoUrl;
  final String text;

  StoryItemClass({this.unread: false, this.photoUrl, this.text: ''});
}
