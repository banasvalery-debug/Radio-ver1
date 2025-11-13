import 'package:voicetruth/model/remote/chat_socket/chat_socket_request_model.dart';
import 'package:voicetruth/model/remote/chat_socket/send_message_chat_model.dart';

class ServerMessageChatRequest extends ChatSocketRequestModel{
  ServerMessageChatRequest(final String message) : super(
      commandType: "server_message",
      data: SendMessageChatModel(message: message)
  );
}