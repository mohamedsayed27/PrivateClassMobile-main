import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:private_courses/components/style/images.dart';
import 'package:private_courses/components/style/size.dart';

class ProfileItem extends StatelessWidget {
  final String img;
  final String label;

  const ProfileItem({super.key, required this.img,required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade200
        ),
          padding: EdgeInsets.all(width(context)*0.02),
          child: Image.asset(img,scale: 2.5),
        ),
        SizedBox(width: width(context)*0.03,),
        Text(label),
        const Spacer(),
        Image.asset(context.locale.languageCode=="ar"?AppImages.yellowArrowBack:AppImages.yellowArrowBackEn,scale: 3.2),

      ],
    );
  }
}
