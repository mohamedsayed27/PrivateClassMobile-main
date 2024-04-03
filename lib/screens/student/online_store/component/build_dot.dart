import 'package:flutter/material.dart';

import '../../../../components/style/colors.dart';
import '../../../../components/style/size.dart';
Widget  buildDot(int index, cubit, context){
  return Container(
    width: cubit!.numSlider==index? width(context)*0.15:width(context)*0.0223,
    height: width(context)*0.022,
    margin: const EdgeInsets.all(3),
    decoration: BoxDecoration(
      color: cubit!.numSlider==index? AppColors.goldColor:AppColors.dotGrayColor,
      borderRadius: BorderRadius.circular(20),

    ),
  );
}