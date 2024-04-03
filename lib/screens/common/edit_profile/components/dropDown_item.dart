import 'package:flutter/material.dart';
import '../../../../../components/style/colors.dart';
import '../../../../../components/style/images.dart';
import '../../../../../components/style/size.dart';


class DropDownItem extends StatelessWidget {
  final String? hint;
  final dynamic dropDownValue ;
  final List<DropdownMenuItem<String>> items ;
  final void Function(String?) onChanged  ;

  DropDownItem({Key? key, this.hint,this.dropDownValue, required this.onChanged, required this.items});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      onChanged: onChanged,
      value:dropDownValue,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.whiteColor,
        contentPadding: EdgeInsets.symmetric(vertical: height(context)*0.02, horizontal: width(context)*0.015, ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(34),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(34),
            borderSide: const BorderSide(color: AppColors.textFieldBackColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(34),
            borderSide: const BorderSide(color: AppColors.navyBlue)

        ),
        enabledBorder:OutlineInputBorder(
            borderRadius: BorderRadius.circular(34),
            borderSide: const BorderSide(color: AppColors.textFieldBackColor)

        ),
        hintText: hint,
        hintStyle: TextStyle(
          color: AppColors.textFieldColor,
          fontSize: AppFonts.t7
        ),
        prefixIcon: Padding(
          padding:  EdgeInsets.symmetric(horizontal: width(context)*0.034),
          child: Image.asset(AppImages.oneNote,width: width(context)*0.02)),
      ),
      icon: Center(child: Image.asset(AppImages.arrowDown)),
      items: items,


    );
  }
}