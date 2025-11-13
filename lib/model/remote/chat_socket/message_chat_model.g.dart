// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageChatModel _$MessageChatModelFromJson(Map<String, dynamic> json) {
  return MessageChatModel(
    id: json['id'] as String,
    userId: json['userId'] as int,
    username: json['username'] as String,
    message: json['message'] as String,
    userAvatar: json['userAvatar'] as String?,
    timestamp: json['timestamp'] as String,
  );
}

Map<String, dynamic> _$MessageChatModelToJson(MessageChatModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'username': instance.username,
      'message': instance.message,
      'userAvatar': instance.userAvatar,
      'timestamp': instance.timestamp,
    };
