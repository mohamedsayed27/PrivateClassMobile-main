import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_loading.dart';
import 'package:private_courses/components/empty_list.dart';
import 'package:private_courses/components/my_navigate.dart';

import '../../../../components/custom_appBar.dart';

import '../../../../components/style/size.dart';
import '../../../../components/text_form_field_serch.dart';

import '../../../../generated/locale_keys.g.dart';

import '../components/college_view.dart';
import '../components/search_college_view.dart';
import '../controller/all_secondary_department_cubit.dart';
import '../controller/all_secondary_department_states.dart';

class AllSecondaryDepartmentScreen extends StatelessWidget {
  final String textAppBar;
  final int stageId;
  final ValueChanged<String?> valueChanged;

  const AllSecondaryDepartmentScreen(
      {required this.textAppBar,
      required this.stageId,
      required this.valueChanged});
  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    return GestureDetector(
      onTap: () {
        currentFocus.unfocus();
      },
      child: BlocProvider(
        create: (context) => AllSecondaryDepartmentCubit()
          ..getAllUniversityDepartment(context, stageId),
        child: BlocBuilder<AllSecondaryDepartmentCubit,
            AllSecondaryDepartmentStates>(builder: (context, state) {
          final cubit = AllSecondaryDepartmentCubit.get(context);
          return WillPopScope(
            onWillPop: () async {
              valueChanged.call('');
              return true;
            },
            child: Scaffold(
              body: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: width(context) * 0.04),
                child: Column(
                  children: [
                    CustomAppBar(
                      isNotify: false,
                      textAppBar: textAppBar,
                      fontSize: AppFonts.t6,
                      onTapBack: () {
                        valueChanged.call('');
                        navigatorPop(context);
                      },
                    ),
                    SizedBox(height: height(context) * 0.01),
                    CustomTextFormFieldSearch(
                      ctrl: cubit.searchCtrl,
                      hintText: LocaleKeys.SearchOfCourse.tr(),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          cubit.searchCollege(
                              context: context,
                              courseName: value,
                              collegeId: stageId);
                          cubit.isSearch = true;
                        } else {
                          cubit.isSearch = false;
                          cubit.getAllUniversityDepartment(context, stageId);
                        }
                      },
                    ),
                    SizedBox(height: height(context) * 0.035),
                    state is SearchCourseLoadingState
                        ? const CustomLoading(load: false)
                        : state is GetAllSecondaryDepartmentLoadingState
                            ? const CustomLoading(load: true)
                            : cubit.isSearch == true
                                ? cubit.searchModel!.data!.isEmpty
                                    ? const Expanded(child: EmptyList())
                                    : SearchCollegeView(
                                        cubit: cubit,
                                        collegeId: stageId,
                                        collegeName: cubit.searchCtrl.text)
                                : CollegeView(
                                    cubit: cubit,
                                    stageId: stageId,
                                  )
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
