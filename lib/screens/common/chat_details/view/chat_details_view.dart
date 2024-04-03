import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_text.dart';
import 'package:private_courses/components/custom_textfield.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../profile/components/bottom_sheet.dart';
import '../components/chats.dart';
import '../controller/chat_details_cubit.dart';
import '../controller/chat_details_states.dart';

class ChatDetailsScreen extends StatelessWidget {
  final String receiverId;
  final ValueChanged valueChanged;
  final String receiverName;
  final String receiverImage;
  const ChatDetailsScreen(
      {super.key,
      required this.receiverId,
      required this.receiverName,
      required this.receiverImage,
      required this.valueChanged
      });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatDetailsCubit()..getMessage(receiverId: receiverId),
      child: BlocBuilder<ChatDetailsCubit, ChatDetailsStates>(
          builder: (context, state) {
        final cubit = ChatDetailsCubit.get(context);
        return SafeArea(
          child: WillPopScope(
            onWillPop: () async {
              valueChanged.call("");
              Navigator.of(context).pop();
              return false;
            },
            child: Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: width(context),
                      height: height(context) * 0.17,
                      padding: EdgeInsets.symmetric(
                          horizontal: width(context) * 0.04,
                          vertical: height(context) * 0.02),
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(AppImages.chatBG),
                              fit: BoxFit.fill)),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  valueChanged.call("");
                                  Navigator.of(context).pop();
                                },
                                child: context.locale.languageCode == "ar"
                                    ? Image.asset(AppImages.leftArrow,
                                        scale: 3.5)
                                    : Image.asset(AppImages.leftArrowEn,
                                        scale: 2.7)),
                            SizedBox(height: height(context) * 0.04),
                            Center(
                              child: CustomText(
                                  text: receiverName,
                                  color: AppColors.whiteColor,
                                  fontSize: AppFonts.t6),
                            )
                          ])),
                  Expanded(child: Chats(receiverId: receiverId)),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width(context) * 0.04,
                        vertical: height(context) * 0.01),
                    child: SizedBox(
                        height: height(context) * 0.07,
                        child: CustomTextFormField(
                          type: TextInputType.text,
                          ctrl: cubit.messageController,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: height(context) * 0.022,
                              horizontal: width(context) * 0.035),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(25),
                                              topRight: Radius.circular(25)),
                                        ),
                                        context: context,
                                        builder: (BuildContext cont) {
                                          return CustomBottomSheet(
                                            onPressedCamera: () {
                                              cubit.pickFromCamera(
                                                  context: context,
                                                  receiverId: receiverId,
                                                  receiverImage: receiverImage,
                                                  senderImage: CacheHelper.getData(key: AppCached.image));
                                              navigatorPop(context);
                                            },
                                            onPressedGallery: () {
                                              cubit.pickFromGallery(
                                                  context: context,
                                                  receiverId: receiverId,
                                                  receiverImage: receiverImage,
                                                  senderImage:
                                                      CacheHelper.getData(
                                                          key:
                                                              AppCached.image));
                                              navigatorPop(context);
                                            },
                                          );
                                        });
                                  },
                                  child: Image.asset(
                                      context.locale.languageCode == "ar"
                                          ? AppImages.paperclip
                                          : AppImages.paperclipEn,
                                      scale: 2.5)),
                              SizedBox(width: width(context) * 0.01),
                              GestureDetector(
                                  onTap: () async {
                                    if (cubit.messageController.text.isNotEmpty) {
                                      await cubit.sendMsg(receiverId: receiverId,
                                          receiverImage: receiverImage,
                                          senderImage: CacheHelper.getData(key: AppCached.image),
                                          senderId: CacheHelper.getData(key: AppCached.userId).toString(),
                                          dateTime: Timestamp.now(),
                                          context: context,
                                          type: "text");
                                    }
                                  },
                                  child: context.locale.languageCode == "ar"
                                      ? Image.asset(AppImages.sendMsg, scale: 3)
                                      : Image.asset(AppImages.sendMsgEn,
                                          scale: 2.3)),
                              SizedBox(width: width(context) * 0.01),
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
