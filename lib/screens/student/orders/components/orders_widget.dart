import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:private_courses/components/custom_button.dart';

import '../../../../components/custom_text.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../generated/locale_keys.g.dart';

class OrdersWidget extends StatelessWidget {
  final String courseName;
  final String courseImg;
  final String orderNo;
  final String orderDate;
  final String orderPrice;
  final String buttonText;
  final GestureTapCallback onTap;
  OrdersWidget({
    Key? key,
    required this.courseImg,
    required this.orderNo,
    required this.orderPrice,
    required this.orderDate,
    required this.courseName,
    required this.buttonText,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(end: width(context) * 0.02),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
                color: AppColors.textFieldColor,
                offset: Offset(0.5, 0.5),
                spreadRadius: 0.5,
                blurRadius: 0.5),
          ],
        ),
        padding: EdgeInsets.symmetric(
            vertical: height(context) * 0.02,
            horizontal: width(context) * 0.02),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: height(context) * 0.1,
              width: width(context) * 0.2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                      image: AssetImage(courseImg), fit: BoxFit.fill)),
              // child: Image.asset(AppImages.physics),
            ),
            SizedBox(width: width(context) * 0.02),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height(context) * 0.005),
                CustomText(
                    text: courseName,
                    fontSize: AppFonts.t7,
                    color: AppColors.navyBlue,
                    fontWeight: FontWeight.bold),
                SizedBox(height: height(context) * 0.005),
                CustomText(
                    text: "${LocaleKeys.OrderNumber.tr()}: $orderNo",
                    fontSize: AppFonts.t8,
                    color: AppColors.greyTextColor),
                SizedBox(height: height(context) * 0.005),
                CustomText(
                    text: "${LocaleKeys.OrderNumber.tr()}: $orderDate",
                    fontSize: AppFonts.t8,
                    color: AppColors.greyTextColor),
              ],
            ),
            SizedBox(width: width(context) * 0.01),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomText(
                    textAlign: TextAlign.start,
                    text: "$orderPrice ${LocaleKeys.Rs.tr()}",
                    fontSize: AppFonts.t7,
                    color: AppColors.navyBlue,
                    fontWeight: FontWeight.bold),
                SizedBox(
                  height: height(context) * 0.05,
                ),
                SizedBox(
                  height: height(context) * 0.05,
                  width: width(context) * 0.255,
                  child: CustomButton(
                    colored: true,
                    onPressed: onTap,
                    text: buttonText,
                    fontSize: AppFonts.t9,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
