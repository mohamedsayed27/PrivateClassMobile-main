import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_loading.dart';
import 'package:private_courses/components/empty_list.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/screens/student/all_secondary_department/controller/all_secondary_department_cubit.dart';
import 'package:private_courses/screens/student/all_university_department/model/all_university_department_model.dart';
import 'package:private_courses/screens/student/course_details/view/course_details_view.dart';
import '../../../../components/custom_appBar.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../components/text_form_field_serch.dart';
import '../../../../generated/locale_keys.g.dart';

import '../components/colleges_view.dart';
import '../components/search_college_dept_view.dart';
import '../controller/all_university_department_cubit.dart';
import '../controller/all_university_department_states.dart';

class AllUniversityDepartmentScreen extends StatelessWidget {
  final String textAppBar;
  final int universityId;
  final ValueChanged<String?> valueChanged;
  const AllUniversityDepartmentScreen(
      {super.key,
      required this.textAppBar,
      required this.universityId,
      required this.valueChanged});

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    return GestureDetector(
      onTap: () {
        currentFocus.unfocus();
      },
      child: BlocProvider(
        create: (context) => AllUniversityDepartmentCubit()
          ..getAllUniversityDepartment(context, universityId),
        child: BlocBuilder<AllUniversityDepartmentCubit,
            AllUniversityDepartmentStates>(builder: (context, state) {
          final cubit = AllUniversityDepartmentCubit.get(context);
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
                      onTapBack: () {
                        valueChanged.call('');
                        navigatorPop(context);
                      },
                    ),
                    SizedBox(height: height(context) * 0.01),
                    CustomTextFormFieldSearch(
                      ctrl: cubit.searchCtrl,
                      hintText: LocaleKeys.SearchOfCollege.tr(),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          cubit.searchCollege(
                              context: context,
                              courseName: value,
                              collegeId: universityId);
                          cubit.isSearch = true;
                        } else {
                          cubit.isSearch = false;
                          cubit.getAllUniversityDepartment(
                              context, universityId);
                        }
                      },
                    ),
                    state is GetAllUniversityDepartmentLoadingState
                        ? const CustomLoading(load: true)
                        : SizedBox(height: height(context) * 0.035),
                    state is SearchCourseLoadingState
                        ? CustomLoading(load: false)
                        : cubit.allUniversityDepartmentModel == null
                            ? const SizedBox.shrink()
                            : cubit.isSearch == true
                                ? cubit.searchModel!.data!.isEmpty
                                    ? Expanded(child: const EmptyList())
                                    : SearchCollegeDepartmentView(
                                        cubit: cubit,
                                        collegeName: cubit.searchCtrl.text,
                                        universityId: universityId)
                                : CollegesView(cubit: cubit, universityId: universityId)
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
