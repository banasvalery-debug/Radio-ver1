import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:voicetruth/data/provider/firebase_auth_provider.dart';
import 'dart:convert' as convert;

import 'logger.dart';

class AuthenticatedHttpClient extends http.BaseClient{
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async{
    final authToken = await instanceFirebaseAuthProvider.firebaseUser?.getIdToken();
    if(authToken!=null) request.headers.putIfAbsent('X-Firebase-Token', () => authToken);
    request.headers.putIfAbsent('Content-Type', () => 'application/json');
    // logger.i("${request.headers} \n ${request.url}");
    return request.send();
  }


  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    var response = await super.get(url);
    return response;
  }

  @override
  Future<http.Response> put(Uri url,
      {Object? body,
        convert.Encoding? encoding,
        Map<String, String>? headers}) async {
    var response = await super.put(url, body: body, headers: headers);
    return response;
  }

  @override
  Future<http.Response> post(Uri url,
      {Object? body,
        convert.Encoding? encoding,
        Map<String, String>? headers}) async {
    var response = await super.post(url, body: body, headers: headers);
    return response;
  }

  @override
  Future<http.Response> patch(Uri url,
      {Map<String, String>? headers,
        Object? body,
        convert.Encoding? encoding}) async {
    var response = await super.patch(url, body: body, headers: headers);
    logger.i(url);
    logger.i(body);
    return response;
  }

  // // делаем так потому что иначе кодировка слетит у кириллицы
  // dynamic decodeBodyBytesToJSON(http.Response response) {
  //   if (response.body.isNotEmpty) {
  //     return convert.json.decode(convert.utf8.decode(response.bodyBytes));
  //   }
  // }
}

AuthenticatedHttpClient mainClient = AuthenticatedHttpClient();
/// Creating SentryHttpClient to inform sentry
SentryHttpClient httpClient = SentryHttpClient(
    client: mainClient,
  failedRequestStatusCodes: [
    SentryStatusCode.range(300, 600)
  ],
  captureFailedRequests: true
);

Future<http.Response?> getRequest(Uri uri) async{
  try{
    final response = await httpClient.get(uri);
    return response;
  }
  catch(er){

  }
}

Future<http.Response?> putRequest(Uri uri, dynamic payload, {Map<String, String>? headers}) async{
  try{
    final response = await httpClient.put(uri, body: payload, headers: headers);
    return response;
  }
  catch(er){

  }
}

Future<http.Response?> postRequest(Uri uri, dynamic payload, {Map<String, String>? headers}) async{
  try{
    final response = await httpClient.post(uri, body: payload, headers: headers??{"content-type" : "application/json"});
    return response;
  }
  catch(er){

  }
}

Future<http.Response?> deleteRequest(Uri uri) async{
  try{
    final response = await httpClient.delete(uri);
    return response;
  }
  catch(er){

  }
}

Future<http.Response?> patchRequest(Uri uri, dynamic payload, {Map<String, String>? headers}) async{
  try{
    final response = await httpClient.patch(uri, body: payload, headers: headers);
    return response;
  }
  catch(er){

  }
}

Future<http.StreamedResponse?> multiPartRequest(Uri url,String path)async{
  try{
    final request = http.MultipartRequest('POST', url);
    final file = await http.MultipartFile.fromPath("file_data",path);
    request.files.add(file);
    return httpClient.send(request);
  }catch(er){logger.e("ERROR",er);}
}
