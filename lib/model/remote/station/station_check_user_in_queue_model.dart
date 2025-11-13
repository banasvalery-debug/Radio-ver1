/// flutter pub run build_runner build --delete-conflicting-outputs
import 'package:json_annotation/json_annotation.dart';
import 'package:voicetruth/model/remote/station/station_get_model.dart';
import 'package:voicetruth/model/remote/station/station_queque_model.dart';

part 'station_check_user_in_queue_model.g.dart';

@JsonSerializable()
class StationCheckUserInQueueModel{
  final int status_code;
  final String message;
  final StationQueueModel? data;

  StationCheckUserInQueueModel({required this.status_code, required this.message, this.data});

  factory StationCheckUserInQueueModel.fromJson(Map<String, dynamic> json) => _$StationCheckUserInQueueModelFromJson(json);

  Map<String, dynamic> toJson() => _$StationCheckUserInQueueModelToJson(this);
}