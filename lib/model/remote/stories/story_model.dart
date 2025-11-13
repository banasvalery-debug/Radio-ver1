/// flutter pub run build_runner build --delete-conflicting-outputs
import 'package:json_annotation/json_annotation.dart';
import 'package:voicetruth/model/remote/station/station_get_model.dart';
import 'package:voicetruth/model/remote/stories/button_model.dart';
import 'package:voicetruth/model/remote/stories/slide_model.dart';
import 'package:voicetruth/model/remote/user_model/user_model.dart';

part 'story_model.g.dart';

@JsonSerializable()
class StoryModel{
  final int id;
  final String title;
  final String published_at;
  final String preview;
  final List<SlideModel> slides;
  int? likes_count;
  bool? is_liked;
  bool is_favourite;
  bool full_viewed;

  StoryModel({required this.id, required this.title,required this.published_at,
    required this.preview, required this.slides,
    required this.is_favourite, this.is_liked, this.likes_count,
    required this.full_viewed,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) => _$StoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$StoryModelToJson(this);

  @override
  toString() => toJson().toString();

  // static StoryModel getFakeStory(){
  //   return StoryModel(id: 1, title: "name name name", published_at: "30.01.2020", preview: "https://i.ibb.co/hHrd93z/11223344-2.jpg?v=29",
  //     slides: [
  //       SlideModel(
  //           id: 1, title: "title", description: "<p>111 222 333</p>", sort_order: 1, background: "https://i.ibb.co/hHrd93z/11223344-2.jpg?v=32",
  //         button: ButtonModel(is_show: true, title: "title", action: ActionModel(url: "vk.com",  type: "web_view"), background_color: "#ffffff", text_color: "#000000")
  //       ),
  //       SlideModel(id: 1, title: "title", description: "<p>description</p>", sort_order: 1, background: "https://i.ibb.co/hHrd93z/11223344-2.jpg?v=27"),
  //     ],
  //     is_favourite: false,
  //   );
  // }
}