import 'dart:convert';

import 'package:http/http.dart';
import 'package:voicetruth/data/constants/api.dart';
import 'package:voicetruth/utils/http_helper.dart';

class AuthProfileProvider{
  Future<Response?> auth(String phone)async{
    final path = pathBuilderApi("auth");
    final payload = json.encode({"phone": phone});
    final response = await postRequest(path, payload);
    return response;
  }

  Future<Response?> me()async{
    final path = pathBuilderApi("user/me/");
    final response = await getRequest(path);
    return response;
  }


  Future<Response?> changeUsername(String username) async{
    final path = pathBuilderApi("user/change-username");
    final payload = json.encode({"username": username});
    final response = await postRequest(path, payload);
    return response;
  }

  Future<Response?> updateCommunication({bool whatsapp = false, bool telegram = false, bool viber = false}) async{
    final path = pathBuilderApi("user/change-communications/");
    final payload = json.encode({
      "whatsapp": whatsapp,
      "telegram": telegram,
      "viber": viber,
    });
    final response = await postRequest(path, payload);
    return response;
  }

  Future<Response?> userFcmTokenAttach(String token) async{
    final path = pathBuilderApi("user/fcm-token/attach");
    final payload = json.encode({"token": token});
    final response = await postRequest(path, payload);
    return response;
  }

  Future<StreamedResponse?> uploadAvatar(String filePath)async{
    final path = pathBuilderApi("/user/upload-avatar/");
    final response = await multiPartRequest(path, filePath);
    return response;
  }
}

final instanceAuthProfileProvider = AuthProfileProvider();