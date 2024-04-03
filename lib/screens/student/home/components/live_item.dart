import 'package:flutter/material.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';

class LiveItem extends StatelessWidget {
  final String teacherName;
  final String teacherPhoto;
  final String liveTime;
  final String liveDate;
  final CrossAxisAlignment? cross;
  final String lectureName;
  final Function() onTap;
  LiveItem(
      {required this.teacherName,
      required this.teacherPhoto,
      required this.lectureName,
      required this.liveDate,
      required this.liveTime,
      required this.onTap,
      this.cross});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
            vertical: height(context) * 0.005,
            horizontal: width(context) * 0.015),
        child: Column(
          crossAxisAlignment: cross ?? CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height(context) * 0.1,
              child: CircleAvatar(
                  backgroundImage: NetworkImage(teacherPhoto),
                  radius: 78,
                  backgroundColor: AppColors.whiteColor),
            ),
            SizedBox(height: height(context) * 0.005),
            Align(
              alignment: AlignmentDirectional.topStart,
              child: CustomText(
                text: lectureName,
                color: AppColors.blackColor,
                fontSize: AppFonts.t8,
              ),
            ),
            SizedBox(height: height(context) * 0.0025),
            Align(
              alignment: AlignmentDirectional.topStart,
              child: CustomText(
                  text: teacherName,
                  color: AppColors.navyBlue,
                  fontSize: AppFonts.t9),
            ),
            SizedBox(height: height(context) * 0.0025),
            Row(children: [
              Image.asset(AppImages.clock, scale: 2.5),
              SizedBox(width: width(context) * 0.008),
              CustomText(
                  text: liveTime,
                  fontSize: AppFonts.t11,
                  color: AppColors.greyTextColor),
            ]),
            SizedBox(height: height(context) * 0.0025),
            Row(
              children: [
                Image.asset(AppImages.calendar, scale: 2.5),
                SizedBox(width: width(context) * 0.008),
                CustomText(
                    text: liveDate,
                    fontSize: AppFonts.t11,
                    color: AppColors.greyTextColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
