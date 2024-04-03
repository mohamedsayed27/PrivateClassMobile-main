import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:private_courses/components/cannot_access_content.dart';

import '../../../../components/custom_text.dart';
import '../../../../components/empty_list.dart';
import '../../../../components/my_navigate.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/size.dart';
import '../../../../core/local/app_cached.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/local/cache_helper.dart';
import '../../../common/drawer/components/custom_zoom_drawer.dart';
import '../../course_details/view/course_details_view.dart';
import '../../home/components/university_item.dart';
import '../../one_of_faculty/view/one_of_faculty_view.dart';
import '../controller/all_university_department_cubit.dart';

class CollegesView extends StatelessWidget {
  CollegesView({required this.cubit, required this.universityId});
  AllUniversityDepartmentCubit cubit;
  int universityId;
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
                        SizedBox(
                            width: width(context) * 0.6,
                            child: CustomText(
                                text: cubit.allUniversityDepartmentModel!
                                    .data[index1].name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis)),
                        const Spacer(),
                        cubit.allUniversityDepartmentModel!.data[index1].courses
                                .isEmpty
                            ? const SizedBox.shrink()
                            : GestureDetector(
                                onTap: () {
                                  navigateTo(
                                      context,
                                      CustomZoomDrawer(
                                        mainScreen: OneOfFacultyScreen(
                                          textAppBar: cubit.allUniversityDepartmentModel!.data[index1].name,
                                          facultyId: cubit.allUniversityDepartmentModel!.data[index1].id,
                                          valueChanged: (v) {
                                            cubit.getAllUniversityDepartment(context, universityId);
                                          },
                                        ),
                                        isTeacher: CacheHelper.getData(
                                            key: AppCached.role),
                                      ));
                                },
                                child: CustomText(
                                    text: LocaleKeys.AllCourses.tr(),
                                    color: AppColors.goldColor,
                                    fontSize: AppFonts.t8),
                              )
                      ],
                    ),
                    SizedBox(height: height(context) * 0.02),
                    cubit.allUniversityDepartmentModel!.data[index1].courses
                            .isNotEmpty
                        ? SizedBox(
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
                                        navigateTo(
                                            context,
                                            CustomZoomDrawer(
                                              mainScreen: CourseDetailsScreen(
                                                fromTeacherProfile: false,
                                                courseId: cubit
                                                    .allUniversityDepartmentModel!
                                                    .data[index1]
                                                    .courses[index2]
                                                    .id,
                                                courseName: cubit
                                                    .allUniversityDepartmentModel!
                                                    .data[index1]
                                                    .courses[index2]
                                                    .name,
                                                valueChanged: (v) {
                                                  cubit
                                                      .getAllUniversityDepartment(
                                                      context,
                                                      universityId);
                                                },
                                              ),
                                              isTeacher: CacheHelper.getData(
                                                  key: AppCached.role),
                                            )):
                                        showDialog(context: context, builder: (context) => CannotAccessContent(),);
                                      },
                                      child: UniversityItem(
                                        onTap: () {
                                          cubit.saveCourse(
                                            context: context,
                                            id: cubit.allUniversityDepartmentModel!.data[index1].courses[index2].id,
                                            index1: index1,
                                            index2: index2,
                                          );
                                        },
                                        courseName: cubit.allUniversityDepartmentModel!.data[index1].courses[index2].name,
                                        coursePhoto: cubit.allUniversityDepartmentModel!.data[index1].courses[index2].photo,
                                        coursePrice: cubit.allUniversityDepartmentModel!.data[index1].courses[index2].price,
                                        courseDetails: cubit.allUniversityDepartmentModel!.data[index1].courses[index2].details,
                                        duration: cubit.allUniversityDepartmentModel!.data[index1].courses[index2].duration,
                                        isFavorite: cubit.allUniversityDepartmentModel!.data[index1].courses[index2].isFavorite,
                                        courseId: cubit.allUniversityDepartmentModel!.data[index1].courses[index2].id,
                                        isInstallment: cubit.allUniversityDepartmentModel!.data[index1].courses[index2].isInstallment,
                                      ),
                                    ),
                                separatorBuilder: (context, index) =>
                                    SizedBox(width: width(context) * 0.025),
                                itemCount: cubit.allUniversityDepartmentModel!
                                            .data[index1].courses.length >=
                                        5
                                    ? 5
                                    : cubit.allUniversityDepartmentModel!
                                        .data[index1].courses.length),
                          )
                        : SizedBox(height: height(context) * 0.33,child: const EmptyList()),
                  ],
                ),
            separatorBuilder: (context, index) =>
                SizedBox(height: height(context) * 0.02),
            itemCount: cubit.allUniversityDepartmentModel!.data.length));
  }
}
