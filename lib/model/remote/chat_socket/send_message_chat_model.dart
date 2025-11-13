/// flutter pub run build_runner build --delete-conflicting-outputs
import 'package:json_annotation/json_annotation.dart';

part 'send_message_chat_model.g.dart';

@JsonSerializable()
class SendMessageChatModel{
  final String message;

  SendMessageChatModel({required this.message});

  factory SendMessageChatModel.fromJson(Map<String, dynamic> json) => _$SendMessageChatModelFromJson(json);

  Map<String, dynamic> toJson() => _$SendMessageChatModelToJson(this);
}