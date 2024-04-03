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
import '../components/course_view.dart';
import '../components/search_view.dart';
import '../controller/one_of_faculty_cubit.dart';
import '../controller/one_of_faculty_states.dart';

class OneOfFacultyScreen extends StatelessWidget {
  final String textAppBar;
  final int facultyId;
  final ValueChanged<String?> valueChanged;

  const OneOfFacultyScreen(
      {required this.textAppBar,
      required this.facultyId,
      required this.valueChanged});

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    return GestureDetector(
      onTap: () {
        currentFocus.unfocus();
      },
      child: BlocProvider(
        create: (context) =>
            OneOfFacultyCubit()..getOneOfFacultyCourses(context, facultyId),
        child: BlocBuilder<OneOfFacultyCubit, OneOfFacultyStates>(
            builder: (context, state) {
          final cubit = OneOfFacultyCubit.get(context);
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
                      hintText: LocaleKeys.SearchOfCourse.tr(),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          cubit.searchCourse(
                              context: context,
                              courseName: value,
                              id: facultyId);
                          cubit.isSearch = true;
                        } else {
                          cubit.isSearch = false;
                          cubit.getOneOfFacultyCourses(context, facultyId);
                        }
                      },
                    ),
                    SizedBox(height: height(context) * 0.035),
                    state is SearchCourseLoadingState
                        ? CustomLoading(load: false)
                        : state is GetOneOfFacultyLoadingState
                            ? const CustomLoading(load: true)
                            : cubit.oneOfFacultyModel!.data.isEmpty
                                ? const Expanded(child: EmptyList())
                                : cubit.isSearch == true
                                    ? cubit.searchModel!.data == null
                                        ? Expanded(child: EmptyList())
                                        : SearchView(
                                            cubit: cubit,
                                            facultyId: facultyId,
                                            courseName: cubit.searchCtrl.text,
                                          )
                                    : CourseView(
                                        cubit: cubit, facultyId: facultyId)
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
