import 'package:flutter/material.dart';
import 'package:private_courses/components/custom_text.dart';
import 'package:private_courses/components/style/images.dart';
import 'package:private_courses/components/style/size.dart';

import '../../../../components/style/colors.dart';

class SettingsItem extends StatelessWidget {
  final String img;
  final String label;
  final Function() onTap;
  final Widget endImage;
  final double? scale ;



  SettingsItem({required this.img,required this.label,required this.endImage, this.scale, required this.onTap });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsetsDirectional.all(width(context)*0.015),
        decoration: BoxDecoration(
          color: AppColors.lightBlueColor.withOpacity(.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Image.asset(img,scale: scale??2.9),
            SizedBox(width: width(context)*0.03),
            CustomText(text:label),
            const Spacer(),
            endImage,
          ],
        ),
      ),
    );
  }
}
