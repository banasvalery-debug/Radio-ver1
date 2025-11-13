import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/ui/widgets/bottom_sheet/bottom_sheet_frame.dart';

class ChooseMediaWidget extends StatelessWidget {
  const ChooseMediaWidget({Key? key}) : super(key: key);

  static Future<bool?> show(context) async {
    return await AppNavigation.showModalBotSheet(BottomSheetFrame(child: ChooseMediaWidget(),), true);
  }

  @override
  build(context) {
    return Column(
      children: [
          _getButton("Камера", () {AppNavigation.pop(true);}, Icons.camera_alt),
          _getButton("Галерея", () {AppNavigation.pop(false);}, Icons.photo),
      ],
    );
    // return Platform.isIOS ? _buildIOSDialog(context) : _buildAndroidDialog(context);
  }


  Widget _getButton(String text, VoidCallback onPressed, IconData icon){
    return TextButton(
        onPressed: onPressed,
        child: Row(
          children: [
            Icon(icon, color: AppNavigation.theme.buttonColor,),
            SizedBox(width: size.w1 * 10),
            Text(
              text,
              style: AppNavigation.theme.textTheme.dark17w400,
            ),
          ],
        ));
  }
}
