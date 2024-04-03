import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../components/custom_text.dart';
import '../../../../components/my_navigate.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../core/local/app_cached.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/local/cache_helper.dart';
import '../../../common/drawer/components/custom_zoom_drawer.dart';
import '../../course_details/view/course_details_view.dart';

class ItemCourse extends StatelessWidget {
  final String courseName;
  final String img;
  final int courseId;
  var percent;
  final int countVideo;
  final bool isFinished;
  ItemCourse(
      {Key? key,
      required this.isFinished,
      required this.percent,
      required this.img,
      required this.countVideo,
      required this.courseName,
      required this.courseId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigateTo(
            context,
            CustomZoomDrawer(
                mainScreen: CourseDetailsScreen(
                    fromTeacherProfile: false,
                    courseId: courseId,
                    courseName: courseName,
                    valueChanged: (v){
                      // cubit.getCurrentCourse(context);
                    }),
                isTeacher: CacheHelper.getData(key: AppCached.role)));
      },
      child: Padding(
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
                width: context.locale.languageCode=="ar"?width(context) * 0.2:width(context) * 0.182,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                        image: NetworkImage(img), fit: BoxFit.fill)),
                // child: Image.asset(AppImages.physics),
              ),
              SizedBox(width: width(context) * 0.02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                      text: courseName,
                      fontSize: AppFonts.t7,
                      color: AppColors.navyBlue,
                      fontWeight: FontWeight.bold),
                  SizedBox(height: height(context) * 0.005),
                  isFinished == false
                      ? CustomText(
                          text: '$countVideo ${LocaleKeys.LessonsLeft.tr()}',
                          fontSize: AppFonts.t9,
                          color: AppColors.greyTextColor)
                      : Row(children: [
                          CustomText(
                              text: LocaleKeys.TheCourseSuccessfully.tr(),
                              fontSize: AppFonts.t11,
                              color: AppColors.greyTextColor),
                          SizedBox(width: width(context) * 0.005),
                          Image.asset(AppImages.imoge,
                              width: width(context) * 0.045),
                        ]),
                ],
              ),
              const Spacer(),
              CircularPercentIndicator(
                radius: 35,
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
        ),
      ),
    );
  }
}
