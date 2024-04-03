

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/core/local/global_config.dart';
import 'package:private_courses/screens/common/return_policy/controller/return_policy_states.dart';
import 'package:private_courses/screens/common/return_policy/model/returnPolicy_model.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import 'package:private_courses/shared/remote/dio.dart';

import '../../privacy_policy/model/privacy_policy_model.dart';


class ReturnPolicyCubit extends Cubit<ReturnPolicyStates>{
  ReturnPolicyCubit():super(ReturnPolicyInitialState());

  static ReturnPolicyCubit get(context) => BlocProvider.of(context);


  Map<dynamic,dynamic>? returnPolicyResponse;
  ReturnPolicyModel? returnPolicyModel;

  Future<void> fetchReturnPolicy({required BuildContext? context})async{
    emit(LoadingState());
    try{
      Map <String , dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
      };
      returnPolicyResponse = await myDio(
          url: AllAppApiConfig.baseUrl + AllAppApiConfig.returnPolicy,
          methodType: "get",
          dioBody: null,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      print(AllAppApiConfig.baseUrl + AllAppApiConfig.returnPolicy);
      if(returnPolicyResponse!['status']==false){
        debugPrint(returnPolicyResponse.toString());
        emit(FieldState());
      }else {
        debugPrint(returnPolicyResponse.toString());
        returnPolicyModel = ReturnPolicyModel.fromJson(returnPolicyResponse!);
        emit(SuccessState());
      }
    }catch(e,s){
      print(e);
      print(s);
    }
  }
}