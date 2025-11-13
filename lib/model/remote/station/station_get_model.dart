/// flutter pub run build_runner build --delete-conflicting-outputs
import 'package:json_annotation/json_annotation.dart';
import 'package:voicetruth/model/Station.dart';
import 'package:voicetruth/model/remote/station/sound_quality_model.dart';

part 'station_get_model.g.dart';

@JsonSerializable()
class StationGetModel{
  final int id;
  final String name;
  final String stream_hls;
  final String stream_128;
  final String playlist;
  final String playback;
  final String sort_order;
  final Map<String,SoundQualityModel> sound_quality;
  final bool in_live;
  final bool call_queues_enabled;

  final String? current_artwork, next_artwork;

  StationGetModel({required this.id,required this.name,required this.stream_hls, required this.stream_128,required this.playlist,required this.playback,required this.sort_order,required this.sound_quality,required this.in_live,required this.call_queues_enabled, this.current_artwork, this.next_artwork,});

  factory StationGetModel.fromJson(Map<String, dynamic> json) => _$StationGetModelFromJson(json);

  Map<String, dynamic> toJson() => _$StationGetModelToJson(this);

  Station get station =>Station(
      id: id,
      url: stream_hls.isNotEmpty ? stream_hls : stream_128,
      name: name,
      playlistUrl: playlist,
      playbackinfoUrl: playback,
      call_queues_enabled: call_queues_enabled,
      in_live: in_live,
    current_artwork: current_artwork,
    next_artwork: next_artwork,
  );
}