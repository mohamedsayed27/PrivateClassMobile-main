import 'package:flutter/material.dart';
import '../../../../../../components/style/colors.dart';
import '../../../../../../components/style/images.dart';
import '../../../../../../components/style/size.dart';

class CustomDropDown extends StatelessWidget {
  final String hintText;
  final double? radius;
  final dynamic dropDownValue;
  final Color? colorBorder;
  final List<DropdownMenuItem<String>> items;
  final void Function(String?) onChanged;
  const CustomDropDown(
      {Key? key,
      required this.hintText,
      this.dropDownValue,
      required this.onChanged,
      required this.items, this.colorBorder, this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.whiteColor,
        contentPadding: EdgeInsets.symmetric(
            horizontal: width(context) * 0.04,
            vertical: height(context) * 0.015),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius??20),
            borderSide: BorderSide(
                color: colorBorder??AppColors.greyWhite, width: width(context) * 0.003)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius??20),
            borderSide: BorderSide(
                color: colorBorder??AppColors.greyWhite, width: width(context) * 0.003)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius??20),
            borderSide: BorderSide(
                color: colorBorder??AppColors.greyWhite, width: width(context) * 0.003)),
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppColors.grayColor,
          fontSize: AppFonts.t7,
        ),
      ),
      icon: Center(child: Image.asset(AppImages.arrowDown)),
      items: items,
      onChanged: onChanged,
      value: dropDownValue,
    );
  }
}
