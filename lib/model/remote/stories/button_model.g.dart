// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'button_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ButtonModel _$ButtonModelFromJson(Map<String, dynamic> json) {
  return ButtonModel(
    is_show: json['is_show'] as bool,
    title: json['title'] as String,
    action: json['action'] == null
        ? null
        : ActionModel.fromJson(json['action'] as Map<String, dynamic>),
    background_color: json['background_color'] as String,
    text_color: json['text_color'] as String,
  );
}

Map<String, dynamic> _$ButtonModelToJson(ButtonModel instance) =>
    <String, dynamic>{
      'is_show': instance.is_show,
      'title': instance.title,
      'action': instance.action,
      'background_color': instance.background_color,
      'text_color': instance.text_color,
    };

ActionModel _$ActionModelFromJson(Map<String, dynamic> json) {
  return ActionModel(
    url: json['url'] as String,
    type: json['type'] as String,
  );
}

Map<String, dynamic> _$ActionModelToJson(ActionModel instance) =>
    <String, dynamic>{
      'url': instance.url,
      'type': instance.type,
    };
