import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:private_courses/components/custom_text.dart';
import 'package:private_courses/components/style/colors.dart';
import 'package:private_courses/components/style/images.dart';
import 'package:private_courses/components/style/size.dart';
import 'package:private_courses/generated/locale_keys.g.dart';

class NoInternetDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        return false;
      },
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Container(
          padding: EdgeInsetsDirectional.only(
              top: height(context) * 0.015,
              bottom: height(context) * 0.02,
              start: width(context) * 0.03,
              end: width(context) * 0.03),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // color:  AppColors.bottonBGColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(AppImages.noInternet,width: width(context)*0.4,),
              SizedBox(height: height(context)*0.02,),
              CustomText(
                  text: LocaleKeys.NoInternet.tr(),
                  color: AppColors.mainColor,
                  fontSize: AppFonts.t2
              ),
              SizedBox(height: height(context)*0.02,),
            ],
          ),
        ),
      ),
    );
  }
}
