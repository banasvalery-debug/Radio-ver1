// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_user_post_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhoneUserPostResponse _$PhoneUserPostResponseFromJson(
    Map<String, dynamic> json) {
  return PhoneUserPostResponse(
    status_code: json['status_code'] as int,
    message: json['message'] as String,
    data: json['data'] == null
        ? null
        : UserModel.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PhoneUserPostResponseToJson(
        PhoneUserPostResponse instance) =>
    <String, dynamic>{
      'status_code': instance.status_code,
      'message': instance.message,
      'data': instance.data,
    };
