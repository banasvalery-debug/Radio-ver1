// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stories_get_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoriesGetResponse _$StoriesGetResponseFromJson(Map<String, dynamic> json) {
  return StoriesGetResponse(
    status_code: json['status_code'] as int,
    message: json['message'] as String,
    data: (json['data'] as List<dynamic>?)
        ?.map((e) => StoryModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$StoriesGetResponseToJson(StoriesGetResponse instance) =>
    <String, dynamic>{
      'status_code': instance.status_code,
      'message': instance.message,
      'data': instance.data,
    };
