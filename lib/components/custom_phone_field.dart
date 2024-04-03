import 'package:easy_localization/easy_localization.dart' as localization;
import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:private_courses/components/style/images.dart';

import 'style/colors.dart';
import 'style/size.dart';

class CustomPhoneField extends StatelessWidget {
  String? hint;
  TextEditingController? ctrl;
  String? phoneKey;
  EdgeInsetsGeometry? contentPadding;
  final Function(PhoneNumber) onChangedPhone ;
  final Function(Country) onChangedCode ;

  CustomPhoneField({Key? key, this.hint,this.phoneKey, this.contentPadding, this.ctrl, required this.onChangedPhone, required this.onChangedCode}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: context.locale.languageCode == "ar"
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: IntlPhoneField(
        controller: ctrl,
        dropdownTextStyle:  TextStyle(
            color: AppColors.navyBlue,fontSize: AppFonts.t6),
        dropdownIcon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.transparent,
          size: 8,
        ),
        cursorColor: AppColors.navyBlue,
        cursorHeight: 20,
        style: TextStyle(fontSize: AppFonts.t6, color: AppColors.navyBlue),
        decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.whiteColor,
            contentPadding: contentPadding ?? EdgeInsets.symmetric(vertical: height(context) * 0.02),
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
            hintStyle: const TextStyle(
              color: AppColors.textFieldColor,
            ),
            suffixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: width(context) * 0.03),
              child: Image.asset(
                AppImages.phoneNum,
                width: width(context) * 0.02,
              ),
            )),
        initialCountryCode:phoneKey??"SA",
        disableLengthCheck: true,
        onChanged: onChangedPhone,
        onCountryChanged: onChangedCode,
        textAlign: context.locale.languageCode == "ar"
            ? TextAlign.right
            : TextAlign.left,
      ),
    );
  }
}