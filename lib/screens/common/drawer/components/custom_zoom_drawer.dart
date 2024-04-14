import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:private_courses/components/style/size.dart';
import '../../../../components/style/colors.dart';
import '../view/drawer_menu_teacher_view.dart';
import '../view/drawer_menu_view.dart';

class CustomZoomDrawer extends StatelessWidget {
  final Widget mainScreen;
  final zoomDrawerController = ZoomDrawerController();
  final String isTeacher;

  CustomZoomDrawer(
      {Key? key, required this.mainScreen, required this.isTeacher})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ZoomDrawer(
          menuScreen: isTeacher == "teacher" ? const DrawerMenuTeacher() : const DrawerMenu(),
          mainScreen: mainScreen,
          borderRadius: width(context) * 0.07,
          showShadow: true,
          angle: 0.0,
          style: DrawerStyle.style1,
          slideWidth: context.locale.languageCode == 'ar' ? width(context) * 0.66 : width(context) * 0.74,
          shadowLayer2Color: AppColors.whiteColor.withOpacity(0.3),
          shadowLayer1Color: Colors.transparent,
          openCurve: Curves.fastOutSlowIn,
          closeCurve: Curves.linear,
          mainScreenTapClose: true,
          controller: zoomDrawerController,
          isRtl: context.locale.languageCode == 'ar' ? true : false,
        ),
      ),
    );
  }
}
