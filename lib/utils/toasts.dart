import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:voicetruth/ui/app_navigation.dart';

showToastMessage(String text){
  Fluttertoast.showToast(msg: text,toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      fontSize: size.w1 * 16.0);
}

showSnackBar(BuildContext context, String message){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

}