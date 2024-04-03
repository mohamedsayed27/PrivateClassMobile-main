import 'package:flutter/material.dart';

import '../../../../components/custom_text.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/size.dart';
class CustomCartRow extends StatelessWidget {
   CustomCartRow({Key? key, required this.text2, required this.text1, this.col, this.fontWeight}) : super(key: key);
  String text1;
  String text2;
  Color? col;
  FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:  EdgeInsets.all(width(context)*0.012),
      child: Row(children: [
        CustomText(text: text1,color:col ?? AppColors.grayColor, fontSize: AppFonts.t7, fontWeight: fontWeight),
        const Spacer(),
        CustomText(text: text2,color:col ?? AppColors.grayColor,fontSize: AppFonts.t7, fontWeight: fontWeight),
      ],),
    );
  }
}
