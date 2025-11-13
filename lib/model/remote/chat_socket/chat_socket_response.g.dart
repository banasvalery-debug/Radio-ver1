// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_socket_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatSocketHelloResponse _$ChatSocketHelloResponseFromJson(
    Map<String, dynamic> json) {
  return ChatSocketHelloResponse(
    commandType: json['commandType'] as String,
    data: HelloResponse.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ChatSocketHelloResponseToJson(
        ChatSocketHelloResponse instance) =>
    <String, dynamic>{
      'commandType': instance.commandType,
      'data': instance.data,
    };

HelloResponse _$HelloResponseFromJson(Map<String, dynamic> json) {
  return HelloResponse(
    message: json['message'] as String,
  );
}

Map<String, dynamic> _$HelloResponseToJson(HelloResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
    };

ChatSocketClientAuthResponse _$ChatSocketClientAuthResponseFromJson(
    Map<String, dynamic> json) {
  return ChatSocketClientAuthResponse(
    commandType: json['commandType'] as String,
    data: ClientAuthResponse.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ChatSocketClientAuthResponseToJson(
        ChatSocketClientAuthResponse instance) =>
    <String, dynamic>{
      'commandType': instance.commandType,
      'data': instance.data,
    };

ClientAuthResponse _$ClientAuthResponseFromJson(Map<String, dynamic> json) {
  return ClientAuthResponse(
    status: json['status'] as int,
  );
}

Map<String, dynamic> _$ClientAuthResponseToJson(ClientAuthResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
    };

ChatSocketClientLastMessagesResponse
    _$ChatSocketClientLastMessagesResponseFromJson(Map<String, dynamic> json) {
  return ChatSocketClientLastMessagesResponse(
    commandType: json['commandType'] as String,
    data: (json['data'] as List<dynamic>)
        .map((e) => MessageChatModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ChatSocketClientLastMessagesResponseToJson(
        ChatSocketClientLastMessagesResponse instance) =>
    <String, dynamic>{
      'commandType': instance.commandType,
      'data': instance.data,
    };

ChatSocketClientMessageResponse _$ChatSocketClientMessageResponseFromJson(
    Map<String, dynamic> json) {
  return ChatSocketClientMessageResponse(
    commandType: json['commandType'] as String,
    data: MessageChatModel.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ChatSocketClientMessageResponseToJson(
        ChatSocketClientMessageResponse instance) =>
    <String, dynamic>{
      'commandType': instance.commandType,
      'data': instance.data,
    };

ClientDeleteMessageResponse _$ClientDeleteMessageResponseFromJson(
    Map<String, dynamic> json) {
  return ClientDeleteMessageResponse(
    messageId: json['messageId'] as String,
  );
}

Map<String, dynamic> _$ClientDeleteMessageResponseToJson(
        ClientDeleteMessageResponse instance) =>
    <String, dynamic>{
      'messageId': instance.messageId,
    };

ChatSocketClientDeleteMessageResponse
    _$ChatSocketClientDeleteMessageResponseFromJson(Map<String, dynamic> json) {
  return ChatSocketClientDeleteMessageResponse(
    commandType: json['commandType'] as String,
    data: ClientDeleteMessageResponse.fromJson(
        json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ChatSocketClientDeleteMessageResponseToJson(
        ChatSocketClientDeleteMessageResponse instance) =>
    <String, dynamic>{
      'commandType': instance.commandType,
      'data': instance.data,
    };
