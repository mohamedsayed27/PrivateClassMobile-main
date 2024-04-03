import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:private_courses/components/cannot_access_content.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/screens/common/drawer/components/custom_zoom_drawer.dart';
import 'package:private_courses/screens/student/course_details/view/course_details_view.dart';
import 'package:private_courses/shared/local/cache_helper.dart';

import '../../../../components/style/size.dart';
import '../../home/components/custom_filter/components/filtered_item.dart';
import '../../home/components/university_item.dart';
import '../controller/one_of_faculty_cubit.dart';

class CourseView extends StatelessWidget {
  const CourseView({
    super.key,
    required this.cubit,
    required this.facultyId,
  });
  final int facultyId;

  final OneOfFacultyCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: width(context) * 0.005),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 9,
                mainAxisSpacing: 12,
                childAspectRatio: 2 / 2.7),
            physics: const BouncingScrollPhysics(),
            itemCount: cubit.oneOfFacultyModel!.data.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                CacheHelper.getData(key: AppCached.token) !=null?
                navigateTo(
                    context,
                    CustomZoomDrawer(
                      mainScreen: CourseDetailsScreen(
                          fromTeacherProfile: false,
                          courseId: cubit.oneOfFacultyModel!.data[index].id,
                          courseName: cubit.oneOfFacultyModel!.data[index].name,
                          valueChanged: (v){
                            cubit.getOneOfFacultyCourses(context, facultyId);
                          }),
                      isTeacher: CacheHelper.getData(key: AppCached.role),
                    )):
                showDialog(context: context, builder: (context) => CannotAccessContent(),);
              },
              child: FilteredItem(
                    onTap: () {
                      cubit.saveCourse(
                          context: context,
                          id: cubit.oneOfFacultyModel!.data[index].id,
                          index: index);
                    },
                    courseId: cubit.oneOfFacultyModel!.data[index].id,
                    courseName: cubit.oneOfFacultyModel!.data[index].name,
                    coursePhoto: cubit.oneOfFacultyModel!.data[index].photo,
                    coursePrice: cubit.oneOfFacultyModel!.data[index].price,
                    courseDetails: cubit.oneOfFacultyModel!.data[index].details,
                    duration: cubit.oneOfFacultyModel!.data[index].duration,
                    isFavorite: cubit.oneOfFacultyModel!.data[index].isFavorite,
                   isInstallment: cubit.oneOfFacultyModel!.data[index].isInstallment,
                  ),
            )));
  }
}
