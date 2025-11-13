// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station_get_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StationGetModel _$StationGetModelFromJson(Map<String, dynamic> json) {
  return StationGetModel(
    id: json['id'] as int,
    name: json['name'] as String,
    stream_hls: json['stream_hls'] as String,
    stream_128: json['stream_128'] as String,
    playlist: json['playlist'] as String,
    playback: json['playback'] as String,
    sort_order: json['sort_order'] as String,
    sound_quality: (json['sound_quality'] as Map<String, dynamic>).map(
      (k, e) =>
          MapEntry(k, SoundQualityModel.fromJson(e as Map<String, dynamic>)),
    ),
    in_live: json['in_live'] as bool,
    call_queues_enabled: json['call_queues_enabled'] as bool,
    current_artwork: json['current_artwork'] as String?,
    next_artwork: json['next_artwork'] as String?,
  );
}

Map<String, dynamic> _$StationGetModelToJson(StationGetModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'stream_hls': instance.stream_hls,
      'stream_128': instance.stream_128,
      'playlist': instance.playlist,
      'playback': instance.playback,
      'sort_order': instance.sort_order,
      'sound_quality': instance.sound_quality,
      'in_live': instance.in_live,
      'call_queues_enabled': instance.call_queues_enabled,
      'current_artwork': instance.current_artwork,
      'next_artwork': instance.next_artwork,
    };
