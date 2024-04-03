import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_loading.dart';

import '../../../../components/custom_appBar.dart';

import '../../../../components/empty_list.dart';
import '../../../../generated/locale_keys.g.dart';

import '../components/search_university_view.dart';
import '../components/university_details_view.dart';
import '../controller/all_university_cubit.dart';
import '../controller/all_university_states.dart';
import 'package:private_courses/components/style/size.dart';
import '../../../../components/text_form_field_serch.dart';

class AllUniversityScreen extends StatelessWidget {
  AllUniversityScreen({required this.universityId, required this.valueChanged});
  final int universityId;
  final ValueChanged valueChanged;

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    return GestureDetector(
      onTap: () {
        currentFocus.unfocus();
      },
      child: BlocProvider(
        create: (context) => AllUniversityCubit()..getAllUniversity(context, universityId),
        child: BlocBuilder<AllUniversityCubit, AllUniversityStates>(
            builder: (context, state) {
          final cubit = AllUniversityCubit.get(context);
          return WillPopScope(
            onWillPop: () async {
              valueChanged.call;
              return true;
            },
            child: Scaffold(
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: width(context) * 0.04),
                child: Column(
                  children: [
                    CustomAppBar(
                      isNotify: false,
                      textAppBar: LocaleKeys.AllUniversities.tr(),
                      onTapBack: () {
                        valueChanged.call('');
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(height: height(context) * 0.01),
                    CustomTextFormFieldSearch(
                      ctrl: cubit.searchCtrl,
                      hintText: LocaleKeys.SearchOfUniversity.tr(),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          cubit.searchCourse(
                              context: context,
                              universityName: value,
                              id: universityId);
                          cubit.isSearch = true;
                        } else {
                          cubit.isSearch = false;
                          cubit.getAllUniversity(context, universityId);
                        }
                      },
                    ),
                    state is SearchCourseLoadingState
                        ? const CustomLoading(load: false)
                        : SizedBox(height: height(context) * 0.015),
                    state is GetAllUniversityLoadingState
                        ? CustomLoading(load: true)
                        : cubit.isSearch == true
                            ? cubit.searchModel!.data!.isEmpty
                                ? Expanded(child: const EmptyList())
                                : SearchUniversityView(
                                    cubit: cubit,
                                    universityId: universityId,
                                    universityName: cubit.searchCtrl.text)
                            : UniversityDetailsView(
                                cubit: cubit,
                                universityId: universityId,
                              ),
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
