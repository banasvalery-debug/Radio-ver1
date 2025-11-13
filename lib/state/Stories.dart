import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:voicetruth/data/provider/api/stories_provider.dart';
import 'package:voicetruth/model/remote/stories/slide_model.dart';
import 'package:voicetruth/model/remote/stories/stories_get_response.dart';
import 'package:voicetruth/model/remote/stories/story_model.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/utils/logger.dart';

class Stories{
  List<StoryModel> stories = [];
  List<StoryModel> favouriteStories = [];

  final StreamController<List<StoryModel>> storiesStreamController = StreamController.broadcast();
  late Stream<List<StoryModel>> storiesStream = storiesStreamController.stream;

  final StreamController<List<StoryModel>> favStoriesStreamController = StreamController.broadcast();
  late Stream<List<StoryModel>> favStoriesStream = favStoriesStreamController.stream;

  Future<void> getStories()async{
    try{
      final response = await instanceStoriesProvider.getStories();
      if(response!=null){
        if(response.statusCode<300){
          final result = StoriesGetResponse.fromJson(json.decode(response.body));
          if(result.status_code<300){
            if(result.data != null){
              stories = result.data!;
              stories = [...stories.where((e) => !e.full_viewed), ...stories.where((e) => e.full_viewed)];
              storiesStreamController.add(stories);
              if(app.initialUri!=null){
                app.setInitialUri(app.initialUri!);
              }
            }
          }
        }
      }
    }catch(err){
      logger.e("ERROR", err);
    }
  }
  Future<void> getFavouriteStories()async{
    if(!app.isAuthorized) {
      await app.checkAuthorization();
      if(!app.isAuthorized) return;
    }
    try{
      favStoriesStreamController.add(favouriteStories);
      final response = await instanceStoriesProvider.getFavouriteStories();
      if(response!=null){
        logger.i(response.body);
        if(response.statusCode<300){
          final result = StoriesGetResponse.fromJson(json.decode(response.body));
          if(result.status_code<300){
            if(result.data != null){
              favouriteStories = result.data??[];
              favStoriesStreamController.add(favouriteStories);
            }
          }
        }
      }
    }catch(err){
      logger.e("ERROR", err);
    }
  }

  Future<void> saveStory(bool isSave, StoryModel storyModel)async{
    final response = await instanceStoriesProvider.saveStory(isSave, storyModel.id);
    try {
      if (isSave) {
        if(!favouriteStories.contains(storyModel)) favouriteStories.add(storyModel);
      }
      else
        favouriteStories.removeWhere((e) => e.id == storyModel.id);
    }catch(e){}
    getFavouriteStories();
  }

  void openStoryByLink(String id){
    final list = stories.where((e) => e.id == int.parse(id));
    if(list.length > 0){
      final story = list.first;
      AppNavigation.toStories(story);
    }
  }

  makeSlideWatched(StoryModel story, SlideModel slide)async{
    if(!slide.viewed && app.isAuthorized){
      Future.microtask(()async{
        final response = await instanceStoriesProvider.makeSlideWatched(story.id, slide.id);
      });
      final index = stories.indexOf(story);

      final slideIndex = story.slides.indexOf(slide);
      story.slides.remove(slide);
      slide.viewed = true;
      story.slides.insert(slideIndex, slide);

      // stories.remove(story);
      if(story.slides.length-1 == story.slides.indexOf(slide)){
        story.full_viewed = true;
        // stories.add(story);
        // stories.insert(index, story);
      }
      else{
        // stories.insert(index, story);
      }
      storiesStreamController.add(stories);
    }
  }
}