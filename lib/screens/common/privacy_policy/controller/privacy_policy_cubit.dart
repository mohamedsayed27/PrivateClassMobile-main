import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/core/local/global_config.dart';
import 'package:private_courses/screens/common/privacy_policy/model/privacy_policy_model.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import 'package:private_courses/shared/remote/dio.dart';

import 'privacy_policy_states.dart';

class PrivacyPolicyCubit extends Cubit<PrivacyPolicyStates>{
  PrivacyPolicyCubit():super(PrivacyPolicyInitialState());

  static PrivacyPolicyCubit get(context) => BlocProvider.of(context);


  Map<dynamic,dynamic>? privacyPolicyResponse;
  PrivacyPolicyModel? privacyPolicyModel;

  Future<void> fetchPrivacy({required BuildContext? context})async{
    emit(LoadingState());
    try{
      Map <String , dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
      };
      privacyPolicyResponse = await myDio(
          url: AllAppApiConfig.baseUrl + AllAppApiConfig.privacyPolicy,
          methodType: "get",
          dioBody: null,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if(privacyPolicyResponse!['status']==false){
        debugPrint(privacyPolicyResponse.toString());
        emit(FieldState());
      }else {
        debugPrint(privacyPolicyResponse.toString());
        privacyPolicyModel = PrivacyPolicyModel.fromJson(privacyPolicyResponse!);
        emit(SuccessState());
      }
    }catch(e,s){
      print(e);
      print(s);
    }
  }
}