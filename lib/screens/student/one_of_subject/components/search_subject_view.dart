import 'package:flutter/material.dart';
import 'package:private_courses/components/cannot_access_content.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/screens/common/drawer/components/custom_zoom_drawer.dart';
import 'package:private_courses/screens/student/home/components/custom_filter/components/filtered_item.dart';
import 'package:private_courses/shared/local/cache_helper.dart';

import '../../../../components/style/size.dart';
import '../../course_details/view/course_details_view.dart';
import '../../home/components/secondary_item.dart';
import '../controller/one_of_subject_cubit.dart';

class SearchSubjectView extends StatelessWidget {
  const SearchSubjectView({
    super.key,
    required this.cubit,
    required this.subjId,
  });

  final OneOfSubjectCubit cubit;
  final int subjId;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 9,
        mainAxisSpacing: 12,
        childAspectRatio: 1.82 / 2.5,
      ),
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsetsDirectional.only(bottom: height(context) * 0.02),
      shrinkWrap: true,
      itemCount: cubit.searchModel!.data!.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          CacheHelper.getData(key: AppCached.token) !=null?
          navigateTo(
              context,
              CustomZoomDrawer(
                mainScreen: CourseDetailsScreen(
                    fromTeacherProfile: false,
                    courseId: cubit.oneOfSubjectModel!.data[index].id,
                    courseName: cubit.oneOfSubjectModel!.data[index].name,
                    valueChanged: (v) {
                      cubit.getOneOfSubjectCourses(context, subjId);
                    }),
                isTeacher: CacheHelper.getData(key: AppCached.role),
              )):
          showDialog(context: context, builder: (context) => CannotAccessContent(),);

        },
        child: FilteredItem(
          onTap: () {
            cubit.saveSearchedCourse(
                context: context,
                id: cubit.searchModel!.data![index].id,
                index: index);
          },
          courseName: cubit.searchModel!.data![index].name,
          courseDetails: cubit.searchModel!.data![index].details,
          coursePrice: cubit.searchModel!.data![index].price,
          coursePhoto: cubit.searchModel!.data![index].photo,
          duration: cubit.searchModel!.data![index].numHours,
          isFavorite: cubit.searchModel!.data![index].isFavorite,
          courseId: cubit.searchModel!.data![index].id,
          isInstallment: cubit.searchModel!.data![index].isInstallment,
        ),
      ),
    ));
  }
}
