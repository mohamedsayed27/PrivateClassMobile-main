import 'package:flutter/material.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import '../../../../../../components/custom_text.dart';
import '../../../../../../components/style/colors.dart';
import '../../../../../../components/style/images.dart';
import '../../../../../../components/style/size.dart';
import '../../../../../../generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class FilteredItem extends StatelessWidget {
  final String courseName;
  final String courseDetails;
  final String coursePhoto;
  final String coursePrice;
  final dynamic duration;
  final bool isFavorite;
  final bool isInstallment;
  final int courseId;
  final GestureTapCallback onTap;
  const FilteredItem({
    required this.courseName,
    required this.courseDetails,
    required this.coursePhoto,
    required this.coursePrice,
    required this.duration,
    required this.courseId,
    required this.isFavorite,
    required this.isInstallment,
    required this.onTap,
  });

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    coursePhoto,
                      width: double.infinity,
                      fit: BoxFit.fill,
                      height: height(context)*0.121
                  )),
              if(CacheHelper.getData(key: AppCached.token)!=null )
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: height(context) * 0.005,
                  horizontal: width(context) * 0.01),
                child: GestureDetector(
                    onTap: onTap,
                    child: Image.asset(
                      isFavorite ? AppImages.mark : AppImages.unMark,
                      scale: 2.8,
                    )),
              )
            ],
          ),
          SizedBox(height: height(context) * 0.008),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width(context) * 0.015),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height(context) * 0.005),
                SizedBox(
                  width: width(context) * 0.51,
                  child: Row(
                    children: [
                      SizedBox(
                        width: width(context) * 0.2,
                        child: CustomText(
                            text: courseName,
                            color: AppColors.blackColor,
                            fontSize: AppFonts.t8,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1)
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: width(context) * 0.012,
                            vertical: height(context) * 0.001),
                        decoration: BoxDecoration(
                          color: AppColors.redOpcityColor,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Center(
                          child: CustomText(
                              text:
                                  "${coursePrice.toString()} ${LocaleKeys.Rs.tr()}",
                              color: AppColors.whiteColor,
                              fontSize: AppFonts.t11),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height(context) * 0.004),
                SizedBox(
                    width: width(context) * 0.4,
                    child: CustomText(
                        text: courseDetails,
                        color: AppColors.greyBoldColor,
                        fontSize: AppFonts.t9,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis)),
                SizedBox(height: height(context) * 0.008),
                Row(
                  children: [
                    Image.asset(AppImages.clock, scale: 2.5),
                    SizedBox(width: width(context) * 0.008),
                    CustomText(
                        text: duration.toString(),
                        fontSize: AppFonts.t11,
                        color: AppColors.greyTextColor),
                  ],
                ),
                SizedBox(height: height(context)*0.01),
                isInstallment==true?
                Image.asset(AppImages.tabbyIcon,width: width(context)*0.13) : SizedBox.shrink()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
