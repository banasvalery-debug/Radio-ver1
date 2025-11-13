import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:voicetruth/model/StationPlayback.dart';
import 'package:voicetruth/model/Track.dart';
import 'package:voicetruth/utils/logger.dart';

class Station {
  int id;
  String url;
  String name;
  String playlistUrl;
  String playbackinfoUrl;
  String? current_artwork, next_artwork;
  bool in_live, call_queues_enabled;

  List<dynamic> playlistItems = [];
  List<Track> tracks = [];
  Track? currentTrack;
  StationPlayback? playback;
  Object? options;
  Object? features;
  Object? streaming;

  Station({
    required this.id,
    required this.url,
    required this.name,
    required this.playlistUrl,
    required this.playbackinfoUrl,
    required this.in_live,
    required this.call_queues_enabled,
    this.current_artwork,
    this.next_artwork,
  });

  Future loadData() async {
    var futures = [
      loadPlaylist(),
      loadPlaybackInfo(),
    ];
    try {
      await Future.wait(futures);
    } catch (e, stack) {
      logger.e("ERROR", e, stack);
    }
  }

  Future<void> loadPlaylist() async {
    final response = (await http.get(Uri.parse(this.playlistUrl))).body;
    // logger.i(playlistUrl);

    var playlistData = jsonDecode(response)['data'];

    if (playlistData['tracks'] == null) {
      throw new Exception('Failed to get playlist');
    }

    playlistItems = playlistData['tracks'];

    tracks.clear();
    for (var item in this.playlistItems) {
      final track = Track.fromResponse(item);
      tracks.add(track);
    }
  }

  Future<void> loadPlaybackInfo() async {
    final response = (await http.get(Uri.parse(this.playbackinfoUrl))).body;
    // logger.i(playbackinfoUrl);
    var playbackInfoData = jsonDecode(response)['data'];

    this.currentTrack = Track.fromResponse(playbackInfoData['current_track']);
    this.playback = StationPlayback.fromResponse(playbackInfoData['playback']);
    this.options = playbackInfoData['options'];
    this.features = playbackInfoData['features'];
    this.streaming = playbackInfoData['streaming'];
  }

  List<Track> getTrackList() {
    /**
     * Получаем список всех предыдущих уже проигранных треков,
     * чтобы поместить их в конец списка
     */
    List<Track> previousTracks = this.tracks.where((track) {
      return int.parse(track.index ?? '') < int.parse(this.playback?.playlistpos ?? '');
    }).toList();

    /**
     * Получаем список всех актуальных/текущих треков,
     * чтобы поместить их в начало списка
     */
    List<Track> actualTracks = this.tracks.where((track) {
      return int.parse(track.index ?? '') >= int.parse(this.playback?.playlistpos ?? '');
    }).toList();

    /**
     * Формирование финального списка передач на сегодня.
     * Простановка правильной даты воспроизведения для каждого трека,
     * так как вещание не передает дату предположительного воспроизведения трека.
     */
    Track? prevTrack;
    Duration? prevTrackDuration;

    final trackList = [...actualTracks, ...previousTracks].map((Track track) {
      /// Запоминаем текущую длину трека
      final m = track.duration.contains("–") ? 0 : int.parse(track.duration.toString().split(':').first);
      final s = track.duration.contains("–") ? 0 : int.parse(track.duration.toString().split(':').last);
      Duration currentTrackDuration = Duration(
          minutes: m,
          seconds: s);
      /// Если мы обрабатываем следующий трек после первого из списка
      if (prevTrack != null) {
        /// Задаем дату начала текущего трека, исходя из длины предыдущего трека
        track.startTime = prevTrack!.startTime.add(prevTrackDuration!);

        /// Задаем дату окончания текущего трека, исходя из длины текущего трека
        track.endTime = track.startTime.add(currentTrackDuration);
      }
      else{
        track.endTime = track.startTime.add(currentTrackDuration);
      }

      /**
       * Запоминаем длину текущего трека и сам трек,
       * для возможности использования в следующем цикле как предыдущий трек
       */
      prevTrack = track;
      prevTrackDuration = currentTrackDuration;

      return track;
    }).toList();
    return trackList;
  }

  Station copyFrom(Station station){
    id = station.id;
    url = station.url;
    playlistUrl = station.playlistUrl;
    playbackinfoUrl = station.playbackinfoUrl;
    in_live = station.in_live;
    call_queues_enabled = station.call_queues_enabled;
    current_artwork = station.current_artwork;
    next_artwork = station.next_artwork;
    return this;
  }
}
