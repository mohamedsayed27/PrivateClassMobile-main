
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/core/local/global_config.dart';
import 'package:private_courses/screens/common/splash/splash_states.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import 'package:private_courses/shared/remote/dio.dart';
import 'package:tabby_flutter_inapp_sdk/tabby_flutter_inapp_sdk.dart';

class SplashCubit extends Cubit<SplashStates> {
  SplashCubit() : super(SplashInitialState());

  static SplashCubit get(context) => BlocProvider.of(context);

  /// payment key
  Map<dynamic, dynamic>? payResponse;
  Future<void> getPayKey({required BuildContext context}) async {
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': "ar",
      };
      payResponse = await myDio(
          appLanguage: "ar",
          dioHeaders: headers,
          url: AllAppApiConfig.baseUrl + AllAppApiConfig.paykey,
          methodType: 'get',
          context: context,
          dioBody: null);
      if (payResponse!['status'] == false) {
        debugPrint(payResponse.toString());
      } else {
        debugPrint(payResponse.toString());
        debugPrint(payResponse!["data"]['pk']);
        debugPrint(payResponse!["data"]['sk']);
        TabbySDK().setup(
          withApiKey: payResponse!["data"]['pk'], // Put here your Api key
          // environment: Environment.production, // Or use Environment.stage
        );
        debugPrint('>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get Profile Successes <<<<<<<<<<<<<<<<<<<<<<<<<');
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    debugPrint('>>>>>>>>>>>>>> Finishing Getting Profile data Ok >>>>>>>>>');
  }

}