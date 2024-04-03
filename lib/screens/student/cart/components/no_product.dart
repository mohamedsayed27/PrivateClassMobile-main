import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:private_courses/components/custom_button.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/screens/common/btnNavBar/view/custom_btn_nav_bar_view.dart';
import 'package:private_courses/screens/common/drawer/components/custom_zoom_drawer.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../generated/locale_keys.g.dart';
class NoProduct extends StatelessWidget {
  const NoProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(AppImages.emptyCart,scale: 3.2),
          SizedBox(height: height(context)*0.022,),
          CustomText(text: LocaleKeys.NoProduct.tr(), color: AppColors.navyBlue, fontSize: AppFonts.t5),
          SizedBox(height: height(context)*0.03),
          SizedBox(
              width: width(context)*0.6,
              child: CustomButton(colored: true, onPressed: (){
                navigateAndFinish(
                    context: context,
                    widget: CustomZoomDrawer(
                        mainScreen: CustomBtnNavBarScreen(
                            page: 2,
                            isTeacher: CacheHelper.getData(key: AppCached.role)),
                        isTeacher: CacheHelper.getData(key: AppCached.role)));
              },text: LocaleKeys.GoToStore.tr())),
        ],
      ),
    );
  }
}
