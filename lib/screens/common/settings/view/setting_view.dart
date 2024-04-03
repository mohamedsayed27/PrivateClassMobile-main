import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_button.dart';
import 'package:private_courses/components/custom_text.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/components/style/colors.dart';
import 'package:private_courses/components/style/images.dart';
import 'package:private_courses/screens/student/lecture_details_videos/components/not_pay.dart';
import '../../language_change/view/change_language.dart';
import '../components/settingsItem.dart';
import '../../../../components/custom_appBar.dart';
import '../../../../components/style/size.dart';
import '../../../../generated/locale_keys.g.dart';
import '../controller/settings_cubit.dart';
import '../controller/settings_states.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(),
      child: BlocBuilder<SettingsCubit, SettingsStates>(
        builder: (context, state) {
          final cubit = SettingsCubit.get(context);
          return SafeArea(
              child: Scaffold(
                  body: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width(context) * 0.04),
                      child: Column(children: [
                         CustomAppBar(
                            isNotify: false,
                            textAppBar: LocaleKeys.Settings.tr(),
                            isDrawer: false),
                          Expanded(child: SingleChildScrollView(physics: const BouncingScrollPhysics(),child: Column(children: [ SizedBox(height: height(context) * 0.05),
                          Image.asset(AppImages.setting, scale: 4.4),
                          SizedBox(height: height(context) * 0.05),
                          SettingsItem(
                            onTap: (){
                              navigateTo(context, const ChangeLanguage());
                            },
                            img: AppImages.langIcon,
                            endImage: GestureDetector(
                              child:context.locale.languageCode == "ar"? Image.asset(AppImages.yellowArrowBack, scale: 3.5):Image.asset(AppImages.yellowArrowBackEn, scale: 2.6),
                              onTap: () {
                                navigateTo(context, const ChangeLanguage());
                              },
                            ),
                            label: LocaleKeys.Lang.tr(),
                          ),
                          SizedBox(height: height(context) * 0.018),
                          SettingsItem(
                            onTap: ()async{
                              await cubit.activateNotify(context);
                              cubit.toggleNotify();
                            },
                            img: AppImages.notifyIcon,
                            endImage: GestureDetector(
                                onTap: () async {
                                  await cubit.activateNotify(context);
                                  cubit.toggleNotify();
                                },
                                child: cubit.notifyOn
                                    ? Image.asset(AppImages.toggleOn,
                                    scale: 1.85)
                                    : Image.asset(AppImages.toggleOff,
                                    scale: 1.85)),
                            label: LocaleKeys.Notify.tr(),
                          ),
                          SizedBox(height: height(context) * 0.018),
                          SettingsItem(
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
                                                text: LocaleKeys.deleteAccTitle.tr(),
                                                fontWeight: FontWeight.bold,
                                                fontSize: AppFonts.t5,
                                                color: AppColors.navyBlue,
                                                textAlign: TextAlign.center),
                                            SizedBox(height: height(context) * 0.03),
                                            Image.asset(AppImages.deleteAccDialog, scale: 3),
                                            SizedBox(height: height(context) * 0.03),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: (){
                                                      cubit.deleteAcc(context);
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
                                ),
                              );
                            },
                            img: AppImages.deleteAcc,
                            scale: 2.3,
                            endImage: GestureDetector(
                              child:context.locale.languageCode == "ar"? Image.asset(AppImages.yellowArrowBack, scale: 3.5):Image.asset(AppImages.yellowArrowBackEn, scale: 2.6),
                              onTap: () {
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
                                                  text: LocaleKeys.deleteAccTitle.tr(),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: AppFonts.t5,
                                                  color: AppColors.navyBlue,
                                                  textAlign: TextAlign.center),
                                              SizedBox(height: height(context) * 0.03),
                                              Image.asset(AppImages.deleteAccDialog, scale: 3),
                                              SizedBox(height: height(context) * 0.03),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: (){
                                                        cubit.deleteAcc(context);
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
                                    ),
                                );
                              },
                            ),
                            label: LocaleKeys.deleteAcc.tr(),
                          ),
                          SizedBox(height: height(context) * 0.018)
                        ]))),

                      ]))));
        },
      ),
    );
  }
}
