import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../generated/locale_keys.g.dart';
import '../controller/saves_cubit.dart';

class CoursesSaveItem extends StatelessWidget {
  final int index;
  final SavesCubit? cubit;
  const CoursesSaveItem({required this.index, required this.cubit});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsetsDirectional.only(bottom: height(context)*0.01),
      child: Container(
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
                    child: Image.network(cubit!.savesModel!.data![index].photo!, width: width(context) * 0.453)),
                Padding(
                  padding: EdgeInsetsDirectional.only(
                    top: height(context) * 0.005,
                    bottom: height(context) * 0.005,
                    start: width(context) * 0.01,
                    end: width(context) * 0.01,
                  ),
                  child: GestureDetector(
                      onTap: () {
                        cubit!.unSave(
                            context: context,
                            id: cubit!.savesModel!.data![index].id!,
                            index: index);
                      },
                      child: Image.asset(AppImages.mark, scale: 2.8)),
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
                          width: width(context) * 0.205,
                          child: CustomText(
                            text: cubit!.savesModel!.data![index].name!,
                            color: AppColors.blackColor,
                            fontSize: AppFonts.t9,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: width(context) * 0.011,
                              vertical: height(context) * 0.001),
                          decoration: BoxDecoration(
                            color: AppColors.redOpcityColor,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Center(
                            child: CustomText(
                                text:
                                    "${cubit!.savesModel!.data![index].price} ${LocaleKeys.Rs.tr()}",
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
                          text: cubit!.savesModel!.data![index].details!,
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
                          text: "${cubit!.savesModel!.data![index].duration}",
                          fontSize: AppFonts.t11,
                          color: AppColors.greyTextColor),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
