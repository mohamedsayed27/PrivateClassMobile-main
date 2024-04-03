import 'package:flutter/material.dart';

import '../../../../components/custom_text.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';

class CustomBottomIcon extends StatelessWidget {
  final String text;
  final String image;
  final Function() onPressed;
  final bool colored;
  final double scale;
  final double? fontSize ;
  const CustomBottomIcon({Key? key, required this.text, required this.image, required this.onPressed, required this.colored, required this.scale, this.fontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height(context) * 0.05,
        decoration: colored == true
            ? const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          image: DecorationImage(
            image: AssetImage(AppImages.backBtn),
            fit: BoxFit.fill,
          ),
        )
            :BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            border: Border.all(color:AppColors.mainColor)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
                text: text,
                color: colored == true ? AppColors.whiteColor: AppColors.navyBlue, fontSize:fontSize??AppFonts.t9),
            SizedBox(width: width(context)*0.015),
            Image.asset(image,scale: scale)
          ],
        ),
      ),
    );
  }
}
