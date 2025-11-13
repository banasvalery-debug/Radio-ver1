import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voicetruth/data/constants/app_colors.dart';
import 'package:voicetruth/data/constants/app_textstyles.dart';
import 'package:voicetruth/ui/app_navigation.dart';
import 'package:voicetruth/utils/CustomAppThemeData.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final TextStyle? hintStyle, textStyle;
  final TextInputType? keyboardType;
  final bool obscureText, autofocus;
  final FocusNode? focusNode;
  final Color? borderColor;
  final double? height;
  final List<TextInputFormatter>? formatters;
  final Function(String)? onChanged;
  final Widget? suffix;
  const AuthTextField({
    Key? key,
    this.controller, this.hint : '', this.keyboardType, this.obscureText : false, this.hintStyle, this.borderColor, this.height, this.formatters, this.textStyle, this.autofocus : false, this.onChanged, this.focusNode, this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: size.w1, color: borderColor??AppColors.lightGrey)
      ),
      child: SizedBox(
        height: height??(size.w1 * 56),
        child: Center(
          child: TextFormField(
            focusNode: focusNode,
            autofocus: autofocus,
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            inputFormatters: formatters??[],
            style: textStyle,
            decoration: InputDecoration(
              // hintStyle: hintStyle??AppTextStyles.grey14w400,
              // hintText: hint,
              labelText: hint,
              labelStyle: hintStyle??AppTextStyles.grey14w400,
              // alignLabelWithHint: true,
              contentPadding: EdgeInsets.symmetric(horizontal: size.w1 * 15),
              border: InputBorder.none,
              suffix: suffix,
              isDense: true,
            ),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
