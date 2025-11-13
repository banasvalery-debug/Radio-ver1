import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:voicetruth/data/constants/app_colors.dart';
import 'package:voicetruth/data/constants/app_images.dart';
import 'package:voicetruth/data/constants/app_textstyles.dart';
import 'package:voicetruth/model/chat/chat_item_model.dart';
import 'package:voicetruth/model/remote/chat_socket/message_chat_model.dart';
import 'package:voicetruth/model/remote/user_model/user_model.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/ui/widgets/chat/chat_item_widget.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key,required this.saveToUp,required this.setGoDown, this.isBigTextField: false}) : super(key: key);
  final Function(bool tooUp) saveToUp;
  final Function(VoidCallback onPressed) setGoDown;
  final bool isBigTextField;

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> with AutomaticKeepAliveClientMixin<ChatList> {
  late ScrollController controller;


  @override
  void initState() {
    controller = ScrollController();
    controller.addListener(() {
      widget.saveToUp(controller.position.pixels > 300);
    });
    widget.setGoDown(goDown);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MessageChatModel>>(
      stream: app.chat.chatStream,
      builder: (context, snapshot) {
        List<MessageChatModel> items = snapshot.data ?? app.chat.chatItems;
        return ValueListenableBuilder<UserModel?>(
          valueListenable: app.user,
          builder: (context, v, c) {
            return ListView(
              reverse: true,
              controller: controller,
              children: [
                SizedBox(height: size.w1 * (widget.isBigTextField ? 150 : 70),),
                ValueListenableBuilder<DateTime?>(valueListenable: app.chat.lastTimestampNotifier,
                    builder: (context, v, c){
                      if(v==null) return SizedBox();
                      return _disableWidget(v);
                    }
                ),
                ...items.map((e) => Column(
                  children: [
                    ChatItemWidget(model: e,),
                    SizedBox(height: size.h1 * 10,)
                  ],
                )),
                SizedBox(height: size.w1 * 20,),
              ],
            );
          }
        );
      }
    );
  }

  Widget _disableWidget(DateTime date){
    return Container(
        height: size.w1 * 60,
        margin: EdgeInsets.only(left: size.w1 * 20, right: size.w1 * 20, bottom: size.w1 * 20),
        decoration: BoxDecoration(
          color: AppColors.pink,
          borderRadius: BorderRadius.circular(10)
        ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Вы отправили слишком много сообщений.", style: AppTextStyles.white14w400),
          SizedBox(height: size.w1 * 4),
          Text("Повторите попытку через ${_getDurationText(Duration(minutes: 1) - DateTime.now().difference(date))}.", style: AppTextStyles.white11w500),
        ],
      ),
    );
  }

  String _getDurationText(Duration duration){
    if(duration >= Duration(minutes: 1)){
      return "1 минуту";
    }
    final seconds = duration.inSeconds;
    if(seconds >= 10 && seconds <= 19){
      return "$seconds секунд";
    }
    if(seconds%10 == 1){
      return "$seconds секунду";
    }
    if(seconds%10 > 1 && seconds%10 < 5){
      return "$seconds секунды";
    }
    return "$seconds секунд";
  }

  goDown(){
    controller.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
  }

  @override
  bool get wantKeepAlive => true;
}
