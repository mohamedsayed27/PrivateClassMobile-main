import 'package:flutter/material.dart';
import 'package:private_courses/components/cannot_access_content.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/screens/common/drawer/components/custom_zoom_drawer.dart';
import 'package:private_courses/screens/student/course_details/view/course_details_view.dart';
import 'package:private_courses/screens/student/home/components/custom_filter/components/filtered_item.dart';
import 'package:private_courses/shared/local/cache_helper.dart';

import '../../../../components/style/size.dart';
import '../../home/components/secondary_item.dart';
import '../controller/one_of_subject_cubit.dart';

class SubjectView extends StatelessWidget {
  const SubjectView({
    super.key,
    required this.cubit,
    required this.subjectId,
  });

  final OneOfSubjectCubit cubit;
  final int subjectId;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 9,
        mainAxisSpacing: 12,
        childAspectRatio: 2 / 2.5,
      ),
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsetsDirectional.only(bottom: height(context) * 0.02),
      shrinkWrap: true,
      itemCount: cubit.oneOfSubjectModel!.data.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          CacheHelper.getData(key: AppCached.token)!=null?
          navigateTo(context,
              CustomZoomDrawer(
                mainScreen: CourseDetailsScreen(
                    fromTeacherProfile: false,
                    courseId: cubit.oneOfSubjectModel!.data[index].id,
                    courseName: cubit.oneOfSubjectModel!.data[index].name,
                    valueChanged: (v){
                      cubit.getOneOfSubjectCourses(context, subjectId);
                    }),
                isTeacher: CacheHelper.getData(key: AppCached.role),
              )):
              showDialog(context: context, builder: (context) => CannotAccessContent(),);
        },
        child: FilteredItem(
          onTap: () {
            cubit.saveCourse(
                context: context,
                id: cubit.oneOfSubjectModel!.data[index].id,
                index: index);
          },
          courseName: cubit.oneOfSubjectModel!.data[index].name,
          courseDetails: cubit.oneOfSubjectModel!.data[index].details,
          coursePrice: cubit.oneOfSubjectModel!.data[index].price,
          coursePhoto: cubit.oneOfSubjectModel!.data[index].photo,
          duration: cubit.oneOfSubjectModel!.data[index].duration,
          isFavorite: cubit.oneOfSubjectModel!.data[index].isFavorite,
          courseId: cubit.oneOfSubjectModel!.data[index].id,
          isInstallment: cubit.oneOfSubjectModel!.data[index].isInstallment,
        ),
      ),
    ));
  }
}
