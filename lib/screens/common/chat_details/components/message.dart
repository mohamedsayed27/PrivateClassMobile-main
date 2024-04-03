import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:private_courses/components/style/size.dart';
import 'package:bubble/bubble.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/style/colors.dart';

class MessageChat extends StatelessWidget {
  final bool isMe;
  final String msg;
  final String image;
  final Timestamp? time;
  final String msgType;
  const MessageChat(
      {Key? key,
      required this.isMe,
      required this.msg,
      this.time,
      required this.msgType,
      required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime? date = time == null ? DateTime.now() : time!.toDate();
    final format = DateFormat('hh:mm a').format(date);

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width(context) * 0.04, vertical: height(context) * 0.01),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          isMe == true
              ? CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.whiteColor,
                  backgroundImage: NetworkImage(image))
              : const SizedBox.shrink(),
          Column(
            mainAxisAlignment:
                isMe == true ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: isMe == true
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              context.locale.languageCode == "ar"
                  ? Bubble(
                      elevation: 0,
                      margin: BubbleEdges.only(top: height(context) * 0.02),
                      nip: isMe == true
                          ? BubbleNip.rightBottom
                          : BubbleNip.leftBottom,
                      color: isMe == true
                          ? AppColors.chatSender.withOpacity(0.25)
                          : AppColors.chatResiver,
                      child: msgType == "image"
                          ? SizedBox(
                              width: width(context) * 0.6,
                              child: Image.network(msg.toString()))
                          : SizedBox(
                              width: width(context) * 0.6,
                              child: CustomText(
                                  text: msg,
                                  textAlign: isMe == true
                                      ? TextAlign.right
                                      : TextAlign.left,
                                  color: AppColors.blackColor,
                                  fontSize: AppFonts.t8)))
                  : Bubble(
                      elevation: 0,
                      margin: BubbleEdges.only(top: height(context) * 0.02),
                      nip: isMe == true
                          ? BubbleNip.leftBottom
                          : BubbleNip.rightBottom,
                      color: isMe == true
                          ? AppColors.chatSender.withOpacity(0.25)
                          : AppColors.chatResiver,
                      child: msgType == "image"
                          ? SizedBox(
                              width: width(context) * 0.6,
                              child: Image.network(msg.toString()))
                          : SizedBox(
                              width: width(context) * 0.6,
                              child: CustomText(
                                  text: msg,
                                  textAlign: isMe == true
                                      ? TextAlign.right
                                      : TextAlign.left,
                                  color: AppColors.blackColor,
                                  fontSize: AppFonts.t8))),
              CustomText(
                  text: format.toString(),
                  textAlign: isMe == true ? TextAlign.right : TextAlign.left,
                  color: AppColors.dateChat,
                  fontSize: AppFonts.t9),
            ],
          ),
          isMe == true
              ? const SizedBox.shrink()
              : CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.whiteColor,
                  backgroundImage: NetworkImage(image)),
        ],
      ),
    );
  }
}
