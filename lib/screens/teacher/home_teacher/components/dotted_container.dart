import 'package:flutter/material.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/size.dart';
class DottedContainer extends StatelessWidget {
   DottedContainer({Key? key,required this.backImg, required this.text, required this.img, this.onTap}) : super(key: key);
  void Function()? onTap;
  String img;
  String text;
  String backImg;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap ,
      child: Container(
        width: width(context)*0.88,
        height: height(context)*0.16,
       decoration: BoxDecoration(
         image:DecorationImage(image:AssetImage(backImg), fit: BoxFit.fill ),
       ),
       // padding: EdgeInsets.symmetric(horizontal: width(context)*0.3,vertical:width(context)*0.08 ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(img, width: width(context)*0.1,),
            SizedBox(height: height(context)*0.01,),
            CustomText(text: text, color: AppColors.navyBlue,textAlign: TextAlign.center),

          ],
        ),
      ),
    );
  }
}
