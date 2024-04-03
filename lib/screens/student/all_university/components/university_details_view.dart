import 'package:flutter/material.dart';
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
import '../../all_university_department/view/all_university_department_view.dart';
import '../../home/components/university_item.dart';
import '../controller/all_university_cubit.dart';

class UniversityDetailsView extends StatelessWidget {
  const UniversityDetailsView(
      {Key? key, required this.cubit, required this.universityId});
  final int universityId;
  final AllUniversityCubit cubit;
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
                          width: width(context) * 0.7,
                          child: CustomText(
                            text: cubit.universityAllModel!.data[index1].name,
                          )),
                      const Spacer(),
                      cubit.universityAllModel!.data[index1].courses.isEmpty
                          ? SizedBox.shrink()
                          : GestureDetector(
                              onTap: () {
                                navigateTo(
                                    context,
                                    CustomZoomDrawer(
                                      mainScreen: AllUniversityDepartmentScreen(
                                        textAppBar: cubit.universityAllModel!
                                            .data[index1].name,
                                        universityId: cubit.universityAllModel!
                                            .data[index1].id,
                                        valueChanged: (v) {
                                          cubit.getAllUniversity(
                                              context, universityId);
                                        },
                                      ),
                                      isTeacher: CacheHelper.getData(
                                          key: AppCached.role),
                                    ));
                              },
                              child: CustomText(
                                  text: LocaleKeys.Details.tr(),
                                  color: AppColors.goldColor,
                                  fontSize: AppFonts.t8),
                            )
                    ],
                  ),
                  SizedBox(height: height(context) * 0.02),
                  cubit.universityAllModel!.data[index1].courses.isEmpty
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
                              itemBuilder: (context, index) => GestureDetector(
                                    onTap: () {
                                      CacheHelper.getData(key: AppCached.token) !=null?
                                      navigateTo(
                                          context,
                                          CustomZoomDrawer(
                                            mainScreen: CourseDetailsScreen(
                                              fromTeacherProfile: false,
                                              courseId: cubit.universityAllModel!.data[index1].courses[index].id,
                                              courseName: cubit.universityAllModel!.data[index1].courses[index].name,
                                              valueChanged: (v) {
                                                cubit.getAllUniversity(
                                                    context, universityId);
                                              },
                                            ),
                                            isTeacher: CacheHelper.getData(
                                                key: AppCached.role),
                                          )):
                                      showDialog(context: context, builder: (context) => CannotAccessContent(),);

                                      // navigateTo(
                                      //     context,
                                      //     CustomZoomDrawer(
                                      //       mainScreen: CourseDetailsScreen(
                                      //         fromTeacherProfile: false,
                                      //         courseId: cubit.universityAllModel!.data[index1].courses[index].id,
                                      //         courseName: cubit.universityAllModel!.data[index1].courses[index].name,
                                      //         valueChanged: (v) {
                                      //           cubit.getAllUniversity(
                                      //               context, universityId);
                                      //         },
                                      //       ),
                                      //       isTeacher: CacheHelper.getData(
                                      //           key: AppCached.role),
                                      //     ));
                                    },
                                    child: UniversityItem(
                                      onTap: () {
                                        cubit.saveUniversityCourse(
                                          context: context,
                                          id: cubit.universityAllModel!.data[index1].courses[index].id,
                                          index1: index1,
                                          index2: index,
                                        );
                                      },
                                      courseId: cubit.universityAllModel!.data[index1].courses[index].id,
                                      courseName: cubit.universityAllModel!.data[index1].courses[index].name,
                                      coursePhoto: cubit.universityAllModel!.data[index1].courses[index].photo,
                                      coursePrice: cubit.universityAllModel!.data[index1].courses[index].price,
                                      courseDetails: cubit.universityAllModel!.data[index1].courses[index].details,
                                      duration: cubit.universityAllModel!.data[index1].courses[index].duration,
                                      isFavorite: cubit.universityAllModel!.data[index1].courses[index].isFavorite,
                                      isInstallment: cubit.universityAllModel!.data[index1].courses[index].isInstallment,
                                    ),
                                  ),
                              separatorBuilder: (context, index) =>
                                  SizedBox(width: width(context) * 0.025),
                              itemCount: cubit.universityAllModel!.data[index1].courses.length >= 5
                                  ? 5
                                  : cubit.universityAllModel!.data[index1].courses.length),
                        )
                ],
              ),
          separatorBuilder: (context, index) =>
              SizedBox(height: height(context) * 0.02),
          itemCount: cubit.universityAllModel!.data.length),
    );
  }
}
