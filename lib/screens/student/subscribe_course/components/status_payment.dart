import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:private_courses/components/custom_button.dart';
import 'package:private_courses/components/custom_text.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/components/style/images.dart';
import 'package:private_courses/components/style/size.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/generated/locale_keys.g.dart';
import 'package:private_courses/screens/common/btnNavBar/view/custom_btn_nav_bar_view.dart';
import 'package:private_courses/screens/common/drawer/components/custom_zoom_drawer.dart';

import '../../../../components/style/colors.dart';
import '../../../../shared/local/cache_helper.dart';

class StatusPayment extends StatelessWidget {
  final bool isPayment;
  final String? courseName ;
  StatusPayment({required this.isPayment, this.courseName});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Scaffold(
          body: Padding(
            padding:  EdgeInsets.symmetric(horizontal: width(context)*0.12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isPayment == false ?CustomText(text: "${LocaleKeys.PatSuccess.tr()} ${courseName} ${LocaleKeys.Successful.tr()}",color: AppColors.navyBlue,fontSize: AppFonts.t4,fontWeight: FontWeight.bold,textAlign: TextAlign.center):CustomText(text: LocaleKeys.NotPay.tr(),color: AppColors.navyBlue,fontSize: AppFonts.t4,fontWeight: FontWeight.bold,textAlign: TextAlign.center),
                SizedBox(height: height(context) * 0.05),
                isPayment == false ? Image.asset(AppImages.subscribeSuccess,scale: 3):Image.asset(AppImages.notPay,scale: 3),
                SizedBox(height: height(context) * 0.05),
                CustomButton(
                  text: isPayment == false?LocaleKeys.BackToHome.tr():LocaleKeys.PayAgain.tr(),
                  colored: true,
                  fontSize: isPayment == false?AppFonts.t5:AppFonts.t6,
                  onPressed: (){
                    navigateAndFinish(context: context, widget: CustomZoomDrawer(mainScreen: CustomBtnNavBarScreen(page: 0,isTeacher: CacheHelper.getData(key: AppCached.role)), isTeacher: CacheHelper.getData(key: AppCached.role)));
                  }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}