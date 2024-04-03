import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/size.dart';
import '../../../../generated/locale_keys.g.dart';
class ContactUsItem extends StatelessWidget {
  final String? img;
  final String? title;
  final double? scale;
  final String? subTitle;
  final Function()? onTap;
  ContactUsItem({Key? key, this.title, this.subTitle, this.img,required this.onTap, this.scale});


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsetsDirectional.all(width(context)*0.038,),
          decoration: BoxDecoration(
              color: AppColors.lightBlueColor.withOpacity(.05),
              borderRadius: BorderRadius.circular(20)
          ),
          child: Row(
            children: [
              Image.asset(img!, scale: scale??3),
              SizedBox(width: width(context)*0.017),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: title!, color: AppColors.blackColor),
                  SizedBox(
                    height:height(context)*0.03,
                    width: width(context)*0.62,
                    child: CustomText(text:subTitle!, color: AppColors.goldColor,
                        fontSize: AppFonts.t9
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
