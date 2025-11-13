// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station_check_user_in_queue_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StationCheckUserInQueueModel _$StationCheckUserInQueueModelFromJson(
    Map<String, dynamic> json) {
  return StationCheckUserInQueueModel(
    status_code: json['status_code'] as int,
    message: json['message'] as String,
    data: json['data'] == null
        ? null
        : StationQueueModel.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$StationCheckUserInQueueModelToJson(
        StationCheckUserInQueueModel instance) =>
    <String, dynamic>{
      'status_code': instance.status_code,
      'message': instance.message,
      'data': instance.data,
    };
