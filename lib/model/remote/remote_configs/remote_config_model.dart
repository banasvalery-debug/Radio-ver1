/// flutter pub run build_runner build --delete-conflicting-outputs
import 'package:json_annotation/json_annotation.dart';

part 'remote_config_model.g.dart';

@JsonSerializable()
class RemoteConfigModel{
  final String? title, text, linkUrl;

  RemoteConfigModel({this.title, this.text, this.linkUrl});

  factory RemoteConfigModel.fromJson(Map<String, dynamic> json) => _$RemoteConfigModelFromJson(json);

  Map<String, dynamic> toJson() => _$RemoteConfigModelToJson(this);

  @override
  toString() => toJson().toString();
}