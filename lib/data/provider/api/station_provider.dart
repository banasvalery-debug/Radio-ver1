import 'dart:convert';

import 'package:http/http.dart';
import 'package:voicetruth/data/constants/api.dart';
import 'package:voicetruth/utils/http_helper.dart';

class StationProvider{
  Future<Response?> getStations() async{
    final path = pathBuilderApi("radio/stations/");
    final response = await getRequest(path);
    return response;
  }

  Future<Response?> checkUserInQueue(int station_id)async{
    final path = pathBuilderApi("/radio/stations/check-user-in-queue/");
    final payload = json.encode({
      "station_id": station_id
    });
    final response = await postRequest(path, payload);
    return response;
  }

  Future<Response?> getInOutQueue(int station_id, [bool getIn = true])async{
    final path = pathBuilderApi("/radio/stations/get-${getIn ? "in" : "out"}-queue/");
    final payload = json.encode({
      "station_id": station_id
    });
    final response = await postRequest(path, payload);
    return response;
  }
}
final instanceStationProvider = StationProvider();