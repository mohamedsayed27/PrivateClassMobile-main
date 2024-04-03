import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'custom_text.dart';
import 'style/colors.dart';
import 'style/images.dart';
import 'style/size.dart';

class AuthBody extends StatelessWidget {
  final Widget child;
  final Widget? widgetSizedBox;
  final String? title;
  final String? subTitle;
  final bool withBackArrow;
  final EdgeInsetsGeometry? margin ;
  final String? img;
  final double? heigh;
  AuthBody(
      {Key? key,
      required this.child,
      this.heigh,
      required this.withBackArrow,
      this.title,
      this.subTitle,
      this.img, this.margin,  this.widgetSizedBox})
      : super(key: key);



  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(img ?? AppImages.splashBG), fit: BoxFit.fill),
      ),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width(context) * 0.05,
                  vertical: height(context) * 0.02),
              child: withBackArrow
                  ? GestureDetector(
                      onTap: () {
                        currentFocus.unfocus();
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                          context.locale.languageCode == "ar"
                              ? AppImages.leftArrow
                              : AppImages.leftArrowEn,
                          width: width(context) * 0.09))
                  : SizedBox(height: height(context) * 0.1)),
          SizedBox(height: height(context) * 0.04),
          Center(
              child: Image.asset(
            AppImages.logo,
            width: width(context) * 0.3,
          )),
          SizedBox(
            height: heigh ?? height(context) * 0.06028,
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  width: width(context),
                   // height: height(context) * 0.645,
                  margin: margin,
                  decoration: const BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(40))),
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: title == null ? 0 : height(context) * 0.025),
                      child: Column(children: [
                        subTitle != null ? CustomText(
                            text: title!,
                            fontWeight: FontWeight.bold,
                            fontSize: AppFonts.t5,
                            color: AppColors.navyBlue): SizedBox.shrink(),
                        widgetSizedBox != null ? widgetSizedBox!:SizedBox.shrink(),
                        subTitle != null ?CustomText(
                            text: subTitle!,
                            fontSize: AppFonts.t6,
                            textAlign: TextAlign.center,
                            color: AppColors.goldColor) : SizedBox.shrink(),
                        child
                      ]))))
        ]),
      ),
    );
  }
}
