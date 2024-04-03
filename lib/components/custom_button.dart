import 'package:flutter/material.dart';
import 'custom_text.dart';
import 'style/colors.dart';
import 'style/images.dart';
import 'style/size.dart';

class CustomButton extends StatelessWidget {
 final String? text;
  final Function()? onPressed;
 final bool? colored;
 final double? fontSize;
 final double? heightt;
  final Color? color;
  final Color? colorText;
  final bool? shadow;
 final FontWeight? fontWeight;
  CustomButton(
      {Key? key,
      this.text,
      this.color,
      required this.colored,
      this.colorText,
      this.fontSize,
      required this.onPressed,
      this.fontWeight, this.shadow=false, this.heightt})
      : super(key: key);



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width(context) * 0.88,
        height: heightt??height(context) * 0.078,
        decoration: colored == true
            ? const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                image: DecorationImage(
                    image: AssetImage(AppImages.backBtn), fit: BoxFit.fill),
              )
            : BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                boxShadow:shadow==true? [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    spreadRadius: 0.5,
                    blurRadius: 0.5,
                    offset: Offset(0, 1),
                  )
                ]:[],
                border: Border.all(color: color ?? AppColors.mainColor)),
        child: Center(
            child: CustomText(
                text: text!,
                color: colored == true
                    ? AppColors.whiteColor
                    : colorText ?? AppColors.mainColor,
                fontWeight: fontWeight ?? FontWeight.bold,
                textAlign: TextAlign.center,
                fontSize: fontSize ?? AppFonts.t4)),
      ),
    );
  }
}
