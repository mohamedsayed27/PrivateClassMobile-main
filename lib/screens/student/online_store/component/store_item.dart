import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:private_courses/screens/student/online_store/controller/online_store_cubit.dart';
import 'package:private_courses/screens/student/product_details/controller/product_details_cubit.dart';

import '../../../../components/custom_text.dart';
import '../../../../components/my_navigate.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../core/local/app_cached.dart';
import '../../../../generated/locale_keys.g.dart';

import '../../../../shared/local/cache_helper.dart';
import '../../../common/drawer/components/custom_zoom_drawer.dart';
import '../../product_details/view/product_details_view.dart';

class StoreItem extends StatelessWidget {
  final OnlineStoreCubit cubit;
  final int index;

  const StoreItem({required this.cubit, required this.index});
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
                  child: Image.network(cubit.catStage[index].photo!,
                    width: double.infinity,
                    height: height(context)*0.121)),
              if(CacheHelper.getData(key: AppCached.token)!=null)
              Padding(
                padding: EdgeInsetsDirectional.only(
                  top: height(context) * 0.005,
                  bottom: height(context) * 0.005,
                  start: width(context) * 0.01,
                  end: width(context) * 0.01,
                ),
                child: GestureDetector(
                    onTap: () {
                      cubit.saveCourse(
                          context: context,
                          id: cubit.catStage[index].id!,
                          index: index);
                    },
                    child: cubit.catStage[index].isFavorite == true
                        ? Image.asset(AppImages.mark, scale: 2.8)
                        : Image.asset(AppImages.unMark, scale: 2.8)),
              )
            ],
          ),
          SizedBox(height: height(context) * 0.008),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width(context) * 0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height(context) * 0.005),
                SizedBox(
                  width: width(context) * 0.42,
                  child: Row(
                    children: [
                      SizedBox(
                        width: width(context) * 0.205,
                        child: CustomText(
                          text: cubit.catStage[index].name!,
                          color: AppColors.blackColor,
                          fontSize: AppFonts.t9,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: width(context) * 0.015,
                            vertical: height(context) * 0.001),
                        decoration: BoxDecoration(
                          color: AppColors.redOpcityColor,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Center(
                          child: CustomText(
                              text:
                                  "${cubit.catStage[index].price} ${LocaleKeys.Rs.tr()}",
                              color: AppColors.whiteColor,
                              fontSize: AppFonts.t11),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height(context) * 0.006),
                SizedBox(
                    width: width(context) * 0.4,
                    child: CustomText(
                        text: cubit.catStage[index].details!,
                        color: AppColors.greyBoldColor,
                        fontSize: AppFonts.t9,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis)),
                SizedBox(height: height(context) * 0.008),
                Row(
                  children: [
                    Image.asset(AppImages.clock, scale: 2.5),
                    SizedBox(width: width(context) * 0.008),
                    SizedBox(
                        width: width(context) * 0.25,
                        child: CustomText(
                            text: cubit.catStage[index].duration.toString(),
                            fontSize: AppFonts.t11,
                            color: AppColors.greyTextColor,
                            overflow: TextOverflow.ellipsis)),
                    const Spacer(),
                    if(CacheHelper.getData(key: AppCached.token) != null)
                    GestureDetector(
                      onTap: () {
                        cubit.addToCart(context: context, id: cubit.catStage[index].id);
                      },
                      child: SizedBox(
                        height: height(context) * 0.06,
                        child: Image.asset(
                          AppImages.cart,
                          width: width(context) * 0.11,
                          alignment: AlignmentDirectional.bottomCenter,
                        ),
                      ),
                    )
                  ],
                ),
                cubit.catStage[index].isInstallment==true?
                Image.asset(AppImages.tabbyIcon,width: width(context)*0.13,) : SizedBox.shrink()

              ],
            ),
          ),
        ],
      ),
    );
  }
}
