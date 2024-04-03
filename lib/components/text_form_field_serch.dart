import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../components/style/colors.dart';
import '../../../components/style/images.dart';
import '../../../components/style/size.dart';
import '../../../generated/locale_keys.g.dart';

class CustomTextFormFieldSearch extends StatelessWidget {
  final TextEditingController? ctrl;
  final String? hintText;
  final void Function(String)? onChanged;
  CustomTextFormFieldSearch({this.ctrl, this.hintText, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: AppColors.navyBlue, fontSize: AppFonts.t6),
      cursorColor: AppColors.navyBlue,
      cursorHeight: height(context) * 0.04,
      controller: ctrl,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          borderSide: BorderSide(
            color: AppColors.textFieldColor,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(
            color: AppColors.textFieldColor,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          borderSide: BorderSide(
            color: AppColors.textFieldBackColor,
          ),
        ),
        fillColor: AppColors.navyBlue.withOpacity(.06),
        filled: true,
        prefixIcon: Image.asset(AppImages.search, scale: 2.8),
        hintText: hintText,
        hintStyle:
            TextStyle(fontSize: AppFonts.t8, color: AppColors.greyTextColor),
      ),
      keyboardType: TextInputType.text,
      onChanged: onChanged,
    );
  }
}
