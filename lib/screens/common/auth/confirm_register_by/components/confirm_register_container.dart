import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../components/custom_text.dart';
import '../../../../../components/style/colors.dart';
import '../../../../../components/style/images.dart';
import '../../../../../components/style/size.dart';
import '../../../../../generated/locale_keys.g.dart';

class ConfirmRegisterContainer extends StatelessWidget {
  void Function()? onTap;
  String img;
  String title;
  String subTitle;

  ConfirmRegisterContainer(
      {Key? key,
      this.onTap,
      required this.subTitle,
      required this.title,
      required this.img})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(
            right: width(context) * 0.02,
            left: width(context) * 0.02,
            bottom: width(context) * 0.03,
            top: width(context) * 0.03),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                color: AppColors.textFieldColor,
                offset: Offset(0.2, 0.2),
                spreadRadius: 0.2,
                blurRadius: 0.5),
          ],
        ),
        child: Row(
          children: [
            Image.asset(
              img,
              width: width(context) * 0.2,
            ),
            SizedBox(
              width: width(context) * 0.022,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                    text: title,
                    fontSize: AppFonts.t6,
                    color: AppColors.mainColor),
                SizedBox(
                  height: height(context) * 0.006,
                ),
                SizedBox(
                    height: height(context) * 0.065,
                    width: width(context) * 0.62,
                    child: CustomText(text: subTitle, fontSize: AppFonts.t9)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
