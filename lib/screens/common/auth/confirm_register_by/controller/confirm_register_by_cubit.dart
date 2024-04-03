import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../components/custom_toast.dart';
import '../../../../../components/my_navigate.dart';
import '../../../../../core/local/app_cached.dart';
import '../../../../../core/local/global_config.dart';
import '../../../../../shared/local/cache_helper.dart';
import '../../../../../shared/remote/dio.dart';
import '../../pin_code/view/pin_code_view.dart';
import 'confirm_register_by_states.dart';

class ConfirmRegisterByCubit extends Cubit<ConfirmRegisterByStates> {
  ConfirmRegisterByCubit() : super(ConfirmRegisterByInitialState());

  static ConfirmRegisterByCubit get(context) => BlocProvider.of(context);

  /// Send Code
  Map<dynamic, dynamic>? sendCodeResponse;
  Future<void> sendCode({required BuildContext context,required String type}) async {
    debugPrint('>>>>>>>>>>>>>> Send Code Loading >>>>>>>>>');

    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
      };

      final formData = ({
        'phone':type=="phone"?CacheHelper.getData(key: AppCached.phone):"",
        'type': type,
        'email': type=="email"?CacheHelper.getData(key: AppCached.email):"",
      });

      debugPrint(formData.toString());

      sendCodeResponse = await myDio(
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioHeaders: headers,
        url: AllAppApiConfig.baseUrl + AllAppApiConfig.sendCode,
        methodType: 'post',
        dioBody: formData,
        context: context,
      );

      if (sendCodeResponse!['status'] == false) {
        showSnackBar(context: context, text: sendCodeResponse!['message'], success: false);
        debugPrint('>>>>>>>>>>>>>> Send Code Find Error >>>>>>>>>');
      } else {
        showSnackBar(context: context, text: sendCodeResponse!['message'], success: true);        // saveDataToShared(registerModel!.data!);
        debugPrint(sendCodeResponse.toString());
        debugPrint('>>>>>>>>>>>>>> Send Code Success >>>>>>>>>');
        navigateTo(context,  PinCodeScreen(isPass: false));

      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    debugPrint('>>>>>>>>>>>>>> Finishing Send Code Ok >>>>>>>>>');
  }

}