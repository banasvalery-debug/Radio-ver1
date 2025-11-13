/// flutter pub run build_runner build --delete-conflicting-outputs
import 'package:json_annotation/json_annotation.dart';

part 'chat_socket_request_model.g.dart';

@JsonSerializable()
class ChatSocketRequestModel{
  final String commandType;
  final dynamic data;

  ChatSocketRequestModel({required this.commandType, required this.data});

  factory ChatSocketRequestModel.fromJson(Map<String, dynamic> json) => _$ChatSocketRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatSocketRequestModelToJson(this);
}