import 'package:flutter/material.dart';
import 'package:voicetruth/data/constants/app_colors.dart';
import 'package:voicetruth/data/constants/app_textstyles.dart';
import 'package:voicetruth/model/Station.dart';
import 'package:voicetruth/model/remote/station/station_queque_model.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/ui/widgets/dialogs/call_to_stream_dialog.dart';
import 'package:voicetruth/utils/CustomAppThemeData.dart';
import 'package:loader_overlay/loader_overlay.dart';

class CallToStreamWidget extends StatelessWidget{
  const CallToStreamWidget({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Station?>(
        valueListenable: app.currentStation,
        builder: (context, currentStation, c){
          return ValueListenableBuilder<StationQueueModel?>(
              valueListenable: app.call_status,
              builder: (context, callStatus, c){
                if(app.currentStation.value == null) return SizedBox();
                CallStatus status = CallStatus.unavailable;
                if(app.currentStation.value!.call_queues_enabled && app.currentStation.value!.in_live){
                  if(callStatus!=null){
                    switch(callStatus.status) {
                      case 0:
                        status = CallStatus.available;
                        break;
                      case 1:
                        status = CallStatus.inqueue;
                        break;
                      case 2:
                        status = CallStatus.calling;
                        break;
                      case 3:
                        status = CallStatus.finished;
                        break;
                    }
                  }
                }
                final texts = getStatusText(status);
                return Container(
                  height: size.h1 * 58,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: size.w1 * 20),
                  child: GestureDetector(
                    onTap: ()async{
                      context.loaderOverlay.show();
                      await onPressed(status);
                      context.loaderOverlay.hide();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: getStatusColor(status),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          if(status != CallStatus.unavailable && status != CallStatus.finished)
                          BoxShadow(
                            color: getStatusColor(status).withOpacity(0.5),
                            offset: Offset(0,size.h1 * 16),
                            blurRadius: 16,
                            spreadRadius: -12
                          ),
                        ]
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(texts[0], style: AppTextStyles.black14w600.copyWith(color: _statusTextColor(status)),),
                          SizedBox(height: size.h1 * 2,),
                          Text(texts[1], style: AppTextStyles.black10w500.copyWith(color: _statusTextColor(status)),),
                        ],),
                    ),
                  ),
                );
              });
        },
    );
  }

  onPressed(CallStatus status)async{
    if(!app.isAuthorized){
      if(status == CallStatus.available) {
        AppNavigation.toAuth();
        return;
      }
    }
      switch(status){
        case CallStatus.available:
          AppNavigation.showAppDialog(CallToStreamDialog());
          break;
        case CallStatus.unavailable:
          break;
        case CallStatus.calling:
          break;
        case CallStatus.inqueue:
          await app.getInQueue(false);
          break;
        case CallStatus.finished:
          break;
      }
  }

  List<String> getStatusText(CallStatus status){
    switch(status){
      case CallStatus.available:
        return ["Нажмите, чтобы позвонить в эфир",
          (app.call_status.value?.queues_count??0) == 0 ?"Будьте первым в очереди"
          :"Вы займете позицию ${(app.call_status.value?.queues_count??0)+1} в очереди"
        ];
      case CallStatus.unavailable:
        return ["Звонок недоступен","На этом канале нет эфиров"];
      case CallStatus.calling:
        return ["Вы сейчас попали в прямой эфир","Ожидайте связи от ведущего"];
      case CallStatus.inqueue:
        return ["Вы сейчас в очереди","Нажмите чтобы выйти из очереди"];
      case CallStatus.finished:
        return ["Звонок недоступен","Звонок завершен"];
    }
  }

  Color getStatusColor(CallStatus status){
    switch(status){
      case CallStatus.available:
        return AppColors.blue;
      case CallStatus.unavailable:
        return theme.isDark ? theme.buttonColor.withOpacity(0.08) : AppColors.whiteBlueGrey;
      case CallStatus.calling:
        return AppColors.green;
      case CallStatus.inqueue:
        return AppColors.pink;
      case CallStatus.finished:
        return theme.buttonColor.withOpacity(0.08);
    }
  }
  Color? _statusTextColor(CallStatus status) => status == CallStatus.unavailable
      ?  theme.isDark ? theme.buttonColor : AppColors.blueGrey
      :  status == CallStatus.finished ? theme.buttonColor : Colors.white;

  CustomAppThemeData get theme => AppNavigation.theme;
}

enum CallStatus{
  available,
  unavailable,
  calling,
  inqueue,
  finished
}