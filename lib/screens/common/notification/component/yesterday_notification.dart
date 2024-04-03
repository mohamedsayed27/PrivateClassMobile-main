import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/screens/common/drawer/components/custom_zoom_drawer.dart';
import 'package:private_courses/screens/common/edit_profile/view/edit_profile_view.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import '../../../../components/custom_loading.dart';
import '../controller/notification_cubit.dart';
import 'delete_popup.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/size.dart';

class YesterdayNotification extends StatelessWidget {
  const YesterdayNotification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationCubit, NotificationState>(
      builder: (context, state) {
        final cubit = NotificationCubit.get(context);
        return state is NotificationLoadingState
            ? const CustomLoading(load: true)
            :  ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          cubit.getNotificationModel!.data!.yesterday![index].type == "group"
                              ? cubit.onClick(
                                  id: cubit.getNotificationModel!.data!.yesterday![index].groupId!,
                                  context: context,
                                  slug: cubit.getNotificationModel!.data!.yesterday![index].groupSlug!) :cubit.getNotificationModel!.data!.yesterday![index].type == "add_phone"
                              ? navigateAndReplace(
                              context: context,
                              widget: CustomZoomDrawer(mainScreen: EditProfileScreen(isTeacher: CacheHelper.getData(key: AppCached.role)),
                                  isTeacher: CacheHelper.getData(key: AppCached.role))) : null;;
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: height(context) * 0.02),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: AppColors.textFieldColor,
                                      offset: Offset(0.5, 0.5),
                                      spreadRadius: 0.5,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Row(
                                    children: [
                                      Image.network(
                                          cubit.getNotificationModel!.data!.yesterday![index].icon!,
                                          width: width(context) * 0.2),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5.0),
                                          child: CustomText(
                                              text: cubit.getNotificationModel!.data!.yesterday![index].body!,
                                              color: AppColors.navyBlue,
                                              overflow: TextOverflow.clip,
                                              maxLines: 4),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              context.locale.languageCode == "ar"
                                  ? Positioned(
                                      left: 1,
                                      top: 2,
                                      child: DeletePopUp(
                                        onTap: () async {
                                          await cubit.deleteNotify(context:context, id:cubit.getNotificationModel!.data!.yesterday![index].id!);
                                        },
                                      ),
                                    )
                                  : Positioned(
                                      right: 1,
                                      top: 2,
                                      child: DeletePopUp(
                                        onTap: () async {
                                          await cubit.deleteNotify(context:context, id:cubit.getNotificationModel!.data!.yesterday![index].id!);
                                        },
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount:
                        cubit.getNotificationModel!.data!.yesterday!.length,
                  );
      },
      listener: (context, state) {},
    );
  }
}
