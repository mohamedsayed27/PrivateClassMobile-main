import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/screens/student/courses/components/current_courses.dart';
import 'package:private_courses/screens/student/courses/components/finished_courses.dart';
import '../../../../components/custom_appBar.dart';
import '../../../../components/custom_loading.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../generated/locale_keys.g.dart';
import '../controller/courses_cubit.dart';
import '../controller/courses_states.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CoursesCubit()..getCurrentCourses(context),
      child:
          BlocBuilder<CoursesCubit, CoursesStates>(builder: (context, state) {
        final cubit = CoursesCubit.get(context);
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: width(context) * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(isNotify: true),
                CustomText(
                    text: LocaleKeys.ParticipatingCourses.tr(),
                    color: AppColors.navyBlue,
                    fontSize: AppFonts.t6),
                SizedBox(height: height(context) * 0.03),
                Row(
                  children: List.generate(
                    cubit.names.length,
                    (index) => Expanded(
                      child: GestureDetector(
                        onTap: () {
                          cubit.changeBottom(index);
                        },
                        child: Container(
                          height: cubit.currentIndex == index
                              ? height(context) * 0.052
                              : height(context) * 0.05,
                          padding: EdgeInsets.symmetric(
                              horizontal: width(context) * 0.01,
                              vertical: height(context) * 0.007),
                          margin: EdgeInsetsDirectional.only(
                              end: width(context) * 0.02),
                          decoration: cubit.currentIndex == index
                              ? BoxDecoration(
                                  image: const DecorationImage(
                                      image: AssetImage(AppImages.backSaves),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(20),
                                )
                              : BoxDecoration(
                                  border: Border.all(color: AppColors.navyBlue),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                          child: Center(
                            child: CustomText(
                              text: cubit.names[index],
                              color: cubit.currentIndex == index
                                  ? AppColors.whiteColor
                                  : AppColors.navyBlue,
                              fontSize: AppFonts.t8,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height(context) * 0.03),
                cubit.currentIndex == 0
                    ? state is CurrentCoursesLoadingState
                        ? const CustomLoading(load: true)
                        : const CurrentCourses()
                    : state is PreviousCoursesLoadingState
                        ? const CustomLoading(load: true)
                        : const FinishedCourses(),
              ],
            ),
          ),
        );
      }),
    );
  }
}
