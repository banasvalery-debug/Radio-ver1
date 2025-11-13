import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:voicetruth/data/constants/app_colors.dart';
import 'package:voicetruth/data/constants/app_images.dart';
import 'package:voicetruth/model/remote/chat_socket/message_chat_model.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/utils/CustomAppThemeData.dart';

class ChatItemWidget extends StatelessWidget {
  final MessageChatModel model;
  const ChatItemWidget({Key? key,required this.model}) : super(key: key);

  CustomAppThemeData get theme => AppNavigation.theme;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    width = width - (size.w1 * 32);
    final item = (width / (size.w1 * 11)).round();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.w1 * 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getItem(),
          Transform(
            transform: Matrix4.translationValues(0, size.w1 * (-18), 0),
            child: SizedBox(
              width: double.infinity,
              child: _getTextWidget(item)
            ),
          ),
        ],
      ),
    );
  }

  _getTextWidget(int item){
    var messages = [];
    final message = model.message.trim();
    int? index;
    if(isMe){
      if(message.length < item){
        messages = [message];
      }
      else{
        for(int i=item-1;i>=1;i--){
          if(message.substring(i,i+1) == " "){
            index = i;
            break;
          }
        }
        if(index == null){
          messages = [message.substring(0,item), message.substring(item, message.length)];
        }
        else{
          messages = [message.substring(0,index), message.substring(index, message.length)];
        }
      }
    }
    return Text.rich(TextSpan(
        children: [
          /// Если сообщение не мое, то слегка сдвигаем первую строчку вправо
          if(!isMe) ...[
            WidgetSpan(child: SizedBox(width: size.w1 * (10 + 36), height: size.w1 * 17,)),
            // TextSpan(text: "_______",style: theme.textTheme.s17w400.copyWith(fontSize: size.w1 * 14, color: Colors.transparent),),
            TextSpan(text: "${model.message}",style: theme.textTheme.s17w400.copyWith(fontSize: size.w1 * 14),),
          ],
          if(isMe)
            ...[
              WidgetSpan(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(right: size.w1 * (10 + 36)),
                  child: Text(message/*messages[0]*/, textAlign: TextAlign.end,),
                )
              ),
            // if(messages.length > 1) TextSpan(text: "${messages[1]}" ,style: theme.textTheme.s17w400.copyWith(fontSize: size.w1 * 14),),
          ]
        ]
    ), textAlign: isMe ? TextAlign.right : TextAlign.left,);
  }

  Widget getItem()=>SizedBox(
    height: size.w1 * 42,
    child: Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        isMe ? _nameField() : _avatar(),
        SizedBox(width: size.w1 * 10,),
        isMe ? _avatar() : _nameField(),
      ],
    ),
  );

  Widget _nameField() =>Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          // Text("№ 422", style: theme.textTheme.grey11w500),
          // SizedBox(width: size.w1 * 12,),
          Text(model.username, style: theme.textTheme.s20w500.copyWith(fontSize: size.w1 * 11)),
        ],
      ),
      SizedBox(),
    ],
  );

  Widget _avatar() => (model.userAvatar??"").isEmpty
      ? SvgPicture.asset(app.getAssetsFolder(AppImages.chat_person_icon,true), width: size.w1 * 36,)
      : Padding(padding: EdgeInsets.only(left: size.w1 * 2, right: size.w1 * 2), child: CircleAvatar(
    radius: size.w1 * 16,
    backgroundColor: AppColors.blueGrey,
    backgroundImage: NetworkImage(model.userAvatar!),
  ));


  bool get isMe {
    return model.userId == app.user.value?.id;
  }
}
