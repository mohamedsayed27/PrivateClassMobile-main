import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/screens/common/splash/splash_view.dart';

import '../../../../components/custom_toast.dart';
import '../../../../core/local/global_config.dart';
import '../../../../shared/local/cache_helper.dart';
import '../../../../shared/remote/dio.dart';
import 'settings_states.dart';

class SettingsCubit extends Cubit<SettingsStates>{
  SettingsCubit():super(SettingsInitialState());

  static SettingsCubit get(context) => BlocProvider.of(context);

  bool notifyOn = CacheHelper.getData(key: AppCached.isNotify) == true ? true : false;

  void toggleNotify(){
    notifyOn= !notifyOn;
    CacheHelper.saveData(AppCached.isNotify, notifyOn == true ? true : false);
    emit(SettingsChangeNotify());
  }


  Map<dynamic, dynamic>? activateNotifyResponse;

  Future<void> activateNotify(context) async {
    debugPrint('>>>>>>>>>>>>>> Active Notify Loading >>>>>>>>>');
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };

      activateNotifyResponse = await myDio(
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioHeaders: headers,
        url: AllAppApiConfig.baseUrl + AllAppApiConfig.activeNotify,
        methodType: 'get',
        dioBody: null,
        context: context,
      );

      if (activateNotifyResponse!['status'] == false) {
        debugPrint('>>>>>>>>>>>>>> Active Notify Find Error >>>>>>>>>');
        showSnackBar(context: context, text: activateNotifyResponse!['message'], success: false);
        emit(ActiveNotifyError());
      } else {
        debugPrint('>>>>>>>>>>>>>> Active Notify Success >>>>>>>>>');
        showSnackBar(context: context, text: activateNotifyResponse!['message'], success: true);
        emit(ActiveNotifySuccess());
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    debugPrint('>>>>>>>>>>>>>> Finishing Active Notify Ok >>>>>>>>>');
  }

  Map<dynamic, dynamic>? deleteAccResponse;

  Future<void> deleteAcc(context) async {
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };

      deleteAccResponse = await myDio(
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioHeaders: headers,
        url: AllAppApiConfig.baseUrl + AllAppApiConfig.deleteAcc,
        methodType: 'get',
        dioBody: null,
        context: context,
      );

      if (deleteAccResponse!['status'] == false) {
        showSnackBar(context: context, text: deleteAccResponse!['message'], success: false);
        emit(ActiveNotifyError());
      } else {
        navigateAndFinish(context: context, widget: SplashScreen());
        CacheHelper.sharedPreferences.clear();
        showSnackBar(context: context, text: deleteAccResponse!['message'], success: true);
        emit(ActiveNotifySuccess());
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
  }





}