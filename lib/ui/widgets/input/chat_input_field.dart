import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:voicetruth/data/constants/app_colors.dart';
import 'package:voicetruth/data/constants/app_images.dart';
import 'package:voicetruth/data/constants/app_textstyles.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/widgets/buttons/ui_elevated_button.dart';
import 'package:voicetruth/ui/widgets/chat/chat_input_length_progress.dart';
import 'package:voicetruth/utils/CustomAppThemeData.dart';
import 'package:voicetruth/utils/logger.dart';

import '../../app_navigation.dart';

class ChatInputField extends StatefulWidget {
  final Function(String) onSend;
  final Function(bool) notifyTextFieldSize;
  const ChatInputField({Key? key,required this.onSend,required this.notifyTextFieldSize}) : super(key: key);

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  late final TextEditingController controller;
  late final KeyboardVisibilityController _keyboardVisibilityController;
  late final StreamSubscription _keyboardSub;
  int maxLength = 250;

  late bool _keyboardVisible;

  @override
  void initState() {
    _keyboardVisible = false;
    controller = TextEditingController();

    _keyboardVisibilityController = KeyboardVisibilityController();
    _keyboardSub = _keyboardVisibilityController.onChange.listen((event) {
      logger.i(event);
      if(!event) {
        _keyboardVisible = event;
        _setState();
      }
    });
    super.initState();
  }
  @override
  void dispose(){
    _keyboardSub.cancel();
    super.dispose();
  }

  CustomAppThemeData get theme => AppNavigation.theme;
  bool get _isLittle => !_keyboardVisible && controller.text.length == 0;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    width = width - (size.w1 * (32 + 30));
    final item = (width / (size.w1 * 9)).round();

    if(_isLittle) return _emptyPlaceHolder();


    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(width: size.w1, color: theme.borderColor)),
        color: theme.secondaryBackground,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.w1 * 24),
            child: SizedBox(
              height: size.h1 * 94,
              child: Center(
                child: TextFormField(
                  onTap: (){
                    _keyboardVisible = true;
                    widget.notifyTextFieldSize(_isLittle);
                  },
                  controller: controller,
                  maxLines: null,
                  maxLength: maxLength,
                  autofocus: true,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  decoration: InputDecoration(
                    hintText: "Сообщение...",
                    hintStyle: theme.textTheme.grey14w400,
                    counter: SizedBox(),
                    contentPadding: EdgeInsets.symmetric(horizontal: size.w1 * 15),
                    border: InputBorder.none,
                  ),
                  onChanged: (v){_setState();},
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.w1 * 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ChatInputLengthProgress(percent: controller.text.length / maxLength),
                      ...[SizedBox(width: size.w1 * 8),
                        Text("Осталось ${maxLength - controller.text.length} символов", style: AppTextStyles.blueGrey10w500o68,)
                      ]
                  ],
                ),
                ValueListenableBuilder(
                  valueListenable: app.chat.lastTimestampNotifier,
                  builder: (context, v, c){
                    return AnimatedOpacity(
                      duration: Duration(milliseconds: 300),
                      opacity: v == null ? 1 : 0.64,
                      child: UiElevatedButton(
                        onPressed:  (){
                          if(v==null) {
                            final t = controller.text;
                            if (t.isNotEmpty)
                              widget.onSend(t);
                            controller.text = "";
                          }
                        },
                        text: "Ответить",
                        textSize: size.w1 * 10,
                        textColor: Colors.white,
                        height: size.w1 * 26,
                        width: size.w1 * 65,
                        radius: 8,
                        backgroundColor: AppColors.blue,
                        padding: EdgeInsets.zero,
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          SizedBox(height: size.w1 * 11),
        ],
      ),
    );
  }

  Widget _emptyPlaceHolder(){
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.secondaryBackground
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: size.w1, color: theme.borderColor),
          color: theme.secondaryBackground,
        ),
        height: size.h1 * 58,
        margin: EdgeInsets.only(left: size.w1 * 24, right: size.w1 * 24, bottom: size.w1 * 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextFormField(
                  onTap: (){
                    _keyboardVisible = true;
                    _setState();
                  },
                  readOnly: true,
                  controller: controller,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: "Сообщение...",
                    hintStyle: theme.textTheme.grey14w400,
                    contentPadding: EdgeInsets.symmetric(horizontal: size.w1 * 15),
                    border: InputBorder.none,
                  ),
                  onChanged: (v){setState(() {});}
              ),
            ),

          ],
        ),
      ),
    );
  }
  void _setState(){
    setState(() {});
    widget.notifyTextFieldSize(_isLittle);
  }
}
