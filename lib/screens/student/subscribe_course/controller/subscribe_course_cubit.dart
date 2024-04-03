import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_toast.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/screens/student/payment_cart/components/payment_cart_success.dart';
import 'package:private_courses/screens/student/payment_course/components/subscribe_course_success.dart';
import 'package:private_courses/screens/student/subscribe_course/components/custom_web_view.dart';
import 'package:private_courses/screens/student/subscribe_course/controller/subscribe_course_states.dart';
import 'package:private_courses/shared/local/cache_helper.dart';

import '../../../../core/local/app_cached.dart';
import '../../../../core/local/global_config.dart';
import '../../../../shared/remote/dio.dart';

class SubscribeCourseCubit extends Cubit<SubscribeCourseStates> {
  SubscribeCourseCubit() : super(SubscribeCourseInitialState());

  static SubscribeCourseCubit get(context) => BlocProvider.of(context);

  int x = 0;
  int y = 1;
  int z = 2;
  int selectedVal = 3;

  String? type;

  void changeRadio(int value, String val) {
    selectedVal = value;
    type = val;
    print(val + "  typeeeeeeeee");
    print(value.toString() + "valueeeeeee");
    emit(ChangeRadioState());
  }

  Map<dynamic, dynamic>? subscribeResponse;

  Future<void> subscribe(
      {required BuildContext context,
      required int courseId,
      required String courseName,
      required bool isCart}) async {
    debugPrint('>>>>>>>>>>>>>>>> Subscribe Now Loading <<<<<<<<<<<<<<');
    emit(SubscribeNowLoadingState());

    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };

      subscribeResponse = await myDio(
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioHeaders: headers,
        url: AllAppApiConfig.baseUrl + AllAppApiConfig.subscribeCourse + "/${courseId}?src=${type}",
        methodType: 'get',
        context: context,
        dioBody: null,
      );
      debugPrint(AllAppApiConfig.baseUrl + AllAppApiConfig.subscribeCourse + "/${courseId}?src=${type}");

      if (subscribeResponse!['status'] == false) {
        debugPrint(
            '>>>>>>>>>>>>>>> Subscribe Now Find Error <<<<<<<<<<<<<<<<<<<<<');
        debugPrint(subscribeResponse.toString());
        emit(SubscribeNowErrorState());
      } else {
        debugPrint(
            '>>>>>>>>>>>>>>>>>>>> Subscribe Now Successes <<<<<<<<<<<<<<<<<<<<');
        debugPrint(subscribeResponse.toString());
        print(subscribeResponse!['data']);
        navigateTo(
            context,
            CustomWebView(
                link: subscribeResponse!['data'],
                name: courseName,
                isCart: isCart));
        emit(SubscribeNowSuccessState());
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }

    debugPrint('>>>>>>>>>>>>>> Finishing Subscribe Now Ok >>>>>>>>>');
  }

  Map<dynamic, dynamic>? payResponse;

  Future<void> payment({required BuildContext context, required bool isCart}) async {
    debugPrint('>>>>>>>>>>>>>>>> Payment Now Loading <<<<<<<<<<<<<<');
    emit(PayNowLoadingState());

    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };

      final formData = ({'src': type});

      debugPrint(formData.toString() + " wwwwwwwww");

      payResponse = await myDio(
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioHeaders: headers,
        url: AllAppApiConfig.baseUrl + AllAppApiConfig.pay,
        methodType: 'post',
        context: context,
        dioBody: formData);

      if (payResponse!['status'] == false) {
        debugPrint('>>>>>>>>>>>>>>> Payment Now Find Error <<<<<<<<<<<<<<<<<<<<<');
        debugPrint(payResponse.toString());
        showSnackBar(context: context, text: payResponse!['message'], success: false);
        emit(PayNowErrorState());
      } else {
        debugPrint('>>>>>>>>>>>>>>>>>>>> Payment Now Successes <<<<<<<<<<<<<<<<<<<<');
        debugPrint(payResponse.toString());
        print(payResponse!['data'] + "     link");
        navigateTo(context, CustomWebView(link: payResponse!['data'],isCart: isCart));
        emit(PayNowSuccessState());
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }

    debugPrint('>>>>>>>>>>>>>> Finishing Payment Now Ok >>>>>>>>>');
  }

  Map<dynamic, dynamic>? payCartResponse;

  Future<void> paymentCart({required BuildContext context}) async {
    emit(PayNowLoadingState());
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };

      payCartResponse = await myDio(
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioHeaders: headers,
        url: AllAppApiConfig.baseUrl + AllAppApiConfig.cartPay,
        methodType: 'get',
        context: context,
        dioBody: null);
      print(AllAppApiConfig.baseUrl + AllAppApiConfig.cartPay);
      print(CacheHelper.getData(key: AppCached.token));
      if (payCartResponse!['status'] == false) {
        debugPrint(payCartResponse.toString());
        showSnackBar(context: context, text: payCartResponse!['message'], success: false);
        emit(PayNowErrorState());
      } else {
        debugPrint(payCartResponse.toString());
        CacheHelper.saveData(AppCached.cartCount, 0);
        showDialog(context: context, builder: (context) => CartPaymentSuccess());
        emit(PayNowSuccessState());
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
  }



  Map<dynamic, dynamic>? subScribeCourseResponse;

  Future<void> subscribeCourse({required BuildContext context, required int id,required String courseName}) async {
    emit(PayNowLoadingState());

    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };



      subScribeCourseResponse = await myDio(
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioHeaders: headers,
        url: "${AllAppApiConfig.baseUrl}${AllAppApiConfig.subCourse}?course_id=${id}",
        methodType: 'get',
        context: context,
        dioBody: null);
      print("${AllAppApiConfig.baseUrl}${AllAppApiConfig.subCourse}?course_id=${id}");

      if (subScribeCourseResponse!['status'] == false) {
        debugPrint(subScribeCourseResponse.toString());
        showSnackBar(context: context, text: subScribeCourseResponse!['message'], success: false);
        emit(PayNowErrorState());
      } else {
        debugPrint('>>>>>>>>>>>>>>>>>>>> Payment Now Successes <<<<<<<<<<<<<<<<<<<<');
        debugPrint(subScribeCourseResponse.toString());
        showDialog(context: context, builder: (context) => SubscribeCourseSuccess(courseName: courseName));
        emit(PayNowSuccessState());
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }

  }
}
