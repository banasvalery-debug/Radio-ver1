/// flutter pub run build_runner build --delete-conflicting-outputs
import 'package:json_annotation/json_annotation.dart';
import 'package:voicetruth/model/remote/station/station_get_model.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel{
  final int id;
  final String phone;
  final String? username, avatar;
  final AllowedCommunicationModel allowed_communications;

  UserModel({required this.id, required this.phone, this.username, this.avatar,required this.allowed_communications});

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

@JsonSerializable()
class AllowedCommunicationModel{
  bool? viber, telegram, whatsapp;
  AllowedCommunicationModel({this.viber, this.telegram, this.whatsapp});

  factory AllowedCommunicationModel.fromJson(Map<String, dynamic> json) => _$AllowedCommunicationModelFromJson(json);

  Map<String, dynamic> toJson() => _$AllowedCommunicationModelToJson(this);
}


