import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../generated/locale_keys.g.dart';
import 'custom_text.dart';
import 'style/colors.dart';
import 'style/images.dart';
import 'style/size.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AppImages.emptyList, scale: 3.2),
            SizedBox(height: height(context) * 0.022),
            CustomText(
                text: LocaleKeys.NoContent.tr(),
                color: AppColors.navyBlue,
                fontSize: AppFonts.t5),

          ],
        ),
      ),
    );
  }
}
