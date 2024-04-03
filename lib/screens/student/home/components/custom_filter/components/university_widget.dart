import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:private_courses/screens/student/home/components/custom_filter/components/custom_dropdown.dart';

import '../../../../../../components/custom_text.dart';
import '../../../../../../components/style/colors.dart';
import '../../../../../../components/style/size.dart';
import '../../../../../../generated/locale_keys.g.dart';
import '../../../controller/home_cubit.dart';
import '../controller/custom_filter_cubit.dart';

class UniversityWidget extends StatelessWidget {
  const UniversityWidget({
    super.key,
    required this.cubit,
  });

  final CustomFilterCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      CustomText(text: LocaleKeys.ChooseYourUniversity.tr()),
      SizedBox(height: height(context) * 0.018),
      CustomDropDown(
          hintText: LocaleKeys.UniversityName.tr(),
          items: cubit.universityModel!.data.isNotEmpty
              ? List.generate(cubit.universityModel!.data.length, (index) {
                  return DropdownMenuItem<String>(
                      value: cubit.universityModel!.data[index].id.toString(),
                      child: CustomText(
                          text: cubit.universityModel!.data[index].name,
                          fontSize: AppFonts.t7,
                          color: AppColors.grayColor));
                })
              : [],
          onChanged: (value) {
            cubit.universityId = value;
            cubit.getColleges(context, value);
            cubit.changeDropDownOne(value);
          },
          dropDownValue: cubit.dropDownValueOne),
      SizedBox(height: height(context) * 0.018),
      CustomText(text: LocaleKeys.SelectCollege.tr()),
      SizedBox(height: height(context) * 0.018),
      CustomDropDown(
          hintText: LocaleKeys.CollegeName.tr(),
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
            cubit.changeDropDownTwo(value);
            cubit.isPicked = true;
          },
          dropDownValue: cubit.dropDownValueTwo),
      SizedBox(height: height(context) * 0.018),
    ]);
  }
}
