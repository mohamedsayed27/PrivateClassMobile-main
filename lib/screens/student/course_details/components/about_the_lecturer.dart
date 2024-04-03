// ignore_for_file: unnecessary_null_comparison

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/my_navigate.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../core/local/app_cached.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/local/cache_helper.dart';
import '../../../common/chat_details/view/chat_details_view.dart';
import '../../../common/drawer/components/custom_zoom_drawer.dart';
import '../../teacher_profile/view/teacher_profile_view.dart';
import '../controller/course_details_cubit.dart';
import '../controller/course_details_states.dart';
import '../model/chat_user_model.dart';
import 'custom_bottom.dart';

class AboutTheLecturer extends StatelessWidget {
  const AboutTheLecturer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseDetailsCubit, CourseDetailsStates>(
      // listener: (context, state) {},
      builder: (context, state) {
        final cubit = CourseDetailsCubit.get(context);
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: height(context) * 0.02),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundImage: NetworkImage(
                        cubit.courseDetailsModel!.data!.teacher!.photo!),
                    backgroundColor: AppColors.whiteColor,
                  ),
                  SizedBox(width: width(context) * 0.02),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                          text: cubit.courseDetailsModel!.data!.teacher!.name!,
                          fontSize: AppFonts.t7),
                      SizedBox(height: height(context) * 0.002),
                      CustomText(
                          text: cubit.courseDetailsModel!.data!.teacher!.jobTitle!,
                          color: AppColors.goldColor,
                          fontSize: AppFonts.t9),
                    ],
                  ),
                ],
              ),
              SizedBox(height: height(context) * 0.03),
              Row(
                children: [
                  Expanded(child: CustomBottomIcon(
                          text: LocaleKeys.StartAConversation.tr(),
                          image: AppImages.messageWhite,
                          onPressed: () {
                            if (CacheHelper.getData(key: AppCached.token) == null) {
                              debugPrint("Gueeeeeeeeeeeeeeeeeeeeeeeest");
                            } else {
                              debugPrint(" >>>>>>>>>>>>>>> Start Chat <<<<<<<<<<<<<<<<< ");
                              debugPrint(CacheHelper.getData(key: AppCached.userId).toString());

                              ///bymla byanat elsender
                              cubit.createUser(
                                  receiver: UsersModel(
                                      id: cubit.courseDetailsModel!.data!.teacher!.id!,
                                      email: cubit.courseDetailsModel!.data!.teacher!.email!,
                                      lastSeen: "null",
                                      status: "online",
                                      typingTo: 0,
                                      unReadingCount: 0,
                                      photoUrl: cubit.courseDetailsModel!.data!.teacher!.photo!,
                                      name: cubit.courseDetailsModel!.data!.teacher!.name!,
                                      chattingWith: CacheHelper.getData(key: AppCached.userId).toString()),
                                  sender: UsersModel(
                                    id: CacheHelper.getData(key: AppCached.userId),  /// int
                                    name: CacheHelper.getData(key: AppCached.name),
                                    photoUrl: CacheHelper.getData(key: AppCached.image),
                                    chattingWith: cubit.courseDetailsModel!.data!.teacher!.id!.toString(),
                                    email: CacheHelper.getData(key: AppCached.email),
                                    lastSeen: "null",
                                    status: "online",
                                    typingTo: 0,
                                    unReadingCount: 0
                                  ));

                              ///bymla byanat elsender
                              cubit.createUser(
                                  sender: UsersModel(
                                      id: cubit.courseDetailsModel!.data!.teacher!.id!,
                                      email: cubit.courseDetailsModel!.data!.teacher!.email!,
                                      lastSeen: "null",
                                      status: "online",
                                      typingTo: 0,
                                      unReadingCount: 0,
                                      photoUrl: cubit.courseDetailsModel!.data!.teacher!.photo!,
                                      name: cubit.courseDetailsModel!.data!.teacher!.name!,
                                      chattingWith: CacheHelper.getData(key: AppCached.userId).toString()),
                                  receiver: UsersModel(id: CacheHelper.getData(key: AppCached.userId),
                                    chattingWith: cubit.courseDetailsModel!.data!.teacher!.id!.toString(),
                                    email: CacheHelper.getData(key: AppCached.email),
                                    lastSeen: "null",
                                    name: CacheHelper.getData(key: AppCached.name),
                                    photoUrl: CacheHelper.getData(key: AppCached.image),
                                    status: "online",
                                    typingTo: 0,
                                    unReadingCount: 0
                                  ));

                              navigateTo(context, ChatDetailsScreen(
                                    valueChanged: (value) {},
                                    receiverId: cubit.courseDetailsModel!.data!.teacher!.id!.toString(),
                                    receiverImage: cubit.courseDetailsModel!.data!.teacher!.photo!,
                                    receiverName: cubit.courseDetailsModel!.data!.teacher!.name!));
                            }
                          },
                          colored: true,
                          scale: 3.2)),
                  SizedBox(width: width(context) * 0.02),
                  Expanded(
                      child: CustomBottomIcon(
                          text: LocaleKeys.ProfilePreview.tr(),
                          image: AppImages.userBlue,
                          onPressed: () {
                            navigateTo(context, CustomZoomDrawer(
                                    mainScreen: TeacherProfileScreen(
                                      id: cubit.courseDetailsModel!.data!.teacher!.id!,
                                      fromStore: false
                                    ),
                                    isTeacher: CacheHelper.getData(key: AppCached.role)));
                          },
                          colored: false,
                          scale: 3.5)),
                ],
              ),
              cubit.courseDetailsModel!.data!.teacher!.pio==null?SizedBox.shrink():SizedBox(height: height(context) * 0.025),
              cubit.courseDetailsModel!.data!.teacher!.pio==null?SizedBox.shrink():CustomText(
                  text: cubit.courseDetailsModel!.data!.teacher!.pio!,
                  color: AppColors.greyBoldColor,
                  fontSize: AppFonts.t9),
            ],
          ),
        );
      },
    );
  }
}
