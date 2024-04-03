import 'package:flutter/material.dart';
import 'package:private_courses/components/custom_text.dart';
import 'package:private_courses/components/style/size.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';

class ItemChat extends StatelessWidget {
  final String image;
  final String name;
  final String message;
  final String date;
  final String numOfMessages;
  final Function() onTapChatDetails;

  const ItemChat(
      {Key? key,
      required this.image,
      required this.name,
      required this.message, required this.numOfMessages, required this.date, required this.onTapChatDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapChatDetails,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          numOfMessages == "0" ? CircleAvatar(
              backgroundImage: NetworkImage(image),
              backgroundColor: AppColors.whiteColor,
              radius: 29):Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              CircleAvatar(
                  backgroundImage: NetworkImage(image),
                  backgroundColor: AppColors.whiteColor,
                  radius: 29),
              Transform.translate(
                offset: const Offset(-8, -25),
                child: Container(
                  width: width(context)*0.1,
                  height: height(context)*0.1,
                  decoration: const BoxDecoration(
                      image: DecorationImage(image: AssetImage(AppImages.circleNum))),
                  child: Center(child: Padding(
                    padding:  EdgeInsetsDirectional.only(bottom: height(context)*0.01,start: width(context)*0.002),
                    child: CustomText(text: numOfMessages,color: AppColors.whiteColor,fontSize: AppFonts.t8),
                  )),
                )
              ),
            ],
          ),
          SizedBox(width: width(context) * 0.02),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                  text: name, color: AppColors.navyBlue, fontSize: AppFonts.t7),
              SizedBox(
                  width: width(context) * 0.6,
                  child: CustomText(
                      text: message,
                      color: AppColors.greyBoldColor,
                      fontSize: AppFonts.t10,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis)),
            ],
          ),
          const Spacer(),
          Column(
            children: [
              SizedBox(height: height(context)*0.008),
              CustomText(text: date, color: AppColors.greyTime, fontSize: AppFonts.t10),
              SizedBox(height: height(context)*0.015),
              Image.asset(numOfMessages == "0" ?AppImages.seenActive:AppImages.seen,scale: 3),
            ],
          ),
        ],
      ),
    );
  }
}
