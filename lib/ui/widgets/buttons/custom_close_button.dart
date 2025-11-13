import 'package:flutter/material.dart';
import 'package:voicetruth/ui/app_navigation.dart';

class CustomCloseButton extends StatelessWidget {
  const CustomCloseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
        height: size.w1 * 24,
        width: size.w1 * 24,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(90),
        ),
        child: Center(child: IconButton(
          onPressed: (){AppNavigation.pop();},
            padding: EdgeInsets.zero,
            iconSize: size.w1 * 15,
            icon: Icon(Icons.close, ))
        ),

    );
  }
}
