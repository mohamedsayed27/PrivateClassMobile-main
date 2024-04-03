import 'package:flutter/material.dart';
import 'package:private_courses/components/cannot_access_content.dart';
import 'package:private_courses/components/empty_list.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/screens/common/drawer/components/custom_zoom_drawer.dart';
import 'package:private_courses/screens/student/course_details/view/course_details_view.dart';
import 'package:private_courses/screens/student/home/components/university_item.dart';
import 'package:private_courses/screens/student/home/controller/home_cubit.dart';
import 'package:private_courses/screens/student/home/model/search_model.dart';
import 'package:private_courses/shared/local/cache_helper.dart';

import '../../../../../../components/style/size.dart';
import 'custom_filter/components/filtered_item.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    super.key,
    required this.searchModel,
    required this.cubit,
    required this.courseName,
  });

  final SearchModel? searchModel;
  final HomeCubit? cubit;
  final String courseName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: width(context) * 0.005),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 11,
            mainAxisSpacing: 4,
            childAspectRatio: 2 / 2.7),
        itemCount: searchModel!.data!.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              CacheHelper.getData(key: AppCached.token) !=null?
              navigateTo(
                  context,
                  CustomZoomDrawer(
                    mainScreen: CourseDetailsScreen(
                        fromTeacherProfile: false,
                        courseId: searchModel!.data![index].id!,
                        courseName: searchModel!.data![index].name!,
                        valueChanged: (v) {
                          cubit!.searchCourse(
                              context: context, courseName: courseName);
                        }),
                    isTeacher: CacheHelper.getData(key: AppCached.role),
                  )):
                  showDialog(context: context, builder: (context) => CannotAccessContent(),);
            },
            child: Padding(
              padding:
                  EdgeInsetsDirectional.only(bottom: height(context) * 0.01),
              child: FilteredItem(
                courseName: searchModel!.data![index].name!,
                courseDetails: searchModel!.data![index].details!,
                coursePhoto: searchModel!.data![index].photo!,
                coursePrice: searchModel!.data![index].price!,
                duration: searchModel!.data![index].numHours,
                isFavorite: searchModel!.data![index].isFavorite!,
                isInstallment: searchModel!.data![index].isInstallment!,
                onTap: () {
                  cubit!.saveCourse(
                      id: searchModel!.data![index].id!,
                      context: context,
                      index: index);
                },
                courseId: searchModel!.data![index].id!,
              ),
            ),
          );
        },
      ),
    );
  }
}
