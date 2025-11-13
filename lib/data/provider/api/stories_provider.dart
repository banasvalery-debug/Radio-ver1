import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:voicetruth/data/constants/api.dart';
import 'package:voicetruth/utils/http_helper.dart';
import 'package:voicetruth/utils/logger.dart';

class StoriesProvider{
  /// GET STORIES
  Future<Response?> getStories() async{
    final path = pathBuilderApi("stories/");
    final response = await getRequest(path);
    return response;
  }

  /// Like story
  Future<Response?> likeStory(bool isLike, int storyId) async{
    final path = pathBuilderApi("stories/like/");
    final payload = json.encode({
      "story_id" : storyId,
      "is_like" : isLike
    });
    final response = await postRequest(path, payload);
    return response;
  }

  ///save story
  Future<Response?> saveStory(bool isSave, int storyId) async{
    final path = pathBuilderApi("stories/favourites/${isSave ? "save" : "remove"}/");
    final payload = json.encode({
      "story_id" : storyId,
    });
    final response = await postRequest(path, payload);
    return response;
  }

  ///get saved stories
  Future<Response?> getFavouriteStories() async{
    final path = pathBuilderApi("stories/favourites/");
    final response = await getRequest(path);
    return response;
  }

  Future<Response?> makeSlideWatched(int storyId, int slideId) async{
    final path = pathBuilderApi("stories/viewed/");
    final payload = json.encode({
      "stories_id": storyId,
      "slide_id": slideId
    });
    logger.i("$path $payload");
    final response = await postRequest(path, payload);
    return response;
  }
}
final instanceStoriesProvider = StoriesProvider();