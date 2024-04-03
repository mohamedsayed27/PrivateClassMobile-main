import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../components/my_navigate.dart';
import '../../../../core/local/app_cached.dart';
import '../../../../shared/local/cache_helper.dart';
import '../../on_boarding/views/on_boarding.dart';
import 'lang_states.dart';

class LanguageCubit extends Cubit<LanguageStates> {
  LanguageCubit() : super(LanguageStatesInitialState());

  static LanguageCubit get(context) => BlocProvider.of(context);


  void selectARLanguage(BuildContext? context) async {

    await context!.setLocale(const Locale("ar"));
    CacheHelper.saveData(AppCached.appLanguage, 'ar');
    print('the current lang is ${context.locale}');
    navigateTo(context,const  OnBoardingView());
   // navigateAndFinish(context:context,widget:const OnBoardingView());
    emit(LanguageSelectedState());

  }
  void selectENLanguage(BuildContext context) async {

    await context.setLocale(const Locale('en'));
    CacheHelper.saveData(AppCached.appLanguage, 'en');
    print('the current lang is ${context.locale}');
    navigateTo(context,const  OnBoardingView());
    // navigateAndFinish(context:context,widget:const OnBoardingView());
    emit(LanguageSelectedState());

  }



}
