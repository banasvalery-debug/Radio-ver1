/// flutter pub run build_runner build --delete-conflicting-outputs
import 'package:json_annotation/json_annotation.dart';
import 'package:voicetruth/model/remote/station/station_get_model.dart';
import 'package:voicetruth/model/remote/stories/story_model.dart';
import 'package:voicetruth/model/remote/user_model/user_model.dart';

part 'stories_get_response.g.dart';

@JsonSerializable()
class StoriesGetResponse{
  final int status_code;
  final String message;
  final List<StoryModel>? data;

  StoriesGetResponse({required this.status_code, required this.message, this.data});

  factory StoriesGetResponse.fromJson(Map<String, dynamic> json) => _$StoriesGetResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StoriesGetResponseToJson(this);
}