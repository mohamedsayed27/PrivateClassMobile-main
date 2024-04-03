import 'package:flutter/material.dart';
import 'package:private_courses/components/custom_text.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';

class ItemDrawer extends StatelessWidget {
  final String image ;
  final String text ;
  final Color? color ;
  final Function() onTap ;
  const ItemDrawer({Key? key, required this.image, required this.text, required this.onTap, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding:  EdgeInsetsDirectional.only(top: height(context)*0.0375),
        child: Row(
          children: [
            Image.asset(image,scale: 2.7,color: color),
            SizedBox(width: width(context)*0.02),
            CustomText(text: text,color: AppColors.whiteColor,fontSize: AppFonts.t7)
          ],
        ),
      ),
    );
  }
}
