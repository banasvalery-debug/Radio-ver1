// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stations_get_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StationsGetRequest _$StationsGetRequestFromJson(Map<String, dynamic> json) {
  return StationsGetRequest(
    status_code: json['status_code'] as int,
    message: json['message'] as String,
    data: (json['data'] as List<dynamic>?)
        ?.map((e) => StationGetModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$StationsGetRequestToJson(StationsGetRequest instance) =>
    <String, dynamic>{
      'status_code': instance.status_code,
      'message': instance.message,
      'data': instance.data,
    };
