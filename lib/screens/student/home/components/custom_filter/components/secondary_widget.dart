import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:private_courses/screens/student/home/components/custom_filter/components/custom_dropdown.dart';
import 'package:private_courses/screens/student/home/components/custom_filter/controller/custom_filter_cubit.dart';
import 'package:private_courses/screens/student/home/controller/home_cubit.dart';

import '../../../../../../components/custom_text.dart';
import '../../../../../../components/style/colors.dart';
import '../../../../../../components/style/size.dart';
import '../../../../../../generated/locale_keys.g.dart';

class SecondaryWidget extends StatelessWidget {
  const SecondaryWidget({
    super.key,
    required this.cubit,
  });

  final CustomFilterCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      CustomText(text: LocaleKeys.ChooseYourClass.tr()),
      SizedBox(height: height(context) * 0.018),
      CustomDropDown(
          hintText: LocaleKeys.GradeName.tr(),
          items: cubit.universityModel!.data.isNotEmpty
              ? List.generate(
                  cubit.universityModel!.data.length,
                  (index) => DropdownMenuItem<String>(
                      value: cubit.universityModel!.data[index].id.toString(),
                      child: CustomText(
                          text: cubit.universityModel!.data[index].name,
                          fontSize: AppFonts.t7,
                          color: AppColors.grayColor)))
              : [],
          onChanged: (value) {
            cubit.universityId = value;

            cubit.getColleges(context, value);
            cubit.changeDropDownThree(value);
          },
          dropDownValue: cubit.dropDownValueThree),
      SizedBox(height: height(context) * 0.018),
      CustomText(text: LocaleKeys.ChooseYourClassroom.tr()),
      SizedBox(height: height(context) * 0.018),
      CustomDropDown(
          hintText: LocaleKeys.ChooseYourClass.tr(),
          items: cubit.collegesModel != null &&
                  cubit.collegesModel!.data.isNotEmpty
              ? List.generate(cubit.collegesModel!.data.length, (index) {
                  return DropdownMenuItem<String>(
                      value: cubit.collegesModel!.data[index].id.toString(),
                      child: CustomText(
                          text: cubit.collegesModel!.data[index].name,
                          fontSize: AppFonts.t7,
                          color: AppColors.grayColor));
                })
              : [],
          onChanged: (value) {
            cubit.collegeId = value;
            debugPrint("dropdown value is $cubit.collegeId");
            cubit.changeDropDownFour(value);
            cubit.isPicked = true;
          },
          dropDownValue: cubit.dropDownValueFour),
      SizedBox(height: height(context) * 0.018),
    ]);
  }
}
