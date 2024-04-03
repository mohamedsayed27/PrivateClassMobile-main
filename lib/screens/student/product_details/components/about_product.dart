import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:private_courses/screens/student/product_details/controller/product_details_cubit.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/size.dart';
import '../../../../generated/locale_keys.g.dart';
class AboutProduct extends StatelessWidget {
  final ProductDetailsCubit? cubit;

  const AboutProduct({required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      SizedBox(height: height(context)*0.02,),
      CustomText(text: LocaleKeys.TextOnBoarding1.tr(),
          color: AppColors.greyBoldColor,fontSize: AppFonts.t9),
    ],);
  }
}
