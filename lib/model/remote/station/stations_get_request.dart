/// flutter pub run build_runner build --delete-conflicting-outputs
import 'package:json_annotation/json_annotation.dart';
import 'package:voicetruth/model/remote/station/station_get_model.dart';

part 'stations_get_request.g.dart';

@JsonSerializable()
class StationsGetRequest{
  final int status_code;
  final String message;
  final List<StationGetModel>? data;

  StationsGetRequest({required this.status_code, required this.message, this.data});

  factory StationsGetRequest.fromJson(Map<String, dynamic> json) => _$StationsGetRequestFromJson(json);

  Map<String, dynamic> toJson() => _$StationsGetRequestToJson(this);
}