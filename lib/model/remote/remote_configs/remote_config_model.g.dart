// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoteConfigModel _$RemoteConfigModelFromJson(Map<String, dynamic> json) {
  return RemoteConfigModel(
    title: json['title'] as String?,
    text: json['text'] as String?,
    linkUrl: json['linkUrl'] as String?,
  );
}

Map<String, dynamic> _$RemoteConfigModelToJson(RemoteConfigModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'text': instance.text,
      'linkUrl': instance.linkUrl,
    };
