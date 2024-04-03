import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:private_courses/screens/common/chat_details/view/chat_details_view.dart';
import 'package:private_courses/screens/student/product_details/controller/product_details_cubit.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/my_navigate.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../core/local/app_cached.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/local/cache_helper.dart';
import '../../../common/drawer/components/custom_zoom_drawer.dart';
import '../../course_details/components/custom_bottom.dart';
import '../../teacher_profile/view/teacher_profile_view.dart';

class AboutTeacher extends StatelessWidget {
  final ProductDetailsCubit cubit;

  const AboutTeacher({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width(context)*0.01,vertical: height(context)*0.02),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.whiteColor,
                radius: width(context) * 0.1,
                backgroundImage: NetworkImage(
                    cubit.courseDetailsModel!.data!.teacher!.photo!),
              ),
              SizedBox(
                width: width(context) * 0.02,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                      text: cubit.courseDetailsModel!.data!.teacher!.name!),
                  CustomText(
                      text: cubit.courseDetailsModel!.data!.teacher!.jobTitle!,
                      fontSize: AppFonts.t7,
                      color: AppColors.goldColor),
                ],
              )
            ],
          ),
          SizedBox(
            height: height(context) * 0.02,
          ),
          Row(
            children: [
              Expanded(
                  child: CustomBottomIcon(
                      text: LocaleKeys.StartAConversation.tr(),
                      image: AppImages.messageWhite,
                      onPressed: () {
                        navigateTo(
                            context,
                            CustomZoomDrawer(
                              mainScreen: ChatDetailsScreen(
                                receiverId: cubit
                                    .courseDetailsModel!.data!.teacher!.id!
                                    .toString(),
                                receiverImage: cubit
                                    .courseDetailsModel!.data!.teacher!.photo!,
                                receiverName: cubit
                                    .courseDetailsModel!.data!.teacher!.name!,
                                valueChanged: (value) {},
                              ),
                              isTeacher: CacheHelper.getData(key: AppCached.role),
                            ));
                      },
                      colored: true,
                      scale: 3.2)),
              SizedBox(width: width(context) * 0.02),
              Expanded(
                  child: CustomBottomIcon(
                      text: LocaleKeys.ProfilePreview.tr(),
                      image: AppImages.userBlue,
                      onPressed: () {
                        navigateTo(
                            context,
                            CustomZoomDrawer(
                              mainScreen: TeacherProfileScreen(
                                id: cubit.courseDetailsModel!.data!.teacher!.id!,
                                fromStore: true,
                              ),
                              isTeacher: CacheHelper.getData(key: AppCached.role),
                            ));
                      },
                      colored: false,
                      scale: 3.5,
                      fontSize: AppFonts.t11)),
            ],
          ),
          SizedBox(
            height: height(context) * 0.01,
          ),
          CustomText(
              text: cubit.courseDetailsModel!.data!.teacher!.pio ?? "",
              color: AppColors.greyBoldColor,
              fontSize: AppFonts.t9),
          SizedBox(
            height: height(context) * 0.01,
          )
        ],
      ),
    );
  }
}
