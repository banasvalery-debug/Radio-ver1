import 'package:http/http.dart' as http;
import 'package:audio_service/audio_service.dart';
import 'package:voicetruth/model/EqualizerOption.dart';

import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/state/PlayerBackgroundTast.dart';
import 'package:voicetruth/utils/logger.dart';

void _entryPoint() async => AudioServiceBackground.run(() => PlayerBackgroundTast());


class PlayerRequestExeption {
  final String message;

  PlayerRequestExeption(this.message);

  @override
  String toString() => message;
}

class Player {
  // Запущен ли сервис
  bool started = false;

  // Играет ли радио
  bool playing = false;

  // Загружаются данные
  bool loading = false;

  // Значение громкости для плеера
  double _volume = 1;

  // Запуск аудио сервиса
  startService() async {
    if (started) {
      return;
    }
    started = true;

    await AudioService.start(
      backgroundTaskEntrypoint: _entryPoint,
      params: {
        'name': app.currentStation.value!.name,
        'url': "${app.currentStation.value!.url}",
      },
      androidNotificationChannelName: 'Radio playback',
      androidNotificationColor: 0xFF2196f3,
      androidNotificationIcon: 'mipmap/ic_launcher',
    );
  }

  stopService() async {
    await AudioService.stop();
    started = false;
  }

  pause() async {
    playing = false;
    await AudioService.pause();
  }

  setLoading(bool state) {
    loading = state;
  }

  // Воспроизведение трансляции
  play() async {
    playing = true;
    loading = true;

    await AudioService.connect();

    try {
      if (AudioService.running) {
        await this.setStation();
        AudioService.play();
      } else {
        await this.startService();
      }

      this.setVolume(_volume);

      loading = false;
      setEqualizer(app.currentEqualizerPreset);
    } catch (e) {
      logger.e("ERROR", e);
      await AudioService.disconnect();
      playing = false;
      loading = false;
      throw new PlayerRequestExeption('Не удается подключиться к вещанию');
    }
  }

  // Выбор станции
  setStation() async {
    // Установить ссылку на вещание
    await AudioService.customAction('setStation', "${app.currentStation.value!.url}");
    // Установить название выбранной станции
    await AudioService.customAction('setStationName', app.currentStation.value!.name);
  }

  // Установка таймера сна
  setSleepTimer(DateTime endAt) async {
    await AudioService.customAction('setSleepTimer', endAt.toString());
  }

  // Отмена таймера сна
  cancelSleepTimer() async => await AudioService.customAction('cancelSleepTimer');

  // Изменение ссылки на трансляцию радио
  setUrl() async => await AudioService.customAction('setUrl', "${app.currentStation.value!.url}");

  // Изменение громкости
  setVolume(double volume) {
    _volume = volume;
    AudioService.customAction("setVolume", volume);
  }

  // Получение значения текущей громкости
  double getVolume() => _volume;

  setEqualizer(EqualizerOption option){
    AudioService.customAction("setEqualizer", option.id);
  }
}
