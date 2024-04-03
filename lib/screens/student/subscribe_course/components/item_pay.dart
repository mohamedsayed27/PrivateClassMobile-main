import 'package:flutter/material.dart';

import '../../../../components/custom_text.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/size.dart';

class PayItem extends StatelessWidget {
  final String label;
  final Function(dynamic value) onChanged;
  final Function() onTap;
  final dynamic groupValue;
  final String image ;
  final dynamic value;
  const PayItem({required this.label, required this.onChanged, required this.groupValue, this.value, required this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding:  EdgeInsetsDirectional.only(bottom: height(context)*0.025),
        child: Container(
          padding: EdgeInsetsDirectional.all(width(context) * 0.030),
          decoration: BoxDecoration(
            color: AppColors.lightBlueColor.withOpacity(.05),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Row(
              children: [
                Image.asset(image,scale: 3),
                SizedBox(width: width(context)*0.02),
                CustomText(text: label),
                SizedBox(
                  width: width(context) * 0.03
                ),
                const Spacer(),
                Radio(
                    value: value,
                    groupValue: groupValue,
                    onChanged: onChanged,
                    activeColor: AppColors.goldColor)
              ],
            ),
          ),
        ),
      ),
    );
  }
}