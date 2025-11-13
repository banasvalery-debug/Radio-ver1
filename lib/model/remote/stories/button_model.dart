/// flutter pub run build_runner build --delete-conflicting-outputs
import 'package:json_annotation/json_annotation.dart';
import 'package:voicetruth/model/remote/station/station_get_model.dart';
import 'package:voicetruth/model/remote/user_model/user_model.dart';

part 'button_model.g.dart';

@JsonSerializable()
class ButtonModel{
  final bool is_show;
  final String title;
  final ActionModel? action;
  final String background_color;
  final String text_color;

  ButtonModel({required this.is_show, required this.title, required this.action, required this.background_color, required this.text_color});

  factory ButtonModel.fromJson(Map<String, dynamic> json) => _$ButtonModelFromJson(json);

  Map<String, dynamic> toJson() => _$ButtonModelToJson(this);
}

@JsonSerializable()
class ActionModel{
  final String url;
  final String type;

  ActionModel({required this.url, required this.type});

  factory ActionModel.fromJson(Map<String, dynamic> json) => _$ActionModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActionModelToJson(this);

  bool get is_web => type == "web_view";
}