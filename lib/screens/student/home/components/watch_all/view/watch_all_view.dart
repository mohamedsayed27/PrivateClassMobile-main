import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_appBar.dart';
import 'package:private_courses/components/custom_text.dart';
import 'package:private_courses/generated/locale_keys.g.dart';
import 'package:private_courses/screens/student/home/components/live_item.dart';
import 'package:private_courses/screens/student/home/controller/home_cubit.dart';
import 'package:private_courses/screens/student/home/controller/home_states.dart';

import '../../../../../../components/custom_loading.dart';
import '../../../../../../components/custom_toast.dart';
import '../../../../../../components/style/colors.dart';
import '../../../../../../components/style/images.dart';
import '../../../../../../components/style/size.dart';

class WatchAllView extends StatelessWidget {
  final HomeCubit cubit;
  WatchAllView({Key? key, required this.cubit}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..getLivesAll(context: context),
      child: BlocBuilder<HomeCubit,HomeStates>(
        builder: (context, state) {
          return Scaffold(
              body: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width(context) * 0.04),
                  child: Column(children: [
                    CustomAppBar(
                      isNotify: false,
                      isDrawer: true,
                      textAppBar: LocaleKeys.Live.tr()),
                    state is GetLivesLoading
                      ? Expanded(child: CustomLoading(load: true))
                      : cubit.currentLives.isEmpty
                      ? Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(AppImages.notLives,
                              scale: 3),
                          CustomText(
                              text: LocaleKeys.NotLives.tr(),
                              color: AppColors.navyBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: AppFonts.t5),
                          SizedBox(
                              height: height(context) * 0.05)
                        ],
                      ))
                      : Expanded(child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                              horizontal:
                              width(context) * 0.005,
                              vertical:
                              height(context) * 0.02),
                          shrinkWrap: true,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 11,
                              mainAxisSpacing: 12,
                              childAspectRatio:
                              1.78 / 2.5),
                          itemCount: cubit.currentLives.length,
                          itemBuilder: (context, index) {
                            return LiveItem(
                                onTap: () {
                                  if (cubit.currentLives[index].active == true && cubit.currentLives[index].finish == false) {
                                    cubit.joinMeeting(roomText: cubit.currentLives[index].slug!,context: context);
                                  } else if (cubit.currentLives[index].active == false && cubit.currentLives[index].finish == false) {
                                    showSnackBar(context: context, text: LocaleKeys.NotLives.tr(), success: true);
                                  } else if (cubit.currentLives[index].active == false && cubit.currentLives[index].finish == true) {
                                    showSnackBar(context: context, text: LocaleKeys.BroadcastCompleted.tr(), success: true);
                                  }
                                },
                                liveDate: cubit.currentLives[index].date,
                                teacherName: cubit.currentLives[index].teacherName!,
                                liveTime: cubit.currentLives[index].time,
                                teacherPhoto: cubit.currentLives[index].teacherPhoto!,
                                lectureName: cubit.currentLives[index].liveName!);
                          }))
                  ])));
        },
      ),
    );
  }
}
