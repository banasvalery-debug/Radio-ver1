import 'package:flutter/material.dart';
import 'package:voicetruth/model/remote/stories/story_model.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/ui/widgets/drawer/DrawerContent.dart';
import 'package:voicetruth/utils/CustomAppThemeData.dart';

class StoriesFolderItem extends StatelessWidget {
  const StoriesFolderItem({Key? key}) : super(key: key);

  CustomAppThemeData get theme => AppNavigation.theme;

  @override
  Widget build(BuildContext context) {
    final stories = app.stories.favouriteStories;
    return Center(
      child: InkWell(
        onTap: (){
          AppNavigation.toSavedStories();
        },
        child: Container(
          height: size.w1 * 97,
          width: size.w1 * 97,
          child: Material(
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(size.w1 * 55),
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.grey,
              ),
              child: Padding(
                padding: EdgeInsets.all(size.w1 * 9),
                child: Stack(
                  children: [
                    if(stories.length>0)
                      Positioned(
                        left: 0, top: 0,
                        child: _getItem(stories[0]),
                      ),
                    if(stories.length>1)
                    Positioned(
                      right: 0, top: 0,
                      child: _getItem(stories[1]),
                    ),
                    if(stories.length>2)
                    Positioned(
                      left: 0, bottom: 0,
                      child: _getItem(stories[2]),
                    ),
                    if(stories.length>3)
                    Positioned(
                      right: 0, bottom: 0,
                      child: _getItem(stories[3]),
                    )
                  ],
                ),
              ),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
          )
        ),
      ),
    );
  }

  Widget _getItem(StoryModel story) => SizedBox(
    width: size.w1 * 37, height: size.w1 * 37,
    child: Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.w1 * 13)),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.primaryColor,
        ),
        child: Image.network(story.preview),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
    ),
  );
}
