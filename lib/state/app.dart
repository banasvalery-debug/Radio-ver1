import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:developer';
import 'dart:typed_data';
import 'package:audio_service/audio_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voicetruth/data/provider/api/auth_profile_provider.dart';
import 'package:voicetruth/data/provider/api/station_provider.dart';
import 'package:voicetruth/data/provider/firebase_auth_provider.dart';

import 'package:voicetruth/model/EqualizerOption.dart';
import 'package:voicetruth/model/QualityOption.dart';
import 'package:voicetruth/model/SleepTimerOption.dart';
import 'package:voicetruth/model/Station.dart';
import 'package:voicetruth/model/remote/station/station_check_user_in_queue_model.dart';
import 'package:voicetruth/model/remote/station/station_get_model.dart';
import 'package:voicetruth/model/remote/station/station_queque_model.dart';
import 'package:voicetruth/model/remote/station/stations_get_request.dart';
import 'package:voicetruth/model/remote/user_model/phone_user_post_response.dart';
import 'package:voicetruth/model/remote/user_model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'package:voicetruth/state/Notifications.dart';
import 'package:voicetruth/state/Player.dart';
import 'package:voicetruth/state/Storage.dart';
import 'package:voicetruth/state/Stories.dart';
import 'package:voicetruth/state/chat.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/utils/Theme.dart';
import 'package:voicetruth/utils/logger.dart';

// Экспортируется глобальная переменная!
Application app = Application();

class Application {
  /// Станции
  final List<Station> stations = [];
  List<StationGetModel> stationsModels = [];

  /// Таймер
  final List<SleepTimerOption> sleepTimerOptions = [
    SleepTimerOption(name: "Выключить", duration: Duration.zero),
    SleepTimerOption(duration: Duration(minutes: 5), name: "На 5 минут"),
    SleepTimerOption(duration: Duration(minutes: 10), name: "На 10 минут"),
    SleepTimerOption(duration: Duration(minutes: 15), name: "На 15 минут"),
    SleepTimerOption(duration: Duration(minutes: 30), name: "На 30 минут"),
    SleepTimerOption(duration: Duration(minutes: 45), name: "На 45 минут"),
  ];

  /// Эквалайзер
  final List<EqualizerOption> equalizerOptions = [
    EqualizerOption(id: 1, name: 'По умолчанию'),
    EqualizerOption(id: 2, name: 'Под наушники'),
    EqualizerOption(id: 3, name: 'Под телевизор'),
    EqualizerOption(id: 4, name: 'Под саундбар'),
    EqualizerOption(id: 5, name: 'Под колонки'),
  ];

  /// Качество звука
  final List<QualityOption> qualityOptions = [];


  Theme theme = Theme();

  /// Текущая станция
  ValueNotifier<Station?> currentStation = ValueNotifier(null);
  /// Текущий статус звонка
  ValueNotifier<StationQueueModel?> call_status = ValueNotifier(null);
  /// Текущий эквалайзер
  late EqualizerOption currentEqualizerPreset = equalizerOptions.first;
  /// Текущее качество
  QualityOption? currentQuality;
  /// Текущий таймер
  late SleepTimerOption sleepTimer = sleepTimerOptions.first;

  /// Notifier юзера
  ValueNotifier<UserModel?> user = ValueNotifier(null);
  bool isAuthorized = false;

  Storage storage = Storage();
  /// Кэш SharedPrefs
  SharedPreferences? prefs;
  Notifications notifications = Notifications();
  Player player = Player();
  Stories stories = Stories();

  final StreamController<bool> dataLoadedStreamController = StreamController.broadcast();
  late Stream<bool> dataLoadedStream = dataLoadedStreamController.stream;
  bool loaded = false;

  // Стрим данных о высоте звуков
  late StreamController<Int8List> soundLevelStreamController;
  late Stream<Int8List> soundLevelStream;

