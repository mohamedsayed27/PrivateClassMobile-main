import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/screens/common/btnNavBar/view/custom_btn_nav_bar_view.dart';
import 'package:private_courses/screens/common/drawer/components/custom_zoom_drawer.dart';
import 'package:private_courses/screens/student/home/components/custom_filter/controller/custom_filter_states.dart';

import '../../../../../../components/custom_appBar.dart';
import '../../../../../../components/custom_loading.dart';
import '../../../../../../components/empty_list.dart';
import '../../../../../../components/style/size.dart';
import '../../../../../../core/local/app_cached.dart';
import '../../../../../../generated/locale_keys.g.dart';
import '../../../../../../shared/local/cache_helper.dart';
import '../../../../course_details/view/course_details_view.dart';
import '../components/filtered_item.dart';
import '../controller/custom_filter_cubit.dart';

class FilterScreen extends StatelessWidget {
  final String universityId;
  final String stageId;
  final String collegeId;
  final ValueChanged valueChanged;
  const FilterScreen(
      {Key? key,
      required this.universityId,
      required this.stageId,
      required this.valueChanged,
      required this.collegeId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => CustomFilterCubit()
          ..filterCourses(context,
              stageId: stageId,
              universityId: universityId,
              collegeId: collegeId),
        child: BlocBuilder<CustomFilterCubit, CustomFilterStates>(
            builder: (context, state) {
          final cubit = CustomFilterCubit.get(context);
          return SafeArea(
              child: Scaffold(
                  body: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: width(context) * 0.04),
                      child: Column(children: [
                        CustomAppBar(
                          isNotify: false,
                          textAppBar: LocaleKeys.CategoryResult.tr(),
                          onTapBack: () {
                            navigateAndFinish(
                                widget: CustomZoomDrawer(
                                    mainScreen: CustomBtnNavBarScreen(
                                        page: 0,
                                        isTeacher: CacheHelper.getData(
                                            key: AppCached.role)),
                                    isTeacher: CacheHelper.getData(
                                        key: AppCached.role)),
                                context: context);
                          },
                        ),
                        SizedBox(height: height(context) * 0.01),
                        state is FilterCoursesLoadingState
                            ? const CustomLoading(load: true)
                            : cubit.filterCoursesModel!.data.isEmpty
                                ? const Expanded(child: EmptyList())
                                : Expanded(
                                    child: GridView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 11,
                                              mainAxisSpacing: 4,
                                              childAspectRatio: 1.82 / 2.5),
                                      itemCount:
                                          cubit.filterCoursesModel!.data.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            navigateTo(
                                                context,
                                                CustomZoomDrawer(
                                                    mainScreen:
                                                        CourseDetailsScreen(
                                                            fromTeacherProfile:
                                                                false,
                                                            courseId: cubit
                                                                .filterCoursesModel!
                                                                .data[index]
                                                                .id,
                                                            valueChanged: (v) {
                                                              cubit.filterCourses(
                                                                  context,
                                                                  stageId:
                                                                      stageId,
                                                                  universityId:
                                                                      universityId,
                                                                  collegeId:
                                                                      collegeId);
                                                            },
                                                            courseName: cubit
                                                                .filterCoursesModel!
                                                                .data[index]
                                                                .name),
                                                    isTeacher:
                                                        CacheHelper.getData(
                                                            key: AppCached
                                                                .role)));
                                          },
                                          child: Padding(
                                            padding: EdgeInsetsDirectional.only(
                                                bottom: height(context) * 0.01),
                                            child: FilteredItem(
                                              courseName: cubit.filterCoursesModel!.data[index].name,
                                              courseDetails: cubit.filterCoursesModel!.data[index].details,
                                              coursePhoto: cubit.filterCoursesModel!.data[index].photo,
                                              coursePrice: cubit.filterCoursesModel!.data[index].price,
                                              duration: cubit.filterCoursesModel!.data[index].duration,
                                              isFavorite: cubit.filterCoursesModel!.data[index].isFavorite,
                                              isInstallment: cubit.filterCoursesModel!.data[index].isInstallment,
                                              onTap: () async {

                                                await cubit.saveCourse(context: context, id: cubit.filterCoursesModel!.data[index].id, index: index);
                                              },
                                              courseId: cubit.filterCoursesModel!.data[index].id,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                      ]))));
        }));
  }
}
