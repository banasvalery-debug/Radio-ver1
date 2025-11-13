import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:voicetruth/model/EqualizerOption.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/utils/logger.dart';

class PlayerBackgroundTast extends BackgroundAudioTask {
  AndroidEqualizer? _equalizer;
  AndroidLoudnessEnhancer? _loudnessEnhancer;
  late final AudioPlayer _justPlayer;
  late String _url;
  Timer? _sleepTimer;
  late EqualizerOption currentEqualizerPreset = app.equalizerOptions.first;

  PlayerBackgroundTast(){
    if(Platform.isAndroid){
      _equalizer = AndroidEqualizer();
      _loudnessEnhancer = AndroidLoudnessEnhancer();
    }
    _justPlayer = AudioPlayer(
        handleAudioSessionActivation: true,
        audioPipeline: AudioPipeline(
            androidAudioEffects: [
              if(_loudnessEnhancer!=null) _loudnessEnhancer!,
              if(_equalizer!=null) _equalizer!
            ]
        )
    );
    _setEqualizerOptions();
  }

  _setEqualizerOptions()async{
    if(_equalizer!=null){
      await _equalizer!.setEnabled(true);
    }
  }

  _setEqualizerConfigs()async{
    if(!Platform.isAndroid){
      return ;
    }
    final nowOptions = currentEqualizerPreset;
    final params = await _equalizer!.parameters;

    final minDb = params.minDecibels, maxDb = params.maxDecibels;

    final bands = params.bands;

    if([1,3,4].contains(nowOptions.id))
      bands.forEach((element) {
        element.setGain(0);
      });
    if(nowOptions.id == 2){
      // PopMusic configs
      bands.forEach((e) {
        if(e.lowerFrequency<=32)
          e.setGain(minDb * 0.05);
        else if(e.lowerFrequency<=122)
          e.setGain(maxDb * 0.025);
        else if(e.lowerFrequency<=500)
          e.setGain(maxDb * 0.3);
        else if(e.lowerFrequency<=2500)
          e.setGain(maxDb * 0.2);
        else if(e.lowerFrequency<=20000)
          e.setGain(minDb * 0.1);
      });
    }
    if(nowOptions.id == 5){
      // Piano and classical music
      bands.forEach((e) {
        if(e.lowerFrequency<=32)
          e.setGain(minDb * 0.25);
        else if(e.lowerFrequency<=122)
          e.setGain(maxDb * 0);
        else if(e.lowerFrequency<=500)
          e.setGain(maxDb * 0.25);
        else if(e.lowerFrequency<=2500)
          e.setGain(maxDb * 0.3);
        else if(e.lowerFrequency<=20000)
          e.setGain(minDb * 0.3);
      });
    }
    // print("minDecibels $minDb");
    // print("maxDecibels $maxDb");
    // bands.forEach((element) {
    //   print("""BandId: ${element.index}
    //     centerFrequency: ${element.centerFrequency}
    //     lowerFrequency: ${element.lowerFrequency}
    //     upperFrequency: ${element.upperFrequency}
    //     gain: ${element.gain}
    //
    //     -------
    //     """);
    // });
  }

  @override
  Future onCustomAction(String name, dynamic value) async {
    switch (name) {
      case 'setStation':
        _url = value;
        final mediaItem = MediaItem(
          id: _url,
          title: "",
          album: 'Голос Истины',
        );

        AudioServiceBackground.setMediaItem(mediaItem);
        logger.i(value);
        await _justPlayer.setUrl(value);
        ///Тестовые url c mp3
        // await _justPlayer.setUrl("https://4bbl.ru/data/syn-bondarenko/40/01.mp3");
        // await _justPlayer.setUrl("https://hls-01-radiorecord.hostingradio.ru/record/playlist.m3u8"); /// HLS
        // await _justPlayer.setUrl("http://mediaserv21.live-streams.nl:8000/live");
        // await _justPlayer.setUrl("http://sc6.radiocaroline.net:8040/mp3");
        // await _justPlayer.setAudioSource(DashAudioSource(Uri.parse(value)));
        // await _justPlayer.setUrl("http://sc2.radiocaroline.net:8000/stream");
        logger.i('Url set done');
        _setEqualizerConfigs();
        break;

      case 'setStationName':
        final mediaItem = MediaItem(
          id: _url,
          title: value,
          album: 'Голос Истины',
        );

        AudioServiceBackground.setMediaItem(mediaItem);
        break;

      case 'setVolume':
        await _justPlayer.setVolume(value);
        break;

      case 'setSleepTimer':
        _sleepTimer = Timer(
            Duration(
                milliseconds: DateTime.parse(value).millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch),
            () {
          this.onPause();
        });
        break;

      case 'cancelSleepTimer':
        if (_sleepTimer != null) {
          _sleepTimer!.cancel();
          _sleepTimer = null;
        }
        break;
      case "setEqualizer":
        int id = value;
        currentEqualizerPreset = app.equalizerOptions[id-1];
        if(_justPlayer.playing) _setEqualizerConfigs();
        break;
    }
    return super.onCustomAction(name, value);
  }

  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
    AudioSession.instance.then((value) {
      value.configure(AudioSessionConfiguration.speech());
    });

    logger.i('BG => Start');
    final mediaItem = MediaItem(
      id: params?['url'],
      title: params?['name'],
      album: 'Голос Истины',
    );
    logger.i("PARAMS $params");

    AudioServiceBackground.setMediaItem(mediaItem);

    /// слушаем стэйт плеера
    _justPlayer.playerStateStream.listen((playerState) {
      logger.i("BG => ${playerState.processingState}");
      AudioServiceBackground.setState(
        playing: playerState.playing,
        processingState: {
          ProcessingState.idle: AudioProcessingState.none,
          ProcessingState.loading: AudioProcessingState.connecting,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[playerState.processingState],
        controls: [
          playerState.playing ? MediaControl.pause : MediaControl.play,
          // MediaControl.stop,
        ],
      );
      ///VISUALIZER
      if (playerState.playing && playerState.processingState != ProcessingState.idle && playerState.processingState != ProcessingState.completed) {
        logger.i("BG => VISUALISER STARTED");
        _justPlayer.startVisualizer(enableWaveform: true, enableFft: true, captureRate: 25000);
      } else {
        logger.i("BG => VISUALISER STOPPED");
        _justPlayer.stopVisualizer();
      }
    });

    _justPlayer.play();
    logger.i('Url set Started');
    logger.i(params?['url']);
    await _justPlayer.setUrl(params?['url']);
    logger.i('Url set done');
    ///Visualizer
    /// Есть два типа аудио-данных FFT, Waveform. Здесь указываем какой формат предпочтительнее получать
    bool isFFt = true;
    if(isFFt) {
      _justPlayer.visualizerFftStream.listen((event) {
        AudioServiceBackground.sendCustomEvent({"fft": event.data});
      });
    } else {
      _justPlayer.visualizerWaveformStream.listen((event) {
        AudioServiceBackground.sendCustomEvent({"Waveform": event.data});
      });
    }
    _justPlayer.androidAudioSessionIdStream.listen((event) {
        AudioServiceBackground.sendCustomEvent({
          "sessionId": event
        });
      });

  }

  @override
  Future<void> onStop() async {
    await _justPlayer.dispose();
    return super.onStop();
  }

  onPlay() async{
    await _justPlayer.play();
  }

  onPause() async{
    await _justPlayer.stop();
  }
}
