import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/style/colors.dart';
import 'package:private_courses/components/style/images.dart';
import 'package:private_courses/components/style/size.dart';
import 'package:private_courses/generated/locale_keys.g.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/my_navigate.dart';
import '../controller/notification_cubit.dart';

class NotificationAppBar extends StatelessWidget {
  final Function() onTapBack;
  final String textAppBar;
  final double? fontSize;
  NotificationAppBar({
    required this.onTapBack,
    required this.textAppBar,
    this.fontSize,
  });
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationCubit, NotificationState>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = NotificationCubit.get(context);
        return Padding(
          padding: EdgeInsetsDirectional.only(
              bottom: height(context) * 0.03, top: height(context) * 0.02),
          child: Row(
            children: [
              GestureDetector(
                onTap: onTapBack,
                child: Image.asset(
                    context.locale.languageCode == "ar"
                        ? AppImages.arrowAr
                        : AppImages.arrowEn,
                    scale: 2.9),
              ),
              const Spacer(),
              SizedBox(
                width: width(context) * 0.692,
                child: CustomText(
                    text: textAppBar,
                    color: AppColors.navyBlue,
                    textAlign: TextAlign.center,
                    fontSize: fontSize ?? AppFonts.t5,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1),
              ),
              cubit.getNotificationModel!.data!.day!.isNotEmpty ||
                  cubit.getNotificationModel!.data!.yesterday!.isNotEmpty
                  ? GestureDetector(
                      onTap: (){
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                            title: Container(
                              decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(10)),
                              width: width(context)*0.8,
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize:MainAxisSize.min,
                                  children: [
                                    SizedBox(height: height(context) * 0.02),
                                    CustomText(
                                        text: LocaleKeys.DeleteAllSure.tr(),
                                        fontWeight: FontWeight.bold,
                                        fontSize: AppFonts.t5,
                                        color: AppColors.navyBlue,
                                        textAlign: TextAlign.center),
                                    SizedBox(height: height(context) * 0.03),
                                    Image.asset(AppImages.deleteAllSure, scale: 3),
                                    SizedBox(height: height(context) * 0.03),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: ()async{
                                              await cubit.deleteAllNotification(context:context);
                                              navigatorPop(context);
                                            },
                                            child: Container(
                                              width: width(context) * 0.88,
                                              height: height(context) * 0.05,
                                              decoration: BoxDecoration(
                                                color: AppColors.greenColor,
                                                borderRadius: const BorderRadius.all(Radius.circular(20)),),
                                              child: Center(
                                                  child: CustomText(
                                                      text: LocaleKeys.Yes.tr(),
                                                      color: AppColors.whiteColor,
                                                      fontWeight: FontWeight.bold,
                                                      textAlign: TextAlign.center,
                                                      fontSize: AppFonts.t4)),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: width(context)*0.02),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: (){navigatorPop(context);},
                                            child: Container(
                                              width: width(context) * 0.88,
                                              height: height(context) * 0.05,
                                              decoration: BoxDecoration(
                                                color: Color(0xffE74845),
                                                borderRadius: const BorderRadius.all(Radius.circular(20)),),
                                              child: Center(
                                                  child: CustomText(
                                                      text: LocaleKeys.No.tr(),
                                                      color: AppColors.whiteColor,
                                                      fontWeight: FontWeight.bold,
                                                      textAlign: TextAlign.center,
                                                      fontSize: AppFonts.t4)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: height(context) * 0.02)
                                  ],
                                ),
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)))
                        ));
                      },
                      child: Image.asset(AppImages.trash),
                    )
                  : SizedBox(width: width(context) * 0.09),
            ],
          ),
        );
      },
    );
  }
}
