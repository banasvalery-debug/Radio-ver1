// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryModel _$StoryModelFromJson(Map<String, dynamic> json) {
  return StoryModel(
    id: json['id'] as int,
    title: json['title'] as String,
    published_at: json['published_at'] as String,
    preview: json['preview'] as String,
    slides: (json['slides'] as List<dynamic>)
        .map((e) => SlideModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    is_favourite: json['is_favourite'] as bool,
    is_liked: json['is_liked'] as bool?,
    likes_count: json['likes_count'] as int?,
    full_viewed: json['full_viewed'] as bool,
  );
}

Map<String, dynamic> _$StoryModelToJson(StoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'published_at': instance.published_at,
      'preview': instance.preview,
      'slides': instance.slides,
      'likes_count': instance.likes_count,
      'is_liked': instance.is_liked,
      'is_favourite': instance.is_favourite,
      'full_viewed': instance.full_viewed,
    };
