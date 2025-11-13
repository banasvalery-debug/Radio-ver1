import 'package:voicetruth/data/constants/app_strings.dart';

Uri pathBuilderApi(String endpoint, [Map<String, dynamic>? queryParameters]){
  return Uri.https(AppStrings.base_url, "/v1/"+endpoint, queryParameters);
}