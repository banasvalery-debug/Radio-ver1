import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:voicetruth/data/constants/app_images.dart';
import 'package:voicetruth/main.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/ui/widgets/chat/chat_list.dart';
import 'package:voicetruth/ui/widgets/input/chat_input_field.dart';
import 'package:voicetruth/utils/CustomAppThemeData.dart';

class ChatWidget extends StatefulWidget {
  final VoidCallback onBackPressed;
  const ChatWidget({Key? key,required this.onBackPressed}) : super(key: key);

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {

  bool tooUp = false;
  VoidCallback? goDown;

  late ValueNotifier<bool> _isBigTextFieldNotifier;

  @override
  void initState() {
    _isBigTextFieldNotifier = ValueNotifier(false);
    super.initState();
  }

  void _clearCount() => Future.microtask(() => app.chat.updateTimeStamp());

  CustomAppThemeData get theme => CustomAppThemeData.of(context);

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        backgroundColor: theme.secondaryBackground,
        body: SafeArea(
          child: Column(
            children: [
              StreamBuilder<DateTime>(
                stream: app.chat.dateTimeStream,
                builder: (context, snapshot) {
                  _clearCount();
                  return KeyboardVisibilityBuilder(
                      builder: (context, v){
                        /// Скрываем AppBar если открыта клавиатура, чтобы освободить место для чата
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          height: v ? 0 : size.h1 * 76,
                          transform: Matrix4.translationValues(0, v ? -size.h1 * 76 : 0, 0),
                          padding: EdgeInsets.symmetric(horizontal: size.w1 * 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Live-чат",
                                style: theme.textTheme.s12w600.copyWith(fontSize: size.w1 * 16),
                              ),
                              IconButton(
                                onPressed: widget.onBackPressed,
                                icon: Icon(Icons.arrow_forward_ios, color: theme.textDark),
                                iconSize: size.w1 * 20,
                              ),
                            ],
                          ),
                        );
                      });
                }
              ),
              Expanded(
                child: Stack(
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: _isBigTextFieldNotifier,
                    builder: (context, v, c) {
                      return ChatList(saveToUp: (v)=>setState(()=>tooUp = v),setGoDown: (v)=>goDown=v, isBigTextField: v,);
                    }
                  ),
                  Positioned(bottom: 0, left: 0, right: 0,child: Container(color: theme.secondaryBackground, height: 20,),),
                  /// Кнопка "стрелочка" для возвращения в конец чата
                  ValueListenableBuilder<bool>(valueListenable: _isBigTextFieldNotifier, builder: (context, v, c){
                    return AnimatedPositioned(
                        bottom: tooUp ? size.h1 * (v ? 154 : 63) : 0,
                        left: 0,
                        right: 0,
                        child: Center(
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: (){
                                goDown!();
                              },
                              icon: SvgPicture.asset(
                                app.getAssetsFolder(AppImages.arrow_down, true),
                                width: size.w1 * 48,
                              ),
                              iconSize: size.w1 * 53,
                            )
                        ),
                        duration: Duration(milliseconds: 200));
                  }),
                  Positioned(
                    bottom: 0,
                    left: 0, right: 0,
                    child: ChatInputField(
                      onSend: (v){
                        app.chat.sendMessage(v);
                      },
                      notifyTextFieldSize: (v){
                        if(!v != _isBigTextFieldNotifier.value) _isBigTextFieldNotifier.value = !v;
                      },
                    ),
                  )
                ],
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
