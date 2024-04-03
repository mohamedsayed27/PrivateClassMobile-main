import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/core/local/global_config.dart';
import 'package:private_courses/screens/common/contact_us/model/send_report_model.dart';
import 'package:private_courses/screens/common/support_system/model/support_system_model.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import 'package:private_courses/shared/remote/dio.dart';

import 'support_sys_states.dart';

class SupportSystemCubit extends Cubit<SupportSystemStates>{
  SupportSystemCubit():super(SupportSystemInitialState());

  static SupportSystemCubit get(context) => BlocProvider.of(context);

  Map<dynamic,dynamic>? supportSystemResponse;
  SupportSystemModel? supportSystemModel;

  Future<void> fetchSupportSystem({required BuildContext? context})async{
    emit(LoadingState());
    try{
      Map <String , dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
      };
      supportSystemResponse = await myDio(
          url: AllAppApiConfig.baseUrl + AllAppApiConfig.supportSystem,
          methodType: "get",
          dioBody: null,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if(supportSystemResponse!['status']==false){
        debugPrint(supportSystemResponse.toString());
        emit(FieldState());
      }else {
        debugPrint(supportSystemResponse.toString());
        supportSystemModel = SupportSystemModel.fromJson(supportSystemResponse!);
        emit(SuccessState());
      }
    }catch(e,s){
      print(e);
      print(s);
    }
  }


}