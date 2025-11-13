// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    id: json['id'] as int,
    phone: json['phone'] as String,
    username: json['username'] as String?,
    avatar: json['avatar'] as String?,
    allowed_communications: AllowedCommunicationModel.fromJson(
        json['allowed_communications'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'username': instance.username,
      'avatar': instance.avatar,
      'allowed_communications': instance.allowed_communications,
    };

AllowedCommunicationModel _$AllowedCommunicationModelFromJson(
    Map<String, dynamic> json) {
  return AllowedCommunicationModel(
    viber: json['viber'] as bool?,
    telegram: json['telegram'] as bool?,
    whatsapp: json['whatsapp'] as bool?,
  );
}

Map<String, dynamic> _$AllowedCommunicationModelToJson(
        AllowedCommunicationModel instance) =>
    <String, dynamic>{
      'viber': instance.viber,
      'telegram': instance.telegram,
      'whatsapp': instance.whatsapp,
    };
