import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:private_courses/components/custom_text.dart';
import 'package:private_courses/components/style/colors.dart';
import 'package:private_courses/components/style/images.dart';
import 'package:private_courses/components/style/size.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/generated/locale_keys.g.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import '../../../../components/custom_appBar.dart';
import '../../../../components/my_navigate.dart';
import '../../../common/drawer/components/custom_zoom_drawer.dart';
import '../../../common/edit_password/view/edit_pass_view.dart';
import '../../../common/edit_profile/view/edit_profile_view.dart';
import '../components/profileItem.dart';

class ProfileScreen extends StatelessWidget {
  final String isTeacher;
  final bool isDrawer;

  const ProfileScreen({super.key, required this.isTeacher, required this.isDrawer});

  @override
  Widget build(BuildContext context) {
    return isDrawer == true ? SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: width(context) * 0.04),
          child: Column(children: [
            CustomAppBar(isNotify: false,textAppBar: LocaleKeys.Profile.tr(),isDrawer: false),
            Expanded(
                child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.whiteColor,
                            backgroundImage: NetworkImage(
                                CacheHelper.getData(key: AppCached.image))),
                        SizedBox(height: height(context) * 0.03),
                        CustomText(
                            text: CacheHelper.getData(key: AppCached.name),
                            color: AppColors.mainColor,
                            fontWeight: FontWeight.bold),
                        SizedBox(height: height(context) * 0.01),
                        CustomText(
                            text: CacheHelper.getData(key: AppCached.email),
                            color: Colors.grey.shade400),
                        SizedBox(height: height(context) * 0.025),
                        const Divider(),
                        SizedBox(height: height(context) * 0.025),
                        InkWell(
                            onTap: () {
                              navigateTo(
                                  context,
                                  CustomZoomDrawer(
                                      mainScreen: EditProfileScreen(
                                          isTeacher: CacheHelper.getData(
                                              key: AppCached.role)),
                                      isTeacher: CacheHelper.getData(
                                          key: AppCached.role)));
                            },
                            child: ProfileItem(
                              label: LocaleKeys.EditProfile.tr(),
                              img: AppImages.editProfile,
                            )),
                        SizedBox(
                          height: height(context) * 0.04,
                        ),
                        if(CacheHelper.getData(key: AppCached.loginType)==null)
                          InkWell(
                              onTap: () {
                                navigateTo(
                                    context,
                                    CustomZoomDrawer(
                                        mainScreen: const EditPasswordScreen(),
                                        isTeacher: CacheHelper.getData(
                                            key: AppCached.role)));
                              },
                              child: ProfileItem(
                                  label: LocaleKeys.EditPass.tr(),
                                  img: AppImages.editPass)),

                        //  SizedBox(height: height(context)*0.04),
                        //  isTeacher == "teacher"?const SizedBox.shrink():
                        // GestureDetector(
                        // onTap: (){
                        //    navigateTo(context, CustomZoomDrawer(mainScreen: SavesScreen(), isTeacher: CacheHelper.getData(key: AppCached.role)));
                        // },
                        // child: ProfileItem(label: LocaleKeys.Saves.tr(),img: AppImages.saves))
                      ],
                    ))),
          ]),
        ),
      ),
    ):Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width(context) * 0.04),
        child: Column(children: [
          CustomAppBar(isNotify: true),
          Expanded(
              child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.whiteColor,
                          backgroundImage: NetworkImage(
                              CacheHelper.getData(key: AppCached.image))),
                      SizedBox(height: height(context) * 0.03),
                      CustomText(
                          text: CacheHelper.getData(key: AppCached.name),
                          color: AppColors.mainColor,
                          fontWeight: FontWeight.bold),
                      SizedBox(height: height(context) * 0.01),
                      CustomText(
                          text: CacheHelper.getData(key: AppCached.email),
                          color: Colors.grey.shade400),
                      SizedBox(height: height(context) * 0.025),
                      const Divider(),
                      SizedBox(height: height(context) * 0.025),
                      InkWell(
                          onTap: () {
                            navigateTo(
                                context,
                                CustomZoomDrawer(
                                    mainScreen: EditProfileScreen(
                                        isTeacher: CacheHelper.getData(
                                            key: AppCached.role)),
                                    isTeacher: CacheHelper.getData(
                                        key: AppCached.role)));
                          },
                          child: ProfileItem(
                            label: LocaleKeys.EditProfile.tr(),
                            img: AppImages.editProfile,
                          )),
                      SizedBox(
                        height: height(context) * 0.04,
                      ),
                      if(CacheHelper.getData(key: AppCached.loginType)==null)
                        InkWell(
                          onTap: () {
                            navigateTo(
                                context,
                                CustomZoomDrawer(
                                    mainScreen: const EditPasswordScreen(),
                                    isTeacher: CacheHelper.getData(
                                        key: AppCached.role)));
                          },
                          child: ProfileItem(
                              label: LocaleKeys.EditPass.tr(),
                              img: AppImages.editPass)),

                      //  SizedBox(height: height(context)*0.04),
                      //  isTeacher == "teacher"?const SizedBox.shrink():
                      // GestureDetector(
                      // onTap: (){
                      //    navigateTo(context, CustomZoomDrawer(mainScreen: SavesScreen(), isTeacher: CacheHelper.getData(key: AppCached.role)));
                      // },
                      // child: ProfileItem(label: LocaleKeys.Saves.tr(),img: AppImages.saves))
                    ],
                  ))),
        ]),
      ),
    );
  }
}