  //Стрим данных о аудио сессии
  late StreamController<int> sessionIdStreamController;
  late Stream<int> sessionIdStream;

  //Стейт чата
  late Chat chat;

  /// Окончание таймера
  DateTime? sleepTimerEnd;

  ImagePicker imagePicker = ImagePicker();

  /// Dynamic link. Сохраняем ее, если приложение еще не прогрузилось
  Uri? initialUri;

  Future<void> init() async {
    if(prefs == null){
      prefs = await SharedPreferences.getInstance();
    }

    final response = await instanceStationProvider.getStations();
    if(response!=null) {
      if (response.statusCode < 300) {
        final result = StationsGetRequest.fromJson(json.decode(response.body));
        if (result.status_code < 300) {
          chat = Chat();

          stations.clear();
          if (result.data != null) {
            stationsModels = result.data!;
            result.data!.forEach((element) {
              stations.add(element.station);
            });
            /// выставляем true, если данные прогрузились
            loaded = true;

            await setConfigs();

            currentStation.value!.loadData();

            dataLoadedStreamController.add(true);
            await checkAuthorization();
            chat.connectToSocket();
            return;
          }
        }
      }
    }
  }

  Future<void> setConfigs()async{
    await storage.init();
    await notifications.init();

    //  загружаем сохраненные настройки, если они есть
    final stationId = app.storage.settings?.get('station');
    if (stationId != null || true) {
      currentStation.value = this.stations.firstWhere(
            (el) => el.id == stationId,
        orElse: () => stations.first,
      );
    }
    final equalizerId = app.storage.settings?.get('equalizer');
    if (equalizerId != null) {
      currentEqualizerPreset = this.equalizerOptions.firstWhere(
            (el) => el.id == equalizerId,
        orElse: () => equalizerOptions.first,
      );
    }
    final qualityId = app.storage.settings?.get('quality');
    if (qualityId != null || true) {
      checkQualityList();
      currentQuality = qualityOptions.firstWhere(
            (el) => el.value == qualityId,
        orElse: () => qualityOptions.first,
      );
    }

    soundLevelStreamController = StreamController.broadcast();
    soundLevelStream = soundLevelStreamController.stream;

    sessionIdStreamController = StreamController.broadcast();
    sessionIdStream = sessionIdStreamController.stream;


    /// Получаем данные от AudioService
    AudioService.customEventStream.listen((event) {
      if(event['pitch'] !=null){
        logger.i("PITCH stream from APP $event");
      }
      if(event['Waveform'] != null){
        _addWave(event['Waveform']);
      }
      if(event['fft'] !=null){
        _addWave(event['fft']);
      }
      if(event['sessionId'] != null){
        _addSession(event['sessionId']);
      }
    });
  }

  void checkQualityList(){
    qualityOptions.clear();
    qualityOptions.addAll(stationsModels.where((element) => currentStation.value!.id == element.id).first.sound_quality.values
        .map((e) => QualityOption(value: e.bit, name: e.name)));

    if(currentQuality == null) currentQuality = qualityOptions.first;

    if(qualityOptions.where((e) => e.value == currentQuality!.value).length == 0){
      currentQuality = qualityOptions.first;
      storage.settings?.put('quality', currentQuality!.value);
    }
  }


  // Get complete path
  String getAssetsFolder(String path, [bool general = false]) {
    String assetFolder = Platform.isIOS ? 'ios' : 'android';
    return (general ? "assets/general" : "assets/$assetFolder") + "/$path";
  }

  setSleepTimer(SleepTimerOption option) async {
    sleepTimer = option;
    if (option.duration == Duration.zero) {
      sleepTimerEnd = null;
      await this.player.cancelSleepTimer();
      return;
    }

    sleepTimerEnd = DateTime.now().add(option.duration);
    await this.player.setSleepTimer(sleepTimerEnd!);
  }

