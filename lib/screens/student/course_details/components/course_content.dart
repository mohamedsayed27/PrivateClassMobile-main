import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/screens/common/drawer/components/custom_zoom_drawer.dart';
import 'package:private_courses/screens/student/course_details/components/subscribe_sccess.dart';
import 'package:private_courses/screens/student/lecture_details_videos/view/lecture_details_view.dart';
import 'package:private_courses/screens/student/payCourse/view/payment_types_course_view.dart';
import 'package:private_courses/screens/student/payment_course/view/payment_course_view.dart';
import 'package:private_courses/screens/student/subscribe_course/view/subscribe_course_view.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/local/cache_helper.dart';
import '../../lecture_details_videos/components/not_pay.dart';
import '../controller/course_details_cubit.dart';
import '../controller/course_details_states.dart';

class CourseContent extends StatelessWidget {
  const CourseContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CourseDetailsCubit, CourseDetailsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = CourseDetailsCubit.get(context);
          return Padding(
            padding: EdgeInsets.symmetric(vertical: height(context) * 0.02),
            child: ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => Column(
                      children: [
                        Row(
                          children: [
                            CustomText(
                                text: cubit.courseDetailsModel!.data!
                                    .categories![index].name!,
                                color: AppColors.navyBlue,
                                fontSize: AppFonts.t8),
                            const Spacer(),
                            Row(
                              children: [
                                Image.asset(AppImages.clock,
                                    width: width(context) * 0.045),
                                SizedBox(width: width(context) * 0.01),
                                CustomText(
                                    text:
                                        "${cubit.courseDetailsModel!.data!.categories![index].timeVideos!}",
                                    color: AppColors.textFieldColor,
                                    fontSize: AppFonts.t10),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: height(context) * 0.02),
                        ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                                vertical: height(context) * 0.005,
                                horizontal: width(context) * 0.01),
                            shrinkWrap: true,
                            itemBuilder: (context, idx) => InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: (){
                                cubit.courseDetailsModel!.data!.categories![index].videos![idx].free! || cubit.courseDetailsModel!.data!.isSubscribed! ?
                                navigateTo(context, CustomZoomDrawer(mainScreen:
                                LectureDetailsScreen(cubit: cubit,
                                    vedIndex: cubit.courseDetailsModel!.data!.categories![index].videos![idx].vedIndx!),
                                    isTeacher: CacheHelper.getData(key: AppCached.role)))
                                    : showDialog(context: context, builder: (context) => NotPayPopup(
                                  onTap: () {
                                    CacheHelper.saveData(AppCached.amountCart,  cubit.courseDetailsModel!.data!.price!);
                                    navigateTo(
                                        context,
                                        CustomZoomDrawer(
                                            mainScreen: PaymentTypesCourseScreen(
                                                isBankPayment: cubit.courseDetailsModel!.data!.isBankPayment!,
                                                id: cubit.courseDetailsModel!.data!.id!,
                                                courseName: cubit.courseDetailsModel!.data!.name!,
                                                isInstallment: cubit.courseDetailsModel!.data!.isInstallment!,
                                                paymentKey: cubit.courseDetailsModel!.data!.paymentKey!,
                                                amount: double.parse(cubit.courseDetailsModel!.data!.price!).round()),
                                            isTeacher: CacheHelper.getData(key: AppCached.role)));
                                  },
                                ));
                              },
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
                                        vertical: height(context) * 0.01,
                                        horizontal: width(context) * 0.015),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: width(context) * 0.1,
                                          decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      AppImages.circleNumber))),
                                          child: Center(
                                              child: CustomText(
                                                  text:
                                                      '${cubit.courseDetailsModel!.data!.categories![index].videos![idx].vedIndx! + 1}',
                                                  color: AppColors.whiteColor,
                                                  fontSize: AppFonts.t8)),
                                        ),
                                        SizedBox(width: width(context) * 0.015),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              child: CustomText(
                                                  text: cubit
                                                      .courseDetailsModel!
                                                      .data!
                                                      .categories![index]
                                                      .videos![idx]
                                                      .name!,
                                                  color: AppColors.navyBlue,
                                                  fontSize: AppFonts.t7),
                                              width: width(context)*0.6
                                            ),
                                            Row(
                                              children: [
                                                Image.asset(
                                                  AppImages.clock,
                                                  width: width(context) * 0.04,
                                                  color: AppColors.textFieldColor,
                                                ),
                                                SizedBox(
                                                    width: width(context) * 0.01),
                                                CustomText(
                                                    text: cubit
                                                        .courseDetailsModel!
                                                        .data!
                                                        .categories![index]
                                                        .videos![idx]
                                                        .timeVideo
                                                        .toString(),
                                                    color:
                                                        AppColors.textFieldColor,
                                                    fontSize: AppFonts.t10),
                                              ],
                                            )
                                          ],
                                        ),
                                        const Spacer(),

                                        /// -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
                                        /// -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
                                        /// -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
                                        /// -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
                                        cubit.courseDetailsModel!.data!.isSubscribed! || cubit.courseDetailsModel!.data!.categories![index].videos![idx].free!
                                            ? Image.asset(AppImages.videosCircle, scale: 2.2)
                                            : Image.asset(AppImages.vedioNotFree, scale: 3.7),
                                        SizedBox(width: width(context) * 0.015),
                                      ],
                                    ),
                                  ),
                            ),
                            separatorBuilder: (context, index) => SizedBox(height: height(context) * 0.025),
                            itemCount: cubit.courseDetailsModel!.data!.categories![index].videos!.length)
                      ],
                    ),
                separatorBuilder: (context, index) =>
                    SizedBox(height: height(context) * 0.02),
                itemCount: cubit.courseDetailsModel!.data!.categories!.length),
          );
        });
  }
}
