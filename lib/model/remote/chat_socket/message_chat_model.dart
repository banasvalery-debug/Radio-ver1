/// flutter pub run build_runner build --delete-conflicting-outputs
import 'package:json_annotation/json_annotation.dart';

part 'message_chat_model.g.dart';

@JsonSerializable()
class MessageChatModel{
  final String id;
  final int userId;
  final String username;
  final String message;
  final String? userAvatar;
  final String timestamp;

  MessageChatModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.message,
    this.userAvatar,
    required this.timestamp,
  });

  factory MessageChatModel.fromJson(Map<String, dynamic> json) => _$MessageChatModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageChatModelToJson(this);

  @override
  toString() => this.toJson().toString();
}