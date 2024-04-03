import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:private_courses/components/custom_text.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/components/style/size.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/screens/common/drawer/components/custom_zoom_drawer.dart';
import 'package:private_courses/screens/student/course_details/view/course_details_view.dart';
import 'package:private_courses/shared/local/cache_helper.dart';

import '../../../../components/style/colors.dart';
import '../../../../generated/locale_keys.g.dart';

class CourseItem extends StatelessWidget {
  final double percent;
  final String courseName;
  final String leftCourses;
  final String courseImage;
  final int courseId;
  const CourseItem({
    required this.percent,
    required this.courseName,
    required this.leftCourses,
    required this.courseImage,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width(context) * 0.91,
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
          horizontal: width(context) * 0.03),
      child: Row(
        children: [
          Container(
             width: width(context) * 0.15,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    image: NetworkImage(courseImage), fit: BoxFit.fill)),
            // child: Image.asset(AppImages.physics),
          ),
          SizedBox(width: width(context) * 0.03),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                  text: LocaleKeys.CurrentCourse.tr(),
                  fontSize: AppFonts.t6,
                  color: AppColors.blackColor),
              SizedBox(
                width: width(context)*0.51,
                child: CustomText(
                    text: courseName,
                    fontSize: AppFonts.t7,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    color: AppColors.navyBlue),
              ),
              CustomText(
                  text: leftCourses,
                  fontSize: AppFonts.t9,
                  color: AppColors.textFieldColor)
            ],
          ),
          const Spacer(),
          CircularPercentIndicator(
            radius: 30,
            lineWidth: 5,
            animation: true,
            percent: percent / 100,
            center: CustomText(
                text: "${percent.toInt()} %",
                fontSize: AppFonts.t7,
                fontWeight: FontWeight.bold,
                color: AppColors.navyBlue),
            backgroundColor: AppColors.textFieldColor,
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: AppColors.navyBlue,
          )
        ],
      ),
    );
  }
}
