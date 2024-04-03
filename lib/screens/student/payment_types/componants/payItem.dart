import 'package:flutter/material.dart';
import 'package:private_courses/components/custom_text.dart';
import 'package:private_courses/components/style/colors.dart';
import 'package:private_courses/components/style/size.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/shared/local/cache_helper.dart';

class PaymentItem extends StatelessWidget {
  final Function(int?)? onChanged;
  final String? img;
  final String? title;
  final int val;
  final int value;

  PaymentItem({required this.onChanged , required this.img , required this.title , required this.val , required this.value});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
      CacheHelper.getData(key: AppCached.appLanguage)=="ar"?
      TextDirection.ltr :TextDirection.rtl,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 3,
                  spreadRadius: 3,
                  offset: Offset(0,1)
              )
            ],
            borderRadius: BorderRadius.circular(20)
        ),
        padding: EdgeInsets.all(width(context)*0.01),
        margin: EdgeInsets.symmetric(vertical: width(context)*0.03,horizontal: width(context)*0.02),
        child: RadioListTile(
          value: val,
          groupValue: value,
          onChanged:  onChanged,
          title: Row(
            textDirection:
            CacheHelper.getData(key: AppCached.appLanguage)=="ar"?TextDirection.rtl : TextDirection.ltr,
            children: [
              Image.asset(img!,scale: 2,),
              SizedBox(width: width(context)*0.03,),
              CustomText(
                  text: title!,
              color: AppColors.navyBlue,
                fontWeight: FontWeight.bold,
                fontSize: AppFonts.t5
              ),
              const Spacer(),
            ],
          ),
          activeColor: AppColors.goldFillColor,
        ),
      ),
    )
    ;
  }
}
