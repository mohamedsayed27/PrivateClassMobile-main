import 'package:flutter/material.dart';

import 'style/colors.dart';
import 'style/size.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField(
      {Key? key,
      this.hint,
      this.type,
      this.contentPadding,
      this.ctrl,
      this.isSecure = false,
      this.maxLines = 1,
      this.prefixIcon,
      this.suffixIcon,
      this.isOnlyRead = false,
      this.onValidate,
      this.isEnabled,
      this.initialVal,
      this.hintStyle,
      this.ontap})
      : super(key: key);
  String? hint;
  String? initialVal;
  TextInputType? type;
  Widget? prefixIcon;
  Widget? suffixIcon;
  bool isSecure = false;
  TextEditingController? ctrl;
  EdgeInsetsGeometry? contentPadding;
  int? maxLines;
  final Function()? ontap;
  bool? isOnlyRead;
  bool? isEnabled;
  TextStyle? hintStyle;
  String? Function(String?)? onValidate;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: isEnabled,
      initialValue: initialVal,
      onTap: ontap,
      controller: ctrl,
      readOnly: isOnlyRead!,
      maxLines: maxLines,
      cursorColor: AppColors.navyBlue,
      cursorHeight: 20,
      style: TextStyle(fontSize: AppFonts.t6, color: AppColors.navyBlue),
      decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.whiteColor,
          contentPadding: contentPadding ??
              EdgeInsets.symmetric(vertical: height(context) * 0.02),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(34),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(34),
              borderSide:
                  const BorderSide(color: AppColors.textFieldBackColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(34),
              borderSide: const BorderSide(color: AppColors.navyBlue)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(34),
              borderSide:
                  const BorderSide(color: AppColors.textFieldBackColor)),
          hintText: hint,
          hintStyle:  hintStyle ?? const TextStyle(
                  color: AppColors.textFieldColor,
                ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon),
      keyboardType: type,
      obscureText: isSecure,
      validator: onValidate,
    );
  }
}
