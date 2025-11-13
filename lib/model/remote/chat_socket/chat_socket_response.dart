/// flutter pub run build_runner build --delete-conflicting-outputs
import 'package:json_annotation/json_annotation.dart';
import 'package:voicetruth/model/remote/chat_socket/message_chat_model.dart';

part 'chat_socket_response.g.dart';

@JsonSerializable()
class ChatSocketHelloResponse{
  final String commandType;
  final HelloResponse data;

  ChatSocketHelloResponse({required this.commandType, required this.data});

  factory ChatSocketHelloResponse.fromJson(Map<String, dynamic> json) => _$ChatSocketHelloResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatSocketHelloResponseToJson(this);

  @override
  toString() => this.toJson().toString();
}

@JsonSerializable()
class HelloResponse{
  final String message;

  HelloResponse({required this.message});

  factory HelloResponse.fromJson(Map<String, dynamic> json) => _$HelloResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HelloResponseToJson(this);

  @override
  toString() => this.toJson().toString();
}

@JsonSerializable()
class ChatSocketClientAuthResponse{
  final String commandType;
  final ClientAuthResponse data;

  ChatSocketClientAuthResponse({required this.commandType, required this.data});

  factory ChatSocketClientAuthResponse.fromJson(Map<String, dynamic> json) => _$ChatSocketClientAuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatSocketClientAuthResponseToJson(this);

  @override
  toString() => this.toJson().toString();
}

@JsonSerializable()
class ClientAuthResponse{
  final int status;

  ClientAuthResponse({required this.status});

  factory ClientAuthResponse.fromJson(Map<String, dynamic> json) => _$ClientAuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ClientAuthResponseToJson(this);

  @override
  toString() => this.toJson().toString();
}

@JsonSerializable()
class ChatSocketClientLastMessagesResponse{
  final String commandType;
  final List<MessageChatModel> data;

  ChatSocketClientLastMessagesResponse({required this.commandType, required this.data});

  factory ChatSocketClientLastMessagesResponse.fromJson(Map<String, dynamic> json) => _$ChatSocketClientLastMessagesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatSocketClientLastMessagesResponseToJson(this);

  @override
  toString() => this.toJson().toString();
}

@JsonSerializable()
class ChatSocketClientMessageResponse{
  final String commandType;
  final MessageChatModel data;

  ChatSocketClientMessageResponse({required this.commandType, required this.data});

  factory ChatSocketClientMessageResponse.fromJson(Map<String, dynamic> json) => _$ChatSocketClientMessageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatSocketClientMessageResponseToJson(this);

  @override
  toString() => this.toJson().toString();
}


@JsonSerializable()
class ClientDeleteMessageResponse{
  final String messageId;

  ClientDeleteMessageResponse({required this.messageId});

  factory ClientDeleteMessageResponse.fromJson(Map<String, dynamic> json) => _$ClientDeleteMessageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ClientDeleteMessageResponseToJson(this);

  @override
  toString() => this.toJson().toString();
}

@JsonSerializable()
class ChatSocketClientDeleteMessageResponse{
  final String commandType;
  final ClientDeleteMessageResponse data;

  ChatSocketClientDeleteMessageResponse({required this.commandType, required this.data});

  factory ChatSocketClientDeleteMessageResponse.fromJson(Map<String, dynamic> json) => _$ChatSocketClientDeleteMessageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatSocketClientDeleteMessageResponseToJson(this);

  @override
  toString() => this.toJson().toString();
}
