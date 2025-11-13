import 'package:voicetruth/model/remote/chat_socket/chat_socket_request_model.dart';
import 'package:voicetruth/model/remote/chat_socket/fb_token_chat_model.dart';

class ServerAuthChatRequest extends ChatSocketRequestModel{
  ServerAuthChatRequest(final String token) : super(
    commandType: "server_auth",
    data: FbTokenChatModel(fbToken: token)
  );
}