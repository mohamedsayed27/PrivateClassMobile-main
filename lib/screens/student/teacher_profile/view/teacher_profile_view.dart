import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_appBar.dart';
import 'package:private_courses/components/custom_loading.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/screens/common/drawer/components/custom_zoom_drawer.dart';
import 'package:private_courses/screens/student/course_details/view/course_details_view.dart';
import 'package:private_courses/screens/student/product_details/view/product_details_view.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../generated/locale_keys.g.dart';
import '../components/course_item.dart';
import '../controller/teacher_profile_cubit.dart';
import '../controller/teacher_profile_states.dart';

class TeacherProfileScreen extends StatelessWidget {
  final int id;
  final bool fromStore;
  const TeacherProfileScreen(
      {super.key, required this.id, required this.fromStore});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TeacherProfileCubit()..getTeacherProfile(context: context, id: id),
      child: BlocBuilder<TeacherProfileCubit, TeacherProfileStates>(
          builder: (context, state) {
        final cubit = TeacherProfileCubit.get(context);
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: width(context) * 0.04),
            child: Column(
              children: [
                CustomAppBar(
                    isNotify: false,
                    textAppBar: LocaleKeys.PersonalTeacherAccount.tr()),
                Expanded(
                    child: state is TeacherProfileLoadingState
                        ? const CustomLoading(load: true)
                        : SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                SizedBox(height: height(context) * 0.02),
                                CircleAvatar(
                                  radius: 45,
                                  backgroundImage: NetworkImage(
                                      cubit.teacherProfileModel!.data!.photo!),
                                ),
                                SizedBox(height: height(context) * 0.015),
                                CustomText(
                                    text:
                                        cubit.teacherProfileModel!.data!.name!,
                                    fontSize: AppFonts.t6),
                                CustomText(
                                    text: cubit
                                        .teacherProfileModel!.data!.jobTitle!,
                                    color: AppColors.goldColor,
                                    fontSize: AppFonts.t8),
                                SizedBox(height: height(context) * 0.035),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Image.asset(AppImages.profiles,
                                              width: width(context) * 0.06),
                                          SizedBox(
                                              height: height(context) * 0.01),
                                          CustomText(
                                              text:
                                                  "${cubit.teacherProfileModel!.data!.numSubscribes!} ${LocaleKeys.Subscriber.tr()}",
                                              fontSize: AppFonts.t10),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: width(context) * 0.01),
                                    Image.asset(AppImages.lineHeight,
                                        width: width(context) * 0.003,
                                        height: height(context) * 0.07),
                                    SizedBox(width: width(context) * 0.01),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Image.asset(AppImages.bookActive,
                                              width: width(context) * 0.059),
                                          SizedBox(
                                              height: height(context) * 0.01),
                                          CustomText(
                                              text:
                                                  "${cubit.teacherProfileModel!.data!.numCourses!} ${LocaleKeys.Courses.tr()}",
                                              fontSize: AppFonts.t10),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: width(context) * 0.01),
                                    Image.asset(AppImages.lineHeight,
                                        width: width(context) * 0.003,
                                        height: height(context) * 0.07),
                                    SizedBox(width: width(context) * 0.01),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Image.asset(AppImages.vector,
                                              width: width(context) * 0.058),
                                          SizedBox(
                                              height: height(context) * 0.01),
                                          CustomText(
                                              text:
                                                  "${LocaleKeys.JoinedSince.tr()} ${cubit.teacherProfileModel!.data!.createdAt!}",
                                              fontSize: AppFonts.t10),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: height(context) * 0.008),
                                Image.asset(AppImages.lineWidth),
                                SizedBox(height: height(context) * 0.03),
                                Align(
                                    alignment: AlignmentDirectional.centerStart,
                                    child: CustomText(
                                        text: LocaleKeys.AvailableCourses.tr(),
                                        color: AppColors.navyBlue,
                                        fontSize: AppFonts.t6)),
                                SizedBox(height: height(context) * 0.025),
                                GridView.builder(
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 11,
                                      mainAxisSpacing: 12,
                                      childAspectRatio: 1.82 / 2.5,
                                    ),
                                    physics: const BouncingScrollPhysics(),
                                    padding: EdgeInsetsDirectional.only(
                                        bottom: height(context) * 0.02,start: width(context)*0.01,end: width(context)*0.01),
                                    shrinkWrap: true,
                                    itemCount: cubit.teacherProfileModel!.data!.courses!.length,
                                    itemBuilder: (context, index) => GestureDetector(
                                      onTap: (){
                                        navigateTo(context,
                                            fromStore == true ? CustomZoomDrawer(
                                              mainScreen: ProductDetailsScreen(
                                                  id: cubit.teacherProfileModel!.data!.courses![index].id!,
                                                  fromTeacherProfile: true,
                                                 valueChanged: (v){
                                                cubit.getTeacherProfile(context: context, id: id);
                                              }),
                                                isTeacher: CacheHelper.getData(key: AppCached.role),
                                            )
                                                : CustomZoomDrawer(
                                              mainScreen: CourseDetailsScreen(
                                                  fromTeacherProfile: true,
                                                  courseId: cubit.teacherProfileModel!.data!.courses![index].id!,
                                                  courseName: cubit.teacherProfileModel!.data!.courses![index].name!,
                                                  valueChanged: (v){
                                                    cubit.getTeacherProfile(context: context, id: id);
                                                  }),
                                              isTeacher: CacheHelper.getData(key: AppCached.role),
                                            ));
                                      },
                                      child: CourseItem(
                                        isInstallment: cubit.teacherProfileModel!.data!.courses![index].isInstallment!,
                                            onTap: () {
                                              cubit.saveCourse(
                                                  context: context,
                                                  id: cubit.teacherProfileModel!.data!.courses![index].id!,
                                                  index: index);
                                            },
                                            courseName: cubit.teacherProfileModel!.data!.courses![index].name!,
                                            coursePhoto: cubit.teacherProfileModel!.data!.courses![index].photo!,
                                            coursePrice: cubit.teacherProfileModel!.data!.courses![index].price!,
                                            courseDetails: cubit.teacherProfileModel!.data!.courses![index].details!,
                                            duration: cubit.teacherProfileModel!.data!.courses![index].duration!,
                                            isFavorite: cubit.teacherProfileModel!.data!.courses![index].isFavorite!,
                                            id: cubit.teacherProfileModel!.data!.courses![index].id!,
                                            fromStore: fromStore,
                                          ),
                                    )),
                                SizedBox(height: height(context) * 0.02),
                              ],
                            ),
                          )),
              ],
            ),
          ),
        );
      }),
    );
  }
}
