import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/screens/common/btnNavBar/view/custom_btn_nav_bar_view.dart';
import 'package:private_courses/screens/common/chats/view/chats_view.dart';
import 'package:private_courses/screens/common/drawer/components/custom_zoom_drawer.dart';
import 'package:private_courses/screens/common/drawer/components/drawer_item.dart';
import 'package:private_courses/screens/teacher/live/view/teacher_live_view.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../teacher/groups/view/groups_view.dart';
import '../../about_app/view/about_app_view.dart';
import '../../privacy_policy/view/privacy_policy_view.dart';
import '../../settings/view/setting_view.dart';
import '../../support_system/view/support_system_view.dart';
import '../controller/drawer_menu_cubit.dart';
import '../controller/drawer_menu_states.dart';

class DrawerMenuTeacher extends StatelessWidget {
  const DrawerMenuTeacher({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DrawerMenuCubit(),
      child: BlocBuilder<DrawerMenuCubit, DrawerMenuStates>(
          builder: (context, state) {
        final cubit = DrawerMenuCubit.get(context);
        return SafeArea(
            child: Container(
          height: height(context),
          padding: EdgeInsets.symmetric(horizontal: width(context) * 0.06),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AppImages.drawerBG), fit: BoxFit.cover)),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height(context) * 0.1),
                GestureDetector(
                  onTap: (){
                    navigateAndFinish(
                        context: context,
                        widget: CustomZoomDrawer(
                            mainScreen: CustomBtnNavBarScreen(
                                page: 3,
                                isTeacher: CacheHelper.getData(key: AppCached.role)),
                            isTeacher: CacheHelper.getData(key: AppCached.role)));
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            CacheHelper.getData(key: AppCached.image)),
                        backgroundColor: AppColors.whiteColor,
                        radius: 25,
                      ),
                      SizedBox(width: width(context) * 0.02),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                              text: CacheHelper.getData(key: AppCached.name),
                              color: AppColors.whiteColor,
                              fontSize: AppFonts.t7),
                          CustomText(
                              text: CacheHelper.getData(key: AppCached.email),
                              color: AppColors.whiteColor,
                              fontSize: AppFonts.t9),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height(context) * 0.02),
                Image.asset(AppImages.divider, width: width(context) * 0.6),
                SizedBox(height: height(context) * 0.02),
                ItemDrawer(
                    image: AppImages.main,
                    text: LocaleKeys.BackToHome.tr(),
                    onTap: () {
                      navigateAndFinish(
                          context: context,
                          widget: CustomZoomDrawer(
                              mainScreen: CustomBtnNavBarScreen(
                                  page: 0,
                                  isTeacher: CacheHelper.getData(key: AppCached.role)),
                              isTeacher: CacheHelper.getData(key: AppCached.role)));
                    }),
                ItemDrawer(
                    image: AppImages.chatDrawer,
                    text: LocaleKeys.Chats.tr(),
                    onTap: () {
                      navigateTo(context, const ChatsScreen());
                    }),
                ItemDrawer(
                      image: AppImages.myCourses,
                      text: LocaleKeys.MyCourses.tr(),
                      onTap: () {
                        navigateAndFinish(
                            context: context,
                            widget: CustomZoomDrawer(
                                mainScreen: CustomBtnNavBarScreen(
                                    page: 1,
                                    isTeacher: CacheHelper.getData(key: AppCached.role)),
                                isTeacher: CacheHelper.getData(key: AppCached.role)));
                      }),
                ItemDrawer(
                    image: AppImages.groups,
                    text: LocaleKeys.Groups.tr(),
                    onTap: () {
                      navigateTo(context, const GroupsScreen());
                    }),
                ItemDrawer(
                    image: AppImages.lives,
                    text: LocaleKeys.Live.tr(),
                    onTap: () {
                      navigateTo(context, const TeacherLive());
                    }),
                ItemDrawer(
                    image: AppImages.settingDrawer,
                    text: LocaleKeys.Settings.tr(),
                    onTap: () {
                      navigateTo(context, const SettingScreen());
                    }),
                ItemDrawer(
                    image: AppImages.infoDrawer,
                    text: LocaleKeys.AboutTheApp.tr(),
                    onTap: () {
                      navigateTo(context, const AboutAppScreen());
                    }),
                ItemDrawer(
                    image: context.locale.languageCode == "ar"
                        ? AppImages.headsetDrawer
                        : AppImages.headsetDrawerEn,
                    text: LocaleKeys.TechnicalSupport.tr(),
                    onTap: () {
                      navigateTo(context, const SupportSystemScreen());
                    }),
                ItemDrawer(
                    image: AppImages.shieldLockDrawer,
                    text: LocaleKeys.PrivacyPolicy.tr(),
                    onTap: () {
                      navigateTo(context, const PrivacyPolicyScreen());
                    }),
                ItemDrawer(
                    image: context.locale.languageCode == "ar"
                        ? AppImages.logOutDrawer
                        : AppImages.logOutDrawerEn,
                    text: LocaleKeys.SignOut.tr(),
                    onTap: () {
                      CacheHelper.getData(key: AppCached.loginType) == "gmail"
                          ? cubit.signOutGmail(context)
                          : cubit.logOut(context: context);
                    }),
                SizedBox(height: height(context) * 0.035)
              ],
            ),
          ),
        ));
      }),
    );
  }
}
