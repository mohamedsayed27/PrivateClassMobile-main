import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_button.dart';
import 'package:private_courses/components/custom_loading.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/screens/student/home/components/custom_filter/controller/custom_filter_cubit.dart';
import 'package:private_courses/screens/student/home/components/custom_filter/controller/custom_filter_states.dart';
import 'package:private_courses/screens/student/home/components/custom_filter/view/filter_screen.dart';

import 'package:private_courses/shared/local/cache_helper.dart';
import '../../../../../../components/custom_text.dart';
import '../../../../../../components/style/colors.dart';
import '../../../../../../components/style/size.dart';
import '../../../../../../generated/locale_keys.g.dart';
import '../../../../../common/drawer/components/custom_zoom_drawer.dart';
import '../components/secondary_widget.dart';
import '../components/university_widget.dart';

class CustomFilter extends StatelessWidget {
  CustomFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CustomFilterCubit()..getStages(context),
      child: BlocBuilder<CustomFilterCubit, CustomFilterStates>(
          builder: (context, state) {
        final cubit = CustomFilterCubit.get(context);
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsetsDirectional.only(
              top: height(context) * 0.01,
              start: width(context) * 0.05,
              end: width(context) * 0.05,
              bottom: height(context) * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: CustomText(
                      text: LocaleKeys.Categories.tr(),
                      color: AppColors.navyBlue,
                      fontSize: AppFonts.t6)),
              SizedBox(height: height(context) * 0.025),
              CustomText(
                  text: LocaleKeys.ChooseYourStageOfStudy.tr(),
                  color: AppColors.blackColor,
                  fontSize: AppFonts.t6),
              SizedBox(height: height(context) * 0.01),
              state is GetStagesLoadingState
                  ? const CustomLoading(load: false)
                  : cubit.stagesModel?.data == null
                      ? const SizedBox.shrink()
                      : SizedBox(
                          height: height(context) * 0.10,
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: cubit.stagesModel!.data.length,
                            shrinkWrap: true,
                            separatorBuilder: (context, index) =>
                                SizedBox(width: width(context) * 0.025),
                            itemBuilder: (context, index) => Row(
                              children: [
                                Radio(
                                    value: cubit.stagesModel?.data[index].id,
                                    groupValue: cubit.selectedValue,
                                    onChanged: (value) {
                                      cubit.isPicked = false;
                                      cubit.collegesModel?.data = [];
                                      cubit.stageId = value.toString();
                                      cubit.radioCheckVal(value);
                                      cubit.getUniversity(context,
                                          cubit.stagesModel!.data[index].id);
                                    },
                                    activeColor: AppColors.goldColor),
                                GestureDetector(
                                  onTap: () {
                                    cubit.isPicked = false;
                                    cubit.collegesModel?.data = [];
                                    cubit.stageId = cubit
                                        .stagesModel!.data[index].id
                                        .toString();
                                    cubit.radioCheckVal(
                                        cubit.stagesModel!.data[index].id);
                                    cubit.getUniversity(context,
                                        cubit.stagesModel!.data[index].id);
                                  },
                                  child: CustomText(
                                      text: cubit.stagesModel!.data[index].name,
                                      color: AppColors.navyBlue,
                                      fontSize: AppFonts.t8),
                                ),
                              ],
                            ),
                          ),
                        ),
              cubit.selectedValue ==100 ? SizedBox.shrink(): SizedBox(height: height(context) * 0.02),
              state is GetUniversityLoadingState
                  ? const CustomLoading(load: false)
                  : cubit.selectedValue == 1
                      ? UniversityWidget(cubit: cubit)
                      : cubit.selectedValue == 2
                          ? SecondaryWidget(cubit: cubit)
                          : const SizedBox.shrink(),
              !cubit.isPicked ?  SizedBox.shrink():SizedBox(height: height(context) * 0.04),
              !cubit.isPicked
                  ? const SizedBox.shrink()
                  : state is FilterCoursesLoadingState
                      ? const CustomLoading(load: false)
                      : CustomButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            navigateTo(
                                context,
                                CustomZoomDrawer(
                                    mainScreen: FilterScreen(
                                        valueChanged: (v) async {},
                                        universityId: cubit.universityId!,
                                        collegeId: cubit.collegeId!,
                                        stageId: cubit.stageId!),
                                    isTeacher: CacheHelper.getData(
                                        key: AppCached.role)));
                          },
                          text: LocaleKeys.Save.tr(),
                          colored: true),
              !cubit.isPicked ?  SizedBox.shrink():SizedBox(height: height(context) * 0.04)
            ],
          ),
        );
      }),
    );
  }
}
