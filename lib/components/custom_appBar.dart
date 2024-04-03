import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:private_courses/components/cannot_access_content.dart';
import 'package:private_courses/components/style/colors.dart';
import 'package:private_courses/components/style/images.dart';
import 'package:private_courses/components/style/size.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/screens/common/btnNavBar/controller/custom_btn_nav_bar_cubit.dart';
import 'package:private_courses/screens/common/btnNavBar/controller/custom_btn_nav_bar_states.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import '../screens/common/notification/view/notification_view.dart';
import 'custom_text.dart';
import 'my_navigate.dart';

class CustomAppBar extends StatefulWidget {
  final Function()? onTapBack;
  final Function()? onTapDrawer;
  final String? textAppBar;
  final bool isNotify;
  final bool isDrawer;
  final double? fontSize;

   CustomAppBar({this.onTapBack, this.textAppBar, required this.isNotify, this.onTapDrawer, this.fontSize, this.isDrawer=true});


  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    return BlocConsumer<CustomBtnNavBarCubit,CustomBtnNavBarStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = CustomBtnNavBarCubit.get(context);
        return Padding(
      padding: EdgeInsetsDirectional.only(
          bottom: height(context) * 0.03, top: height(context) * 0.02),
      child: Row(
        children: [
          CacheHelper.getData(key: AppCached.token) != null?
          widget.isNotify == false
              ? GestureDetector(
                  onTap: widget.onTapBack ??
                          () {
                        navigatorPop(context);
                      },
                  child: Image.asset(
                      context.locale.languageCode == "ar"
                          ? AppImages.arrowAr
                          : AppImages.arrowEn,
                      scale: 2.9))
                  : CacheHelper.getData(key: AppCached.notifyCount) == 0 ?GestureDetector(
                  onTap:  (){
                    CacheHelper.getData(key: AppCached.token) == null
                        ? showDialog(
                        context: context,
                        builder: (context) => CannotAccessContent())
                        :navigateTo(context,  NotificationView(
                        valueChanged: (v){
                          cubit.getProfile(context: context);
                        })
                    );
                  },
                  child: Image.asset(AppImages.notification, scale: 2.9)):
                  Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  GestureDetector(
                      onTap:  (){
                        CacheHelper.getData(key: AppCached.token) == null
                            ? showDialog(
                            context: context,
                            builder: (context) => CannotAccessContent())
                            :navigateTo(context,  NotificationView(valueChanged: (v){
                          cubit.getProfile(context: context);
                        }));
                      },
                      child: Image.asset(AppImages.notification, scale: 2.9)),
                  Container(
                    height: height(context)*0.022,
                    width: width(context)*0.04,
                    decoration: BoxDecoration(color: AppColors.navyBlue,borderRadius: BorderRadius.circular(20)),
                    child: Center(child: CustomText(text: CacheHelper.getData(key: AppCached.notifyCount).toString(),color: AppColors.whiteColor,fontSize: AppFonts.t11)),
                  )
                ],
              ) : widget.isNotify == false
              ? GestureDetector(
              onTap: widget.onTapBack ??
                      () {
                    navigatorPop(context);
                  },
              child: Image.asset(
                  context.locale.languageCode == "ar"
                      ? AppImages.arrowAr
                      : AppImages.arrowEn,
                  scale: 2.9)) : GestureDetector(
              onTap:  (){
                CacheHelper.getData(key: AppCached.token) == null
                    ? showDialog(
                    context: context,
                    builder: (context) => CannotAccessContent())
                    :navigateTo(context,  NotificationView(
                    valueChanged: (v){
                      cubit.getProfile(context: context);
                    })
                );
              },
              child: Image.asset(AppImages.notification, scale: 2.9)),
              const Spacer(),
              widget.isNotify == false ||widget.isNotify == true
                  ? widget.textAppBar != null ?SizedBox(
                width: width(context)*0.692,
                child: CustomText(
                    text: widget.textAppBar!,
                    color: AppColors.navyBlue,
                    textAlign: TextAlign.center,
                    fontSize: widget.fontSize ?? AppFonts.t5,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1),
              ):SizedBox.shrink():const SizedBox.shrink(),
              widget.isNotify == false?const Spacer():const SizedBox.shrink(),
              widget.isDrawer ? GestureDetector(
                  onTap: () {
                    currentFocus.unfocus();
                    if (ZoomDrawer.of(context)!.isOpen()) {
                      ZoomDrawer.of(context)!.close();
                    } else {
                      ZoomDrawer.of(context)!.open();
                    }
                  },
                  child: Image.asset(
                      context.locale.languageCode == "ar"
                          ? AppImages.menuAr
                          : AppImages.menuEn,
                      scale: 2.95)): SizedBox(width: width(context)*0.1),

            ],
          ),
        );
      },
    );
  }
}
