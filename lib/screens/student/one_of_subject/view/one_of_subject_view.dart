import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_loading.dart';
import 'package:private_courses/components/my_navigate.dart';

import '../../../../components/custom_appBar.dart';
import '../../../../components/empty_list.dart';
import '../../../../components/style/size.dart';
import '../../../../components/text_form_field_serch.dart';
import '../../../../generated/locale_keys.g.dart';
import '../components/search_subject_view.dart';
import '../components/subject_view.dart';
import '../controller/one_of_subject_cubit.dart';
import '../controller/one_of_subject_states.dart';

class OneOfSubjectScreen extends StatelessWidget {
  final String textAppBar;
  final int subjectId;
  final ValueChanged<String?> valueChanged;
  const OneOfSubjectScreen(
      {required this.textAppBar,
      required this.subjectId,
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
            OneOfSubjectCubit()..getOneOfSubjectCourses(context, subjectId),
        child: BlocBuilder<OneOfSubjectCubit, OneOfSubjectStates>(
            builder: (context, state) {
          final cubit = OneOfSubjectCubit.get(context);
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
                              id: subjectId);
                          cubit.isSearch = true;
                        } else {
                          cubit.isSearch = false;
                          cubit.getOneOfSubjectCourses(context, subjectId);
                        }
                      },
                    ),
                    SizedBox(height: height(context) * 0.035),
                    state is SearchCourseLoadingState
                        ? const CustomLoading(load: false)
                        : state is GetOneOfSubjectLoadingState
                            ? CustomLoading(load: true)
                            : cubit.oneOfSubjectModel!.data.isEmpty
                                ? const Expanded(child: EmptyList())
                                : cubit.isSearch == true
                                    ? cubit.searchModel?.data!.isEmpty == true
                                        ? const Expanded(child: EmptyList())
                                        : SearchSubjectView(
                                            cubit: cubit,
                                            subjId: subjectId,
                                          )
                                    : SubjectView(
                                        cubit: cubit,
                                        subjectId: subjectId,
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
