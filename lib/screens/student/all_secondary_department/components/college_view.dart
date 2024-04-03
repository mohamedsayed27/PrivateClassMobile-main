import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:private_courses/components/cannot_access_content.dart';
import 'package:private_courses/screens/student/course_details/view/course_details_view.dart';

import '../../../../components/custom_text.dart';
import '../../../../components/empty_list.dart';
import '../../../../components/my_navigate.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/size.dart';
import '../../../../core/local/app_cached.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/local/cache_helper.dart';
import '../../../common/drawer/components/custom_zoom_drawer.dart';
import '../../home/components/secondary_item.dart';
import '../../one_of_subject/view/one_of_subject_view.dart';
import '../controller/all_secondary_department_cubit.dart';

class CollegeView extends StatelessWidget {
  const CollegeView({
    required this.cubit,
    required this.stageId,
  });

  final int stageId;
  final AllSecondaryDepartmentCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.separated(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index1) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomText(
                            text: cubit.allSecondaryDepartmentModel!.data[index1].name),
                        const Spacer(),
                        cubit.allSecondaryDepartmentModel!.data[index1].courses.isEmpty
                            ? const SizedBox.shrink()
                            : GestureDetector(
                                onTap: () {
                                  print(stageId);
                                  navigateTo(
                                      context,
                                      CustomZoomDrawer(
                                        mainScreen: OneOfSubjectScreen(
                                          textAppBar: cubit.allSecondaryDepartmentModel!.data[index1].name,
                                          subjectId: cubit.allSecondaryDepartmentModel!.data[index1].id,
                                          valueChanged: (v) {
                                            cubit.getAllUniversityDepartment(context, stageId);
                                          },
                                        ),
                                        isTeacher: CacheHelper.getData(
                                            key: AppCached.role),
                                      ));
                                },
                                child: CustomText(
                                    text: LocaleKeys.AllMaterials.tr(),
                                    color: AppColors.goldColor,
                                    fontSize: AppFonts.t8),
                              )
                      ],
                    ),
                    SizedBox(height: height(context) * 0.02),
                    cubit.allSecondaryDepartmentModel!.data[index1].courses.isEmpty
                        ? SizedBox(height: height(context) * 0.33,child: const EmptyList())
                        : SizedBox(
                            height: height(context) * 0.32,
                            child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                padding: EdgeInsets.symmetric(
                                    vertical: height(context) * 0.01,
                                    horizontal: width(context) * 0.01),
                                shrinkWrap: true,
                                itemBuilder: (context, index2) =>
                                    GestureDetector(
                                      onTap: () {
                                        CacheHelper.getData(key: AppCached.token) !=null?
                                        navigateTo(context,
                                            CustomZoomDrawer(
                                              mainScreen: CourseDetailsScreen(
                                                  fromTeacherProfile: false,
                                                  courseId: cubit
                                                      .allSecondaryDepartmentModel!
                                                      .data[index1]
                                                      .courses[index2]
                                                      .id,
                                                  courseName: cubit
                                                      .allSecondaryDepartmentModel!
                                                      .data[index1]
                                                      .courses[index2]
                                                      .name,
                                                  valueChanged: (v) {
                                                    cubit
                                                        .getAllUniversityDepartment(
                                                        context, stageId);
                                                  }),
                                              isTeacher: CacheHelper.getData(
                                                  key: AppCached.role),
                                            )):
                                        showDialog(context: context, builder: (context) => CannotAccessContent(),);
                                      },
                                      child: SecondaryItem(
                                        onTap: () {
                                          cubit.saveCourse(
                                              context: context,
                                              id: cubit.allSecondaryDepartmentModel!.data[index1].courses[index2].id,
                                              index1: index1,
                                              index2: index2);
                                        },
                                        courseName: cubit.allSecondaryDepartmentModel!.data[index1].courses[index2].name,
                                        courseDetails: cubit.allSecondaryDepartmentModel!.data[index1].courses[index2].details,
                                        coursePrice: cubit.allSecondaryDepartmentModel!.data[index1].courses[index2].price,
                                        coursePhoto: cubit.allSecondaryDepartmentModel!.data[index1].courses[index2].photo,
                                        duration: cubit.allSecondaryDepartmentModel!.data[index1].courses[index2].duration,
                                        isFavorite: cubit.allSecondaryDepartmentModel!.data[index1].courses[index2].isFavorite,
                                        courseId: cubit.allSecondaryDepartmentModel!.data[index1].courses[index2].id,
                                        isInstallment: cubit.allSecondaryDepartmentModel!.data[index1].courses[index2].isInstallment,
                                      ),
                                    ),
                                separatorBuilder: (context, index) =>
                                    SizedBox(width: width(context) * 0.025),
                                itemCount: cubit.allSecondaryDepartmentModel!
                                            .data[index1].courses.length >=
                                        5
                                    ? 5
                                    : cubit.allSecondaryDepartmentModel!
                                        .data[index1].courses.length),
                          )
                  ],
                ),
            separatorBuilder: (context, index) =>
                SizedBox(height: height(context) * 0.02),
            itemCount: cubit.allSecondaryDepartmentModel!.data.length));
  }
}
