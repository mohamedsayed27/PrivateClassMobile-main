
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/my_navigate.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/size.dart';
import '../../../../generated/locale_keys.g.dart';

class CustomBottomSheet extends StatelessWidget {
  final Function() onPressedCamera;
  final Function() onPressedGallery;

  const CustomBottomSheet(
      {required this.onPressedCamera, required this.onPressedGallery});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(5),
      child:SizedBox(
        height: height(context)*0.29,
        child: Column(
          children: [
            SizedBox(height: height(context)*0.015,),
            GestureDetector(
              onTap:onPressedGallery,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical:width(context)*0.03),
                    child:  Center(
                      child: CustomText(
                        text: LocaleKeys.FromGallery.tr(),
                        color: AppColors.mainColor,
                        fontSize: AppFonts.t6,
                      ),
                    ),
                  ),
                  const Divider(thickness: 1.5,),
                ],
              ),
            ),
            SizedBox(height: height(context)*0.01,),
            GestureDetector(
              onTap:onPressedCamera,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical:width(context)*0.03),
                    child:  Center(
                      child: CustomText(
                        text: LocaleKeys.FromCamera.tr(),
                        color: AppColors.mainColor,
                        fontSize: AppFonts.t6,
                      ),
                    ),
                  ),
                  const Divider(thickness: 1.5,),
                ],
              ),
            ),
            SizedBox(height: height(context)*0.01,),
            GestureDetector(
              onTap:(){
                navigatorPop(context);
              },
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsetsDirectional.only(top:width(context)*0.03),
                    child:  Center(
                      child: CustomText(
                        text: LocaleKeys.Cancel.tr(),
                        color: Colors.red,
                        fontSize: AppFonts.t6,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      )


      //     ),
      //     CupertinoActionSheetAction(
      //       onPressed: onPressedCamera,
      //       child: CustomText(
      //         text:'From Camera',
      //         color: AppColors.mainColor,
      //         fontSize: AppFonts.t6,
      //       ),
      //     ),
      //   ],
      //   cancelButton: CupertinoActionSheetAction(
      //     onPressed: () {
      //       navigatorPop(context);
      //     },
      //     child: CustomText(
      //       text:'الغاء',
      //       color:  Colors.red,
      //       fontSize: AppFonts.h2,
      //     ),
      //   ),
      // ),
    );
  }
}