import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/style/colors.dart';
import 'package:private_courses/components/style/size.dart';

import '../../../../components/custom_text.dart';
import '../../../../generated/locale_keys.g.dart';
import '../controller/course_details_cubit.dart';
import '../controller/course_details_states.dart';

class AboutCourse extends StatelessWidget {
  const AboutCourse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CourseDetailsCubit, CourseDetailsStates>(
        builder: (context, state) {
          final cubit = CourseDetailsCubit.get(context);
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: height(context) * 0.02),
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                CustomText(
                    text: cubit.courseDetailsModel!.data!.details!,
                    color: AppColors.greyBoldColor,
                    fontSize: AppFonts.t9,
                    textAlign: TextAlign.start),
              ],
            ),
          );
        },
        listener: (context, state) {});
  }
}
