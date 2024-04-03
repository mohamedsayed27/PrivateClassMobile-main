import 'package:flutter/material.dart';
import '../../../../../components/custom_text.dart';
import '../../../../../components/style/colors.dart';
import '../../../../../components/style/size.dart';
class CustomSelContainer extends StatelessWidget {
   CustomSelContainer({Key? key, required this.img, required this.text, this.onTap, required this.background}) : super(key: key);

  String img;
  String text;
  String background;
  void Function()? onTap;


  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onTap,
      child: Container(
        width: width(context)*0.4,
        height: height(context)*0.215,
        decoration:  BoxDecoration(
            image: DecorationImage(
                image: AssetImage(background),fit: BoxFit.fill
            )
        ),
        child: Column(
          children: [
            SizedBox(height: height(context)*0.02,),
            CustomText(text: text, color: AppColors.whiteColor,
                fontWeight: FontWeight.bold, fontSize: AppFonts.t6),
            Image.asset(img,width: width(context)*0.26,)
          ],
        ),
      ),
    );
  }
}
