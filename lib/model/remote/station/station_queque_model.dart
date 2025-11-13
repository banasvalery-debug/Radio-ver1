/// flutter pub run build_runner build --delete-conflicting-outputs
import 'package:json_annotation/json_annotation.dart';
import 'package:voicetruth/model/remote/station/station_get_model.dart';

part 'station_queque_model.g.dart';

@JsonSerializable()
class StationQueueModel{
  final int status;
  final String status_name;
  final int queues_count;

  StationQueueModel({required this.status, required this.status_name, required this.queues_count});

  factory StationQueueModel.fromJson(Map<String, dynamic> json) => _$StationQueueModelFromJson(json);

  Map<String, dynamic> toJson() => _$StationQueueModelToJson(this);
}