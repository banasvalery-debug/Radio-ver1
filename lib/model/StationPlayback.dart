class StationPlayback {
  final String pos;
  final String len;
  final String state;
  final String playlistpos;

  const StationPlayback({
    required this.pos,
    required this.len,
    required this.state,
    required this.playlistpos,
  });

  static fromResponse(dynamic data) {
    StationPlayback playback = StationPlayback(
      pos: data['pos'],
      len: data['len'],
      state: data['state'],
      playlistpos: data['playlistpos'],
    );

    return playback;
  }
}
