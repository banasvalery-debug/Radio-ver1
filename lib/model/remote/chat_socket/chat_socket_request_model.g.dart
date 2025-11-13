// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_socket_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatSocketRequestModel _$ChatSocketRequestModelFromJson(
    Map<String, dynamic> json) {
  return ChatSocketRequestModel(
    commandType: json['commandType'] as String,
    data: json['data'],
  );
}

Map<String, dynamic> _$ChatSocketRequestModelToJson(
        ChatSocketRequestModel instance) =>
    <String, dynamic>{
      'commandType': instance.commandType,
      'data': instance.data,
    };
