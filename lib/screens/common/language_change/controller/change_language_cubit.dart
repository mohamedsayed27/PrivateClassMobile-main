import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/local/app_cached.dart';
import '../../../../shared/local/cache_helper.dart';
import 'change_language_state.dart';

class ChangeLanguageCubit extends Cubit<ChangeLanguageState> {
  ChangeLanguageCubit() : super(ChangeLanguageInitial());

  static ChangeLanguageCubit get(context) => BlocProvider.of(context);

  int selectedValue = CacheHelper.getData(key: AppCached.appLanguage) == "ar" ? 0 : 1;

  void changeValue(value) {
    selectedValue = value;
    debugPrint(selectedValue.toString());
    emit(ChangeValueSuccesState());
  }

  void changeArabicLang(BuildContext context, dynamic value) async {
    changeValue(value);
    await context.setLocale(const Locale('ar'));
    CacheHelper.saveData(AppCached.appLanguage, 'ar');
    debugPrint(
        "the language is ${CacheHelper.getData(key: AppCached.appLanguage)}");
    emit(ChangeLanguageSuccesState());
  }

  void changeEnglishLang(BuildContext context, dynamic value) async {
    changeValue(value);
    await context.setLocale(const Locale('en'));
    CacheHelper.saveData(AppCached.appLanguage, 'en');
    debugPrint(
        "the language is ${CacheHelper.getData(key: AppCached.appLanguage)}");
    emit(ChangeLanguageSuccesState());
    // navigateAndFinish(context: context, widget: CustomZoomDrawer(
    //   mainScreen: const CustomBtnNavBar(isTeacher: false),
    //   isTeacher: false,
    // ));
  }
}
