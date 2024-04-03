import 'package:flutter/material.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/size.dart';

class LanguageItem extends StatelessWidget {
  LanguageItem({
    this.label,
    this.onChanged,
    required this.groupValue,
    this.value,
  });
  final String? label;
  void Function(dynamic value)? onChanged;
  dynamic groupValue;
  dynamic value;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.all(width(context) * 0.030),
      decoration: BoxDecoration(
        color: AppColors.lightBlueColor.withOpacity(.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Row(
          children: [
            CustomText(text: label!),
            SizedBox(
              width: width(context) * 0.03,
            ),
            const Spacer(),
            Radio(
                value: value,
                groupValue: groupValue,
                onChanged: onChanged,
                activeColor: AppColors.goldColor),
          ],
        ),
      ),
    );
  }
}
