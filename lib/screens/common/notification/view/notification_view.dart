import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/components/style/size.dart';
import 'package:private_courses/generated/locale_keys.g.dart';

import '../../../../components/custom_loading.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/style/colors.dart';
import '../component/no_notification.dart';
import '../component/notification_appbar.dart';
import '../component/today_notification.dart';
import '../component/yesterday_notification.dart';
import '../controller/notification_cubit.dart';

class NotificationView extends StatelessWidget {
  final ValueChanged<String?> valueChanged;
  const NotificationView({ required this.valueChanged});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationCubit>(
      create: (context) => NotificationCubit()..getAllNotifications(context: context, isLoading: true),
      child: BlocConsumer<NotificationCubit, NotificationState>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = NotificationCubit.get(context);
          return SafeArea(
            child: WillPopScope(
              onWillPop: ()async{
                valueChanged.call('');
                return true ;
              },
              child: Scaffold(
                body: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: width(context) * 0.04),
                  child: state is NotificationLoadingState
                      ? const CustomLoading(load: true)
                      :Column(
                    children: [
                      NotificationAppBar(
                          textAppBar: LocaleKeys.Notify.tr(),
                          onTapBack: (){
                          valueChanged.call('');
                          navigatorPop(context);
                      }),
                       cubit.getNotificationModel!.data!.day!.isEmpty && cubit.getNotificationModel!.data!.yesterday!.isEmpty?Expanded(child: NoNotification()):Expanded(
                              child: SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    cubit.getNotificationModel!.data!.day!.isEmpty ? SizedBox.shrink():CustomText(
                                        text: LocaleKeys.Today.tr(),
                                        color: AppColors.navyBlue,
                                        fontSize: AppFonts.t5),
                                    cubit.getNotificationModel!.data!.day!.isEmpty
                                        ? SizedBox.shrink()
                                        : const TodayNotification(),
                                    SizedBox(
                                      height: height(context) * 0.04),
                                    cubit.getNotificationModel!.data!.yesterday!.isEmpty
                                        ? SizedBox.shrink():CustomText(
                                        text: LocaleKeys.Yesterday.tr(),
                                        color: AppColors.navyBlue,
                                        fontSize: AppFonts.t5),
                                    cubit.getNotificationModel!.data!.yesterday!.isEmpty
                                        ? SizedBox.shrink()
                                        : Padding(
                                          padding: EdgeInsets.only(bottom: height(context) * 0.028),
                                          child: const YesterdayNotification(),
                                        ),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
