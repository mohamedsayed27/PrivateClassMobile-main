import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:private_courses/components/cannot_access_content.dart';
import 'package:private_courses/screens/student/course_details/view/course_details_view.dart';
import 'package:private_courses/screens/student/home/controller/home_cubit.dart';

import '../../../../components/custom_text.dart';
import '../../../../components/empty_list.dart';
import '../../../../components/my_navigate.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/size.dart';
import '../../../../core/local/app_cached.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/local/cache_helper.dart';
import '../../../common/drawer/components/custom_zoom_drawer.dart';
import '../../all_secondary_department/view/all_secondary_department_view.dart';
import '../../home/components/secondary_item.dart';
import '../controller/all_secondary_cubit.dart';

class SecondaryView extends StatelessWidget {
  const SecondaryView({required this.cubit, required this.secondaryId});
  final secondaryId;

  final HomeCubit cubit;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index1) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomText(
                        text: cubit.secondaryModel!.data[index1].name),
                    const Spacer(),
                    cubit.secondaryModel!.data[index1].courses.isEmpty
                        ? SizedBox.shrink()
                        : cubit.secondaryModel!.data.isEmpty
                            ? const SizedBox.shrink()
                            : GestureDetector(
                                onTap: () {
                                  navigateTo(context,
                                      CustomZoomDrawer(
                                        mainScreen:
                                            AllSecondaryDepartmentScreen(
                                          textAppBar: cubit.secondaryModel!.data[index1].name,
                                          stageId: cubit.secondaryModel!.data[index1].id,
                                          valueChanged: (v) {
                                            cubit.getAllSecondery(context, secondaryId);
                                          },
                                        ),
                                        isTeacher: CacheHelper.getData(key: AppCached.role),
                                      ));
                                },
                                child: Image.asset("assets/images/1000048704.png",scale: 5,),
                              )
                  ],
                ),
                SizedBox(height: height(context) * 0.02),
                cubit.secondaryModel!.data[index1].courses.isEmpty
                    ? SizedBox(height: height(context) * 0.33,child: const EmptyList())
                    : SizedBox(
                        height: height(context) * 0.34,
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
                                                  .secondaryModel!
                                                  .data[index1]
                                                  .courses[index2]
                                                  .id,
                                              courseName: cubit
                                                  .secondaryModel!
                                                  .data[index1]
                                                  .courses[index2]
                                                  .name,
                                              valueChanged: (v) {
                                                cubit.getAllUniversity(
                                                    context, secondaryId);
                                              }),
                                          isTeacher: CacheHelper.getData(
                                              key: AppCached.role),
                                        )):
                                    showDialog(context: context, builder: (context) => CannotAccessContent(),);
                                  },
                                  child: SecondaryItem(
                                    onTap: () {
                                      cubit.saveSecondaryCourse(
                                          context: context,
                                          id: cubit.secondaryModel!.data[index1].courses[index2].id,
                                          index1: index1,
                                          index2: index2);
                                    },
                                    courseName: cubit.secondaryModel!.data[index1].courses[index2].name,
                                    courseDetails: cubit.secondaryModel!.data[index1].courses[index2].details,
                                    coursePrice: cubit.secondaryModel!.data[index1].courses[index2].price,
                                    coursePhoto: cubit.secondaryModel!.data[index1].courses[index2].photo,
                                    duration: cubit.secondaryModel!.data[index1].courses[index2].duration,
                                    isFavorite: cubit.secondaryModel!.data[index1].courses[index2].isFavorite,
                                    courseId: cubit.secondaryModel!.data[index1].courses[index2].id,
                                    isInstallment: cubit.secondaryModel!.data[index1].courses[index2].isInstallment,
                                  ),
                                ),
                            separatorBuilder: (context, index) =>
                                SizedBox(width: width(context) * 0.025),
                            itemCount: cubit.secondaryModel!.data[index1]
                                        .courses.length >=
                                    5
                                ? 5
                                : cubit.secondaryModel!.data[index1].courses
                                    .length),
                      )
              ],
            ),
        separatorBuilder: (context, index) =>
            SizedBox(height: height(context) * 0.02),
        itemCount: cubit.secondaryModel!.data.length);
  }
}
