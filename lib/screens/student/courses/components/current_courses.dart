import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_loading.dart';
import 'package:private_courses/components/style/size.dart';
import '../../../../components/empty_list.dart';
import '../controller/courses_cubit.dart';
import '../controller/courses_states.dart';
import 'item_course.dart';

class CurrentCourses extends StatelessWidget {
  const CurrentCourses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoursesCubit, CoursesStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = CoursesCubit.get(context);
        return state is CurrentCoursesLoadingState
            ? CustomLoading(load: true)
            : cubit.currentCourses!.isEmpty
                ? Expanded(child: const EmptyList())
                : Expanded(
                    child: ListView.separated(
                        padding: EdgeInsetsDirectional.only(
                          start: width(context) * 0.005,
                          top: height(context) * 0.01,
                          bottom: height(context) * 0.03,
                        ),
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => ItemCourse(
                              courseId: cubit.currentCourses![index].id!,
                              percent: cubit.currentCourses![index].progress!,
                              courseName: cubit.currentCourses![index].name!,
                              img: cubit.currentCourses![index].photo!,
                              countVideo:
                                  cubit.currentCourses![index].countVideos!,
                              isFinished: false,
                            ),
                        separatorBuilder: (context, index) =>
                            SizedBox(height: height(context) * 0.025),
                        itemCount: cubit.currentCourses!.length),
                  );
      },
    );
  }
}
