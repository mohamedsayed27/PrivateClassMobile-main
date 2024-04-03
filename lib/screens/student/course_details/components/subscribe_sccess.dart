import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:private_courses/components/custom_button.dart';
import 'package:private_courses/components/custom_text.dart';
import 'package:private_courses/components/style/colors.dart';
import 'package:private_courses/components/style/size.dart';
import 'package:private_courses/generated/locale_keys.g.dart';


import '../../../../components/style/images.dart';

class SubscribeSuccess extends StatelessWidget {
  final String courseName;
  SubscribeSuccess({Key? key, required this.courseName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: width(context) * 0.04,
            vertical: height(context) * 0.06),
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: width(context) * 0.04,
              vertical: height(context) * 0.02),
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: height(context) * 0.03),
                CustomText(
                    text: "${LocaleKeys.SuccessEnrolled.tr()} " + courseName,
                    fontWeight: FontWeight.bold,
                    fontSize: AppFonts.t5,
                    color: AppColors.navyBlue,
                    textAlign: TextAlign.center),
                SizedBox(height: height(context) * 0.04),
                Image.asset(AppImages.subscribeSuccess, scale: 3),
                SizedBox(height: height(context) * 0.04),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: width(context) * 0.05),
                  child: CustomButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      colored: true,
                      text: LocaleKeys.ContinueWatch.tr()),
                ),
                SizedBox(height: height(context) * 0.02)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
