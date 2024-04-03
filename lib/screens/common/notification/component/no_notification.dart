import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:private_courses/components/custom_text.dart';

import 'package:private_courses/components/style/images.dart';
import 'package:private_courses/components/style/size.dart';
import 'package:private_courses/generated/locale_keys.g.dart';

import '../../../../components/style/colors.dart';

class NoNotification extends StatelessWidget {
  const NoNotification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(AppImages.noNotification, scale: 3.2),
        SizedBox(height: height(context) * 0.02),
        CustomText(
          text: LocaleKeys.NoNotifications.tr(),
          color: AppColors.navyBlue,
          fontSize: AppFonts.t5,
        ),
      ],
    );
  }
}
