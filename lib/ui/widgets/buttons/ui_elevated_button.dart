import 'package:flutter/material.dart';
import 'package:voicetruth/ui/app_navigation.dart';

class UiElevatedButton extends StatelessWidget {
  final Color backgroundColor, textColor,  onPrimaryColor;
  final Color? borderColor;
  final double? height, width, textSize, radius;
  final FontWeight? fontWeight;
  final String text;
  final Widget? child;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry? padding;
  const UiElevatedButton(
      {Key? key,
      this.backgroundColor: Colors.white,
      this.borderColor,
      this.height,
      this.width,
      this.text: '',
      this.textColor: Colors.black,
      required this.onPressed,
        this.onPrimaryColor: Colors.black, this.textSize, this.fontWeight, this.child, this.radius, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? (size.w1 * 52),
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius ?? (size.w1 * 14))
      ),
      child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: padding,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.w1 * 14)),
              primary: backgroundColor.withOpacity(0),//onPrimaryColor,
              side: borderColor == null
                  ? null
                  : BorderSide(width: 1, color: borderColor!)
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(color: textColor, fontSize: textSize, fontWeight: fontWeight),
            ),
          )),
    );
  }
}
