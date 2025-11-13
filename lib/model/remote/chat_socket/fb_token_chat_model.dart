/// flutter pub run build_runner build --delete-conflicting-outputs
import 'package:json_annotation/json_annotation.dart';

part 'fb_token_chat_model.g.dart';

@JsonSerializable()
class FbTokenChatModel{
  final String fbToken;

  FbTokenChatModel({required this.fbToken});

  factory FbTokenChatModel.fromJson(Map<String, dynamic> json) => _$FbTokenChatModelFromJson(json);

  Map<String, dynamic> toJson() => _$FbTokenChatModelToJson(this);
}