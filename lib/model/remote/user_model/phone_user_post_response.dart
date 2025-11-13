/// flutter pub run build_runner build --delete-conflicting-outputs
import 'package:json_annotation/json_annotation.dart';
import 'package:voicetruth/model/remote/station/station_get_model.dart';
import 'package:voicetruth/model/remote/user_model/user_model.dart';

part 'phone_user_post_response.g.dart';

@JsonSerializable()
class PhoneUserPostResponse{
  final int status_code;
  final String message;
  final UserModel? data;

  PhoneUserPostResponse({required this.status_code, required this.message, this.data});

  factory PhoneUserPostResponse.fromJson(Map<String, dynamic> json) => _$PhoneUserPostResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PhoneUserPostResponseToJson(this);
}