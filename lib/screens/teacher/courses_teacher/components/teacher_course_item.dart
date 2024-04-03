import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../generated/locale_keys.g.dart';
class TeacherCourseItem extends StatelessWidget {
  final String img;
  final String name;
  final String details;
  final String price;
  final dynamic duration;
   TeacherCourseItem({Key? key, required this.img, required this.name,
  required this.details, required this.duration, required this.price}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
              color: AppColors.textFieldColor,
              offset: Offset(0.5, 0.5),
              spreadRadius: 0.5,
              blurRadius: 0.5),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(img,height: height(context)*0.11,width: width(context)*0.45)),
          SizedBox(height: height(context) * 0.008),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width(context) * 0.015),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height(context) * 0.005),
                Row(
                  children: [
                    SizedBox(
                      width: width(context)*0.2,
                      child: CustomText(text:name,
                          color: AppColors.blackColor,
                          fontSize: AppFonts.t9,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1
                      ),
                    ),
                  Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: width(context) * 0.018,
                          vertical: height(context) * 0.001),
                      decoration: BoxDecoration(
                        color: AppColors.redOpcityColor,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Center(
                        child: CustomText(
                            text: "$price ${LocaleKeys.Rs.tr()}",
                            color: AppColors.whiteColor,
                            fontSize: AppFonts.t11),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height(context) * 0.004),
                SizedBox(
                    width: width(context) * 0.4,
                    child: CustomText(
                        text: details,
                        color: AppColors.greyBoldColor,
                        fontSize: AppFonts.t9,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis)),
                SizedBox(height: height(context) * 0.008),
                Row(
                  children: [
                    Image.asset(AppImages.clock, scale: 2.5),
                    SizedBox(width: width(context) * 0.008),
                    CustomText(
                        text: "$duration",
                        fontSize: AppFonts.t11,
                        color: AppColors.greyTextColor),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
