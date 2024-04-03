import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_appBar.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/generated/locale_keys.g.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import '../../../../components/my_navigate.dart';
import '../../../../components/style/size.dart';
import '../../btnNavBar/view/custom_btn_nav_bar_view.dart';
import '../../drawer/components/custom_zoom_drawer.dart';
import '../component/lang_item.dart';
import '../controller/change_language_cubit.dart';
import '../controller/change_language_state.dart';

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({Key? key}) : super(key: key);

  @override
  State<ChangeLanguage> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChangeLanguageCubit>(
      create: (context) => ChangeLanguageCubit(),
      child: BlocConsumer<ChangeLanguageCubit, ChangeLanguageState>(
        listener: ((context, state) {
          if (state is ChangeLanguageSuccesState) {
            navigateAndFinish(
                context: context,
                widget: CustomZoomDrawer(
                  mainScreen: CustomBtnNavBarScreen(page: 0,isTeacher: CacheHelper.getData(key: AppCached.role)),
                  isTeacher: CacheHelper.getData(key: AppCached.role),
                ));
          }
        }),
        builder: (context, state) {
          var cubit = ChangeLanguageCubit.get(context);
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: width(context) * 0.04),
                child: Column(
                  children: [
                    CustomAppBar(
                      isNotify: false,
                      isDrawer: false,
                      textAppBar: LocaleKeys.Lang.tr(),
                    ),
                    SizedBox(height: height(context) * 0.10),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          cubit.changeArabicLang(context, 0);
                        });
                      },
                      child: LanguageItem(
                        label: LocaleKeys.Arabic.tr(),
                        value: 0,
                        onChanged: (value) {
                          cubit.changeArabicLang(context, value);
                        },
                        groupValue: cubit.selectedValue,
                      ),
                    ),
                    SizedBox(height: height(context) * 0.05),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          cubit.changeEnglishLang(context, 1);
                        });
                      },
                      child: LanguageItem(
                        label: LocaleKeys.English.tr(),
                        value: 1,
                        onChanged: (value) {
                          cubit.changeEnglishLang(context, value);
                        },
                        groupValue: cubit.selectedValue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
