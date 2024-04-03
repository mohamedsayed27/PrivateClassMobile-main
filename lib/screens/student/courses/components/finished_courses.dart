import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/empty_list.dart';
import '../../../../components/style/size.dart';
import '../controller/courses_cubit.dart';
import '../controller/courses_states.dart';
import 'item_course.dart';

class FinishedCourses extends StatelessWidget {
  const FinishedCourses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoursesCubit, CoursesStates>(
        builder: (context, state) {
          final cubit = CoursesCubit.get(context);
          return cubit.prevCourses!.isEmpty
              ? Expanded(child: const EmptyList())
              : Expanded(
                child: ListView.separated(
                    padding: EdgeInsetsDirectional.only(
                        start: width(context) * 0.005,
                        top: height(context) * 0.01),
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ItemCourse(
                          courseId: cubit.prevCourses![index].id!,
                          isFinished: true,
                          percent: cubit.prevCourses![index].progress!,
                          courseName: cubit.prevCourses![index].name!,
                          img: cubit.prevCourses![index].photo!,
                          countVideo: cubit.prevCourses![index].countVideos!);
                    },
                    separatorBuilder: (context, index) =>
                        SizedBox(height: height(context) * 0.025),
                    itemCount: cubit.prevCourses!.length),
              );
        },
        listener: (context, state) {});
  }
}
