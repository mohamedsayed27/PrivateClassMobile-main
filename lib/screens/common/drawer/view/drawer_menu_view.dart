import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/cannot_access_content.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/screens/common/btnNavBar/view/custom_btn_nav_bar_view.dart';
import 'package:private_courses/screens/common/chats/view/chats_view.dart';
import 'package:private_courses/screens/common/drawer/components/custom_zoom_drawer.dart';
import 'package:private_courses/screens/common/drawer/components/drawer_item.dart';
import 'package:private_courses/screens/common/profile/view/profile_screen.dart';
import 'package:private_courses/screens/common/return_policy/view/returnPolicy_screen.dart';
import 'package:private_courses/screens/student/saves/view/saves_view.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/local/cache_helper.dart';
import '../../../student/online_store/view/online_store_view.dart';
import '../../about_app/view/about_app_view.dart';
import '../../privacy_policy/view/privacy_policy_view.dart';
import '../../settings/view/setting_view.dart';
import '../../support_system/view/support_system_view.dart';
import '../controller/drawer_menu_cubit.dart';
import '../controller/drawer_menu_states.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

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
                if (CacheHelper.getData(key: AppCached.token) != null)
                  GestureDetector(
                     onTap: (){
                       navigateTo(context,  ProfileScreen(isDrawer: true,isTeacher: CacheHelper.getData(key: AppCached.role)));
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
                            SizedBox(
                              width: width(context) * 0.65,
                              child: CustomText(
                                  text: CacheHelper.getData(key: AppCached.name),
                                  color: AppColors.whiteColor,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  fontSize: AppFonts.t7),
                            ),
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
                if (CacheHelper.getData(key: AppCached.token) != null)
                  Image.asset(AppImages.divider, width: width(context) * 0.6),
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
                if (CacheHelper.getData(key: AppCached.token) != null)
                ItemDrawer(
                    image: AppImages.chatDrawer,
                    text: LocaleKeys.Chats.tr(),
                    onTap: () {
                      navigateTo(context, const ChatsScreen());
                    }),
                if (CacheHelper.getData(key: AppCached.token) != null)
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
                if (CacheHelper.getData(key: AppCached.token) != null)
                ItemDrawer(
                    image: AppImages.profileCircle,
                    text: LocaleKeys.Profile.tr(),
                    onTap: () {
                      navigateTo(context,  ProfileScreen(isDrawer: true,isTeacher: CacheHelper.getData(key: AppCached.role)));
                      // navigateTo(
                      //     context,
                      //     CustomZoomDrawer(
                      //         mainScreen: OnlineStoreScreen(),
                      //         isTeacher:
                      //             CacheHelper.getData(key: AppCached.role)));
                    }),
                // if (CacheHelper.getData(key: AppCached.token) != null)
                //   ItemDrawer(
                //       image: context.locale.languageCode == "ar"
                //           ?AppImages.shoppingCartDrawer:AppImages.shoppingCartDrawerEn,
                //       text: LocaleKeys.ShoppingCart.tr(),
                //       onTap: () {
                //         CacheHelper.getData(key: AppCached.token) == null
                //             ? showDialog(
                //                 context: context,
                //                 builder: (context) => CannotAccessContent())
                //             :  navigateAndFinish(
                //             context: context,
                //             widget: CustomZoomDrawer(
                //                 mainScreen: CustomBtnNavBarScreen(
                //                     page: 3,
                //                     isTeacher: CacheHelper.getData(key: AppCached.role)),
                //                 isTeacher: CacheHelper.getData(key: AppCached.role)));
                //       }),
                 if (CacheHelper.getData(key: AppCached.token) != null)
                  ItemDrawer(
                      image: AppImages.saves,
                      text: LocaleKeys.Saves.tr(),
                      onTap: () {
                        CacheHelper.getData(key: AppCached.token) == null
                            ? showDialog(
                                context: context,
                                builder: (context) => CannotAccessContent())
                            : navigateTo(context, const SavesScreen());
                      }),
                if (CacheHelper.getData(key: AppCached.token) != null)
                  ItemDrawer(
                      image: AppImages.settingDrawer,
                      text: LocaleKeys.Settings.tr(),
                      onTap: () {
                        CacheHelper.getData(key: AppCached.token) == null
                            ? showDialog(
                                context: context,
                                builder: (context) => CannotAccessContent())
                            : navigateTo(context, const SettingScreen());
                      }),
                ItemDrawer(
                    image: AppImages.infoDrawer,
                    text: LocaleKeys.AboutTheApp.tr(),
                    onTap: () {
                      navigateTo(context, const AboutAppScreen());
                    }),
                if (CacheHelper.getData(key: AppCached.token) != null)
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
                        ? AppImages.returnPolicyDrawer
                        : AppImages.returnPolicyDrawerEn,
                    text: LocaleKeys.ResturnPolicy.tr(),
                    onTap: () {
                      navigateTo(context, ReturnPolicyScreen());
                    }),
                if (CacheHelper.getData(key: AppCached.token) != null)
                  ItemDrawer(
                      image: context.locale.languageCode == "ar"
                          ? AppImages.logOutDrawer
                          : AppImages.logOutDrawerEn,
                      text: LocaleKeys.SignOut.tr(),
                      onTap: () async {
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
