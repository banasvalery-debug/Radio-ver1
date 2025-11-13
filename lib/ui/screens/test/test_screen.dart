import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voicetruth/data/constants/app_textstyles.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/ui/widgets/wave/custom_wave_widget.dart';
import 'package:voicetruth/utils/logger.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  late String token;
  DateTime? date;

  late ValueNotifier<String> tokenNotifier;
  late ValueNotifier<DateTime?> dateNotifier;
  @override
  void initState() {
    token = "";
    tokenNotifier = ValueNotifier(token);
    dateNotifier = ValueNotifier(null);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ValueListenableBuilder<String>(
            valueListenable: tokenNotifier,
            builder: (context, v, c){
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SelectableText(v, style: AppNavigation.theme.textTheme.dark11w500,),
                    SizedBox(height: 20),
                  ],
                ),
              );
            }),
            ValueListenableBuilder<DateTime?>(
                valueListenable: dateNotifier,
                builder: (context, v, c){
                  return Column(
                    children: [
                      Text(v?.toString()??"", style: AppNavigation.theme.textTheme.dark16w600),
                      SizedBox(height: 20),
                    ],
                  );
                }
            ),
            Center(
              child: TextButton(
                onPressed: press,
                style: TextButton.styleFrom(
                  backgroundColor: AppNavigation.theme.primaryColor
                ),
                child: Text("Получить токен", style: AppTextStyles.white14w400,),
              ),
            )
          ],
        ),
      ),
    );
  }
  press()async{
    try {
      final t = await FirebaseAuth.instance.currentUser?.getIdToken();
      token = t ?? "";
      date = DateTime.now();
      tokenNotifier.value = token;
      dateNotifier.value = date;
    }
    catch(e){
      logger.e("ERROR $e");
    }
  }
}
