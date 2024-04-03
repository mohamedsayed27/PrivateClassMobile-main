import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:private_courses/screens/teacher/live/controller/teacher_live_cubit.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../generated/locale_keys.g.dart';

class LiveItem extends StatefulWidget {
  final TeacherLiveCubit cubit;
  final int index;
  const LiveItem({Key? key, required this.cubit, required this.index})
      : super(key: key);

  @override
  State<LiveItem> createState() => _LiveItemState();
}

class _LiveItemState extends State<LiveItem> {
  @override
  void initState() {
    // TODO: implement initState
    // JitsiMeet.addListener(JitsiMeetingListener(
    //     onConferenceWillJoin: widget.cubit.onConferenceWillJoin,
    //     onConferenceJoined: widget.cubit.onConferenceJoined,
    //     onConferenceTerminated: widget.cubit.onConferenceTerminated,
    //     onError: widget.cubit.inError));
    // widget.cubit.text(index: widget.index);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // JitsiMeet.removeAllListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    spreadRadius: 0,
                    blurRadius: 0,
                    offset: Offset(0, 0.2),
                  )
                ]),
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width(context) * 0.04,
                    vertical: width(context) * 0.04),
                child: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: width(context) * 0.5,
                            child: CustomText(
                                text:
                                    widget.cubit.lives[widget.index].liveName!,
                                color: AppColors.navyBlue)),
                        Row(children: [
                          Image.asset(AppImages.live, scale: 4.5),
                          SizedBox(width: width(context) * 0.015),
                          CustomText(text: LocaleKeys.Live.tr())
                        ])
                      ]),
                  SizedBox(height: height(context) * 0.03),
                  CustomText(
                      text: widget.cubit.lives[widget.index].details,
                      color: AppColors.greyTextColor,
                      fontSize: AppFonts.t8),
                  SizedBox(height: height(context) * 0.02),
                  Row(children: [
                    Image.asset(AppImages.dateBirth, scale: 3.7),
                    SizedBox(width: width(context) * 0.01),
                    CustomText(
                        text: widget.cubit.lives[widget.index].date,
                        color: AppColors.navyBlue,
                        fontSize: AppFonts.t9),
                    SizedBox(width: width(context) * 0.07),
                    Image.asset(AppImages.clock, scale: 2),
                    SizedBox(width: width(context) * 0.01),
                    CustomText(
                        text: widget.cubit.lives[widget.index].time,
                        color: AppColors.navyBlue,
                        fontSize: AppFonts.t9)
                  ]),
                  SizedBox(height: height(context) * 0.02),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: width(context) * 0.06),
                    child: CustomButton(
                      onPressed: () async {
                        print("hhhhhhhhhhhhhhhhhhhhhhhh");
                        widget.cubit
                            .onClick(context: context, index: widget.index);
                      },
                      shadow: true,
                      heightt: height(context) * 0.07,
                      text: widget.cubit.text(index: widget.index),
                      fontSize: AppFonts.t8,
                      colored: false,
                      color: AppColors.chatResiver,
                      colorText: AppColors.blackColor,
                      fontWeight: FontWeight.normal,
                    ),
                  )
                ]))));
  }
}
