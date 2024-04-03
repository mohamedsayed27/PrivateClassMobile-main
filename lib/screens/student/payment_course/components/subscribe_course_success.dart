import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:private_courses/components/custom_button.dart';
import 'package:private_courses/components/custom_text.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/components/style/colors.dart';
import 'package:private_courses/components/style/images.dart';
import 'package:private_courses/components/style/size.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/generated/locale_keys.g.dart';
import 'package:private_courses/screens/common/btnNavBar/view/custom_btn_nav_bar_view.dart';
import 'package:private_courses/screens/common/drawer/components/custom_zoom_drawer.dart';
import 'package:private_courses/shared/local/cache_helper.dart';

class SubscribeCourseSuccess extends StatelessWidget {
  final String courseName ;
  const SubscribeCourseSuccess({Key? key, required this.courseName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
       onWillPop: ()async{
         return false ;
       },
      child: Scaffold(
        backgroundColor: AppColors.grayBorderColor.withOpacity(0.01),
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                horizontal: width(context) * 0.05),
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
                        text: "${LocaleKeys.PatSuccess.tr()} ${courseName} ${LocaleKeys.Successful.tr()}",
                        fontWeight: FontWeight.bold,
                        fontSize: AppFonts.t4,
                        color: AppColors.navyBlue,
                        textAlign: TextAlign.center),
                    SizedBox(height: height(context) * 0.04),
                    Image.asset(AppImages.subscribeSuccess,scale: 3),
                    SizedBox(height: height(context) * 0.04),
                    CustomButton(
                        onPressed: () {
                          navigateAndFinish(
                              context: context,
                              widget: CustomZoomDrawer(
                                  mainScreen: CustomBtnNavBarScreen(page: 1,isTeacher: CacheHelper.getData(key: AppCached.role)),
                                  isTeacher: CacheHelper.getData(key: AppCached.role)));
                        },
                        colored: true,
                        text: LocaleKeys.BackToCourses.tr()),
                    SizedBox(height: height(context) * 0.02)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
