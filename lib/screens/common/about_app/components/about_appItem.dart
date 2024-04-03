import 'package:flutter/material.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/size.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
class AboutAppItem extends StatelessWidget {
   AboutAppItem({Key? key, this.title, this.desc}) : super(key: key);

  String? title;
  String? desc;

  @override
  Widget build(BuildContext context) {
    return    Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: EdgeInsetsDirectional.only(top: width(context)*0.032,bottom:width(context)*0.032,
            start:width(context)*0.04,end: width(context)*0.02 ),
        decoration: BoxDecoration(
            color: AppColors.lightBlueColor.withOpacity(.05),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(text:title!,fontSize: AppFonts.t5 ,
                color: AppColors.blackColor, fontWeight: FontWeight.bold),
            HtmlWidget(desc!,
              textStyle: TextStyle(color: AppColors.greyBoldColor,
            fontSize: AppFonts.t7),),
          ],
        ),
      ),
    );
  }
}
