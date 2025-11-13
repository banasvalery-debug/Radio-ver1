import 'package:voicetruth/model/remote/chat_socket/message_chat_model.dart';

class ChatItemModel{
  final MessageChatModel message;
  ChatItemModel(this.message);

  @override
  toString()=>message.toJson().toString();
}