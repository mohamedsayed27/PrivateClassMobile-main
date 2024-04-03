import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../components/custom_text.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../generated/locale_keys.g.dart';
import '../controller/cart_cubit.dart';

class CartItem extends StatelessWidget {
  final String courseImage;
  final String courseName;
  final String courseDetails;
  final String coursePrice;
  final bool isFavorite;
  final GestureTapCallback onTapDelete;
  final Function() onTapFav;
  const CartItem(
      {Key? key,
      required this.courseName,
      required this.courseImage,
      required this.courseDetails,
      required this.coursePrice,
      required this.isFavorite,
      required this.onTapDelete, required this.onTapFav})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        child: Padding(
          padding: EdgeInsets.all(width(context) * 0.022),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(children: [
                    Container(
                      width: width(context) * 0.45,
                      height: height(context) * 0.16,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: NetworkImage(
                                courseImage,
                              ),
                              fit: BoxFit.fill)),
                    ),
                    Positioned(
                        top: width(context) * 0.012,
                        left: width(context) * 0.012,
                        child: GestureDetector(
                          onTap: onTapFav,
                          child: Image.asset(
                              isFavorite == true? AppImages.mark:AppImages.unMark,
                                  width: width(context) * 0.1
                                ),
                        )),
                  ]),
                  Spacer(),
                  GestureDetector(
                    onTap: onTapDelete,
                    child: Image.asset(
                      AppImages.delete,
                      scale: 2.5,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  CustomText(
                    text: courseName,
                    color: AppColors.blackColor,
                    fontSize: AppFonts.t6,
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: width(context) * 0.035,
                        vertical: height(context) * 0.004),
                    decoration: BoxDecoration(
                      color: AppColors.redOpcityColor,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: CustomText(
                          text: "$coursePrice ${LocaleKeys.Rs.tr()}",
                          color: AppColors.whiteColor,
                          fontSize: AppFonts.t9),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topRight,
                child: CustomText(
                    textAlign: TextAlign.right,
                    text: courseDetails,
                    color: AppColors.greyBoldColor,
                    fontSize: AppFonts.t10),
              )
            ],
          ),
        ),
      ),
    );
  }
}
