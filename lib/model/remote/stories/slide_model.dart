/// flutter pub run build_runner build --delete-conflicting-outputs
import 'package:json_annotation/json_annotation.dart';
import 'package:voicetruth/model/remote/station/station_get_model.dart';
import 'package:voicetruth/model/remote/user_model/user_model.dart';

import 'button_model.dart';

part 'slide_model.g.dart';

@JsonSerializable()
class SlideModel{
  final int id;
  final String? title;
  final String? description;
  final ButtonModel? button;
  final int sort_order;
  final String background;
  final MediaModel media;
  bool viewed;

  SlideModel({required this.id, this.title,
    this.description, this.button, required this.sort_order,
    required this.background, required this.media,
    required this.viewed
  });

  factory SlideModel.fromJson(Map<String, dynamic> json) => _$SlideModelFromJson(json);

  Map<String, dynamic> toJson() => _$SlideModelToJson(this);

  @override
  toString() => this.toJson().toString();
}

@JsonSerializable()
class MediaModel{
  final double duration;
  final String type, orientation, path;
  MediaModel({required this.duration, required this.type, required this.orientation, required this.path});

  factory MediaModel.fromJson(Map<String, dynamic> json) => _$MediaModelFromJson(json);

  Map<String, dynamic> toJson() => _$MediaModelToJson(this);

  bool get isVertical => orientation == "vertical";
  bool get isVideo => type == "video";

  @override
  toString() => this.toJson().toString();
}