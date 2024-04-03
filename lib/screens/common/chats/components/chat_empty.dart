import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:private_courses/components/custom_text.dart';
import 'package:private_courses/components/style/size.dart';
import 'package:private_courses/generated/locale_keys.g.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';

class ChatEmpty extends StatelessWidget {
  const ChatEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(AppImages.chatEmpty,scale: 3.2),
          SizedBox(height: height(context)*0.022),
          CustomText(text: LocaleKeys.NoChats.tr(),
              color: AppColors.navyBlue, fontSize: AppFonts.t5),
          SizedBox(height: height(context)*0.1),
        ],
      ),
    );
  }
}
