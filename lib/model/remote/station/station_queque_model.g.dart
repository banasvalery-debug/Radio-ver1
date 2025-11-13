// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station_queque_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StationQueueModel _$StationQueueModelFromJson(Map<String, dynamic> json) {
  return StationQueueModel(
    status: json['status'] as int,
    status_name: json['status_name'] as String,
    queues_count: json['queues_count'] as int,
  );
}

Map<String, dynamic> _$StationQueueModelToJson(StationQueueModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'status_name': instance.status_name,
      'queues_count': instance.queues_count,
    };
