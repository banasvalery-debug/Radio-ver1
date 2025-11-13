import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:voicetruth/data/constants/app_strings.dart';
import 'package:voicetruth/data/provider/firebase_crashlytics_provider.dart';
import 'package:voicetruth/model/chat/chat_item_model.dart';
import 'package:voicetruth/model/remote/chat_socket/chat_socket_request_model.dart';
import 'package:voicetruth/model/remote/chat_socket/chat_socket_response.dart';
import 'package:voicetruth/model/remote/chat_socket/message_chat_model.dart';
import 'package:voicetruth/model/remote/chat_socket/server_auth_chat_request.dart';
import 'package:voicetruth/model/remote/chat_socket/server_message_chat_request.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/utils/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Chat{
  late List<MessageChatModel> chatItems;
  late StreamController<List<MessageChatModel>> chatStreamController;
  late Stream<List<MessageChatModel>> chatStream;

  late StreamController<DateTime> dateTimeStreamController;
  late Stream<DateTime> dateTimeStream;
  DateTime dateTime = DateTime(1980);
  String timeStampKey = "timestampKey";

  WebSocketChannel? channel;
  StreamSubscription? chatSubscription;
  Completer<bool>? sendCompleter, pongCompleter;

  String? unsentMessage;

  List<DateTime> lastTimeStamps = [];
  ValueNotifier<DateTime?> lastTimestampNotifier = ValueNotifier(null);
  Duration maxTimeStamp = Duration(seconds: 10);

  bool disposed = false;
  
  Chat(){
    chatStreamController = StreamController.broadcast();
    chatStream = chatStreamController.stream.asBroadcastStream();

    dateTimeStreamController = StreamController.broadcast();
    dateTimeStream = dateTimeStreamController.stream.asBroadcastStream();

    chatItems = [];
  }

  /// Получаем последнюю временную метку, прочтенного сообщения
  _getTimeStamp(){
    final time = app.prefs!.getString(timeStampKey);
    if(time!=null){
      dateTime = DateTime.parse(time);
      _checkTime();
    }
  }
  updateTimeStamp(){
    dateTime = DateTime.now();
    app.prefs!.setString(timeStampKey, dateTime.toString());
    _checkTime();
  }
  _checkTime(){
    dateTimeStreamController.add(dateTime);
  }

  connectToSocket()async{
    logger.i("CONNECT TO SOCKET");
    channel = await _connectWs();
    channel!.sink.done.then((value) => _onDisconnected());
    _broadCoastSocket();
    _getTimeStamp();
  }

  /// Подключаемся к сокету
  _connectWs()async{
    try {
      return WebSocketChannel.connect(Uri.parse(AppStrings.ws_base_url));
    }
    catch(e){
      await Future.delayed(Duration(milliseconds: 5000));
      return await _connectWs();
    }
  }

  /// Слушаем ивенты сокета
  _broadCoastSocket()async{
    await chatSubscription?.cancel();

    chatSubscription = channel!.stream.listen((event) {
      _parseMessage(event);
    }, onDone: (){
      logger.i("ONDONE");
      connectToSocket();
    }, onError: (e){
      logger.e(e);
      connectToSocket();
      }
    );
  }
  void _onDisconnected() {
    if(!disposed) connectToSocket();
  }

  /// Парсим сообщение
  _parseMessage(dynamic event){
    try{
      final e = json.decode(event);
      final result = ChatSocketRequestModel.fromJson(e);
      switch(result.commandType){
        case "hello":
          _connected(e);
          break;
        case "client_auth":
          _clientAuth(e);
          break;
        case "client_latest_messages":
          _clientLatestMessage(e);
          break;
        case "client_message":
          _clientMessage(e);
          break;
        case "client_clear_chat":
          _clearChat();
          break;
        case "client_delete_message":
          _clientDeleteMessage(e);
          break;
        case "client_pong":
          _pong();
          break;
      }
    }
    catch(e){
     logger.e(e);
    }
  }

  _connected(dynamic e) async{
    final response = ChatSocketHelloResponse.fromJson(e);
    if(response.data.message == "connected" && app.isAuthorized){
      final token = await FirebaseAuth.instance.currentUser!.getIdToken();
      final ServerAuthChatRequest request = ServerAuthChatRequest(token);
      channel!.sink.add(json.encode(request));
    }
  }

  /// Проверяем успешность авторизации
  _clientAuth(dynamic e){
    final response = ChatSocketClientAuthResponse.fromJson(e);
    if(response.data.status == 1){
      _ping();
    }
  }

  /// Проверяем подключение к сокету ПИНГ
  _ping()async{
    await Future.delayed(Duration(seconds: 5));
    pongCompleter = Completer();
    ChatSocketRequestModel request = ChatSocketRequestModel(commandType: "server_ping", data: {});
    final a = json.encode(request);
    channel!.sink.add(a);
    final result = await pongCompleter!.future.timeout(Duration(seconds: 5), onTimeout: (){return false;});
    if(!result){
      connectToSocket();
    }
    // FirebaseCrashlyticsProvider.sendLogWithUser("Pong response timeout");
  }
  /// Понг
  _pong(){
    pongCompleter?.complete(true);
    _ping();
  }

  /// Получаем последние сообщения в чате
  _clientLatestMessage(dynamic e){
    final response = ChatSocketClientLastMessagesResponse.fromJson(e);
    addAllMessages(response.data);

    if(unsentMessage!=null){
      sendMessage(unsentMessage!);
      unsentMessage = null;
    }
  }

  addAllMessages(List<MessageChatModel> models){
    chatItems.clear();
    chatItems.addAll(models);
    chatStreamController.add(chatItems);
  }

  /// Получаем сообщение
  _clientMessage(dynamic e){
    final response = ChatSocketClientMessageResponse.fromJson(e);
    addMessage(response.data);

    if(sendCompleter!=null){
      if(!sendCompleter!.isCompleted){
        /// Уведомление об успешной отправке сообщения
        sendCompleter!.complete(true);
      }
    }
  }

  /// Отправка сообщения
  sendMessage(String text){
    final request = ServerMessageChatRequest(text);
    channel!.sink.add(json.encode(request));

    _addTimeStamp();

    sendCompleter = Completer();
    Future.microtask(()async{
      /// Проверяем отправилось ли сообщение, если нет, то переподключаемся к сокету?
      final result = await sendCompleter!.future.timeout(Duration(seconds: 5), onTimeout: () => false);
      if(!result){
        unsentMessage = text;
        await connectToSocket();
      }
    });
  }

  /// Показываем сообщение через Stream
  addMessage(MessageChatModel model){
    chatItems.insert(0,model);
    chatStreamController.add(chatItems);
    _checkTime();
  }

  /// Очищаем чат
  _clearChat(){
    chatItems.clear();
    chatStreamController.add(chatItems);
  }

  /// Удаление сообщения
  _clientDeleteMessage(dynamic e){
    final response = ChatSocketClientDeleteMessageResponse.fromJson(e);
    chatItems.removeWhere((e) => e.id == response.data.messageId);
    chatStreamController.add(chatItems);
  }

  /// Считаем количество непрочтианных сообщения по timeStamp
  int getUnreadMessagesCount(){
    int l = 0;
    chatItems.forEach((element) {
      final time = DateTime.parse(element.timestamp).toLocal();
      if(dateTime.difference(time)<Duration()){l++;}
    });
    return l;
  }

  /// Добавляем последнюю информацию о времени
  _addTimeStamp()async{
    lastTimeStamps.add(DateTime.now());
    if(lastTimeStamps.length > 5){
      lastTimeStamps = lastTimeStamps.sublist(lastTimeStamps.length - 6, lastTimeStamps.length);
      final last = lastTimeStamps.last;
      final first = lastTimeStamps.first;

      final dif = last.difference(first);
      if(dif <= maxTimeStamp){
        lastTimestampNotifier.value = DateTime.now();
        for(int i=0;i<60;i++){
          await Future.delayed(Duration(seconds: 1));
          lastTimestampNotifier.notifyListeners();
        }
        lastTimestampNotifier.value = null;
      }
    }
  }

  void dispose(){
    disposed = true;
    channel?.sink.close();
  }
}