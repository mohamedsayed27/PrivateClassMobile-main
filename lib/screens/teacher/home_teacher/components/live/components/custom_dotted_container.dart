import 'package:flutter/material.dart';
import '../../../../../../components/custom_text.dart';
import '../../../../../../components/style/colors.dart';
import '../../../../../../components/style/size.dart';

class CustomDottedContainer extends StatelessWidget {
  CustomDottedContainer(
      {Key? key,
      required this.backImg,
      required this.text,
      required this.img,
      this.onTap})
      : super(key: key);
  void Function()? onTap;
  String img;
  String text;
  String backImg;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(backImg), fit: BoxFit.fill),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: width(context) * 0.02, vertical: width(context) * 0.03),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: "https://unsplash.com/s/photos/live-video",
              color: AppColors.navyBlue,
              textAlign: TextAlign.center,
              fontSize: AppFonts.t8,
            ),
            SizedBox(width: width(context) * 0.07),
            Row(
              children: [
                CustomText(
                  text: text,
                  color: AppColors.navyBlue,
                  textAlign: TextAlign.center,
                  fontSize: AppFonts.t9,
                ),
                Image.asset(
                  img,
                  scale: 1.2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