  Duration getSleepTimerRest() {
    if (sleepTimerEnd == null) {
      return Duration();
    }
    int diff = sleepTimerEnd!.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch;
    if (diff <= 0) {
      sleepTimerEnd = null;
      sleepTimer = sleepTimerOptions.first;
      return Duration();
    }
    return Duration(milliseconds: diff);
  }

  _addWave(Int8List data){
    soundLevelStreamController.add(data);
  }

  int? sessionId;
  _addSession(int id){
    sessionId = id;
    sessionIdStreamController.add(id);
  }


  Future<void> getProfile() async{
    if(!isAuthorized) {
      await app.checkAuthorization();
      if(!isAuthorized) return;
    }
    final response = await instanceAuthProfileProvider.me();
    logger.i(response?.body);
    try{
      if(response!= null){
        if(response.statusCode < 300){
          logger.i("PROFILE RESPONSE ${response.body}");
          final result = PhoneUserPostResponse.fromJson(json.decode(response.body));
          logger.i(result.data?.allowed_communications.toJson());
          if(result.status_code < 300){
            app.user.value = result.data;
          }
        }
      }
    }catch(err){
      logger.e("USER ERROR $err", err);
    }
  }

  Future<bool> updateCommunications() async{
    final response = await instanceAuthProfileProvider.updateCommunication(
      whatsapp: user.value?.allowed_communications.whatsapp??false,
      telegram: user.value?.allowed_communications.telegram??false,
      viber: user.value?.allowed_communications.viber??false,
    );
    try{
      if(response!= null){
        if(response.statusCode < 300){
          final result = PhoneUserPostResponse.fromJson(json.decode(response.body));
          if(result.status_code < 300){
            user.value = result.data;
            return true;
          }
        }
      }
    }catch(err){
      logger.e("ERROR", err);
    }
    return false;
  }


  getStations()async{
    final response = await instanceStationProvider.getStations();
    if(response!=null) {
      if (response.statusCode < 300) {
        final result = StationsGetRequest.fromJson(json.decode(response.body));
        if (result.status_code < 300) {
          if (result.data != null) {
            stations.clear();
            stationsModels = result.data!;
            stations.addAll(stationsModels.map((e) => e.station).toList());
            final stat = stationsModels.where((e) => currentStation.value?.id == e.id).toList();
            if(stat.length>0){

              final station = stat.first.station;

              currentStation.value = currentStation.value?.copyFrom(station);

              if(stat.first.call_queues_enabled){
                getQueueInfo();
              }
            }
          }
        }
      }
    }
  }

  Future<void> getQueueInfo()async{
    final response = await instanceStationProvider.checkUserInQueue(currentStation.value!.id);
    if(response!=null) {
      if (response.statusCode < 300) {
        final result = StationCheckUserInQueueModel.fromJson(json.decode(response.body));
        if (result.status_code < 300) {
          if (result.data != null) {
            call_status.value = result.data;
          }
        }
      }
    }
  }

  Future<bool> getInQueue(bool getIn)async{
    final response = await instanceStationProvider.getInOutQueue(currentStation.value!.id, getIn);
    if(response!=null) {
      if (response.statusCode < 300) {
        final result = StationCheckUserInQueueModel.fromJson(json.decode(response.body));
        if (result.status_code < 300) {
          if (result.data != null) {
            await getQueueInfo();
            return true;
          }
        }
      }
    }
    return false;
  }

  /// Сохраняем ссылку, которую нужно открыть, при открытии главной страницы
  void setInitialUri(Uri link){
    if(loaded && stories.stories.length>0){
      final path = link.path;
      if(path.contains("story")) {
        final id = path.split("/").last;
        stories.openStoryByLink(id);
        initialUri = null;
      }
    }
    else{
      initialUri = link;
    }
  }

  Future<void> checkAuthorization()async{
    isAuthorized = await instanceFirebaseAuthProvider.isAlreadyAuthenticated();
  }

  dispose(){
    player.stopService();
    chat.dispose();

    AudioService.disconnect();
  }
}
