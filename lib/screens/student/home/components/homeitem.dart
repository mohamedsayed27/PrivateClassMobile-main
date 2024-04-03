import 'package:flutter/material.dart';
import 'package:private_courses/components/custom_text.dart';
import 'package:private_courses/components/style/size.dart';

class HomeItem extends StatelessWidget {
  final Decoration? decoration;
  final String? img , label;
  final Color? color;
  final Function()? onTap;

  const HomeItem({required this.decoration,required this.img,required this.label,required this.color,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap!,
      child: Container(
        padding: EdgeInsetsDirectional.only(
          top: width(context) * 0.016,
          bottom: width(context) * 0.016,
          start: width(context) * 0.03,
          end: width(context) * 0.08,
        ),
        margin: EdgeInsetsDirectional.only(end: width(context) *0.016),
        decoration: decoration!,
        child: Row(
          children: [
            Image.asset(img!),
            SizedBox(width: width(context) *0.019),
            CustomText(
              text: label!,
              color: color!,
              fontSize: AppFonts.t9,
            ),
          ],
        ),
      ),
    );
  }
}
