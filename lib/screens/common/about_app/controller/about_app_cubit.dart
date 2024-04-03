import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/core/local/global_config.dart';
import 'package:private_courses/screens/common/about_app/controller/about_app_states.dart';
import 'package:private_courses/screens/common/about_app/model/about_app_model.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import 'package:private_courses/shared/remote/dio.dart';

class AboutAppCubit extends Cubit<AboutAppStates>{
  AboutAppCubit():super(AboutAppInitialState());

  static AboutAppCubit get(context) => BlocProvider.of(context);

  Map<dynamic,dynamic>? aboutAppResponse;
  AboutAppModel? aboutAppModel;

  Future<void> fetchAboutApp({required BuildContext? context})async{
    emit(LoadingState());
    try{
      Map <String , dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
      };
      aboutAppResponse = await myDio(
          url: AllAppApiConfig.baseUrl + AllAppApiConfig.aboutApp,
          methodType: "get",
          dioBody: null,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if(aboutAppResponse!['status']==false){
        debugPrint(aboutAppResponse.toString());
        emit(FieldState());
      }else {
        debugPrint(aboutAppResponse.toString());
        aboutAppModel = AboutAppModel.fromJson(aboutAppResponse!);
        emit(SuccessState());
      }
    }catch(e,s){
      print(e);
      print(s);
    }
  }
}