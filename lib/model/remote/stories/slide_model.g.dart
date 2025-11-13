// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slide_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SlideModel _$SlideModelFromJson(Map<String, dynamic> json) {
  return SlideModel(
    id: json['id'] as int,
    title: json['title'] as String?,
    description: json['description'] as String?,
    button: json['button'] == null
        ? null
        : ButtonModel.fromJson(json['button'] as Map<String, dynamic>),
    sort_order: json['sort_order'] as int,
    background: json['background'] as String,
    media: MediaModel.fromJson(json['media'] as Map<String, dynamic>),
    viewed: json['viewed'] as bool,
  );
}

Map<String, dynamic> _$SlideModelToJson(SlideModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'button': instance.button,
      'sort_order': instance.sort_order,
      'background': instance.background,
      'media': instance.media,
      'viewed': instance.viewed,
    };

MediaModel _$MediaModelFromJson(Map<String, dynamic> json) {
  return MediaModel(
    duration: (json['duration'] as num).toDouble(),
    type: json['type'] as String,
    orientation: json['orientation'] as String,
    path: json['path'] as String,
  );
}

Map<String, dynamic> _$MediaModelToJson(MediaModel instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'type': instance.type,
      'orientation': instance.orientation,
      'path': instance.path,
    };
