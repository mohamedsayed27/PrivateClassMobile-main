import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_appBar.dart';
import 'package:private_courses/components/custom_loading.dart';
import 'package:private_courses/components/custom_text.dart';
import 'package:private_courses/components/style/colors.dart';
import 'package:private_courses/components/style/images.dart';
import 'package:private_courses/generated/locale_keys.g.dart';
import 'package:private_courses/screens/teacher/live/components/live_item.dart';
import 'package:private_courses/screens/teacher/live/controller/teacher_live_cubit.dart';
import 'package:private_courses/screens/teacher/live/controller/teacher_live_states.dart';

import '../../../../components/style/size.dart';

class TeacherLive extends StatelessWidget {
  const TeacherLive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TeacherLiveCubit()..getLives(context: context),
      child: BlocBuilder<TeacherLiveCubit, TeacherLiveStates>(
        builder: (context, state) {
          final cubit = TeacherLiveCubit.get(context);
          return SafeArea(
              child: Scaffold(
                  body: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width(context) * 0.04),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomAppBar(
                                isNotify: false,
                          isDrawer: false,
                                textAppBar: LocaleKeys.Live.tr()),
                            SizedBox(height: height(context) * 0.02),
                            state is GetLivesLoading ? CustomLoading(load: true):
                                cubit.lives.isEmpty?
                                Align(
                                  alignment: AlignmentDirectional.center,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(height: height(context) * 0.21),
                                      Image.asset(AppImages.notLives, scale: 4),
                                      SizedBox(height: height(context) * 0.03),
                                      CustomText(text: LocaleKeys.NotLives.tr(), color: AppColors.navyBlue, fontWeight: FontWeight.bold, fontSize: AppFonts.t5),
                                    ],
                                  ),
                                ):
                            Expanded(
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) => LiveItem(cubit: cubit,index: index),
                                  separatorBuilder: (context, index) => SizedBox(height: height(context) * 0.02),
                                  itemCount: cubit.lives.length)
                            )
                          ]))));
        }
      )
    );
  }
}
