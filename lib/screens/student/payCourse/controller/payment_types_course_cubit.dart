import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_toast.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/core/local/global_config.dart';
import 'package:private_courses/generated/locale_keys.g.dart';
import 'package:private_courses/screens/student/payCourse/controller/payment_types_course_states.dart';
import 'package:private_courses/screens/student/payment_course/components/subscribe_course_success.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import 'package:private_courses/shared/remote/dio.dart';
import 'package:tabby_flutter_inapp_sdk/tabby_flutter_inapp_sdk.dart';

class PaymentTypesCourseCubit extends Cubit<PaymentTypesCourseStates> {
  PaymentTypesCourseCubit() : super(PaymentTypesCourseInitialState());

  static PaymentTypesCourseCubit get(context) => BlocProvider.of(context);



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

  BuildContext? ctx;
  int value = 98;
  TabbySession? session;
  Future<void> createSession(context) async {
    print("---------------------------");
    ctx = context;
    try {
      session = await TabbySDK().createSession(TabbyCheckoutPayload(
        merchantCode: 'ae',
        lang: CacheHelper.getData(key: AppCached.appLanguage)== 'ar' ? Lang.ar : Lang.en,
        payment: mockPayload,

      ));
      print("-*-*-*-*-*--*-*-*-*-*-*-*-");
      print("-*-*-*-*-*--*-*-*-*-*-*-*- "+session.toString());
      print("-*-*-*-*-*--*-*-*-*-*-*-*- "+session!.availableProducts.installments!.webUrl.toString());
      emit(CreateSessionState());
    } catch (e) {
    }
  }
  void openInAppBrowser(id,courseName) {
    TabbyWebView.showWebView(
      context: ctx!,
      webUrl: session!.availableProducts.installments!.webUrl,
      onResult: (WebViewResult resultCode) async{
        if(resultCode.name == "authorized"){
          await subscribeCourse(context: ctx!, id: id, courseName: courseName);
        }else if  (resultCode.name == "rejected"){
          Navigator.pop(ctx!);
          showSnackBar(context: ctx!, text: LocaleKeys.OperationField.tr(), success: false);
          print("rejected ya mo8fal");
        }else if (resultCode.name == "close"){
          Navigator.pop(ctx!);
          showSnackBar(context: ctx!, text: LocaleKeys.OperationField.tr(), success: false);
          print("closedddd ya mo8fal");
        }else{
          Navigator.pop(ctx!);
          showSnackBar(context: ctx!, text: LocaleKeys.OperationField.tr(), success: false);
          print("expiredddd  ya mo8fal");
        }

      },
    );
  }
  dynamic mockPayload = Payment(
    amount: CacheHelper.getData(key:AppCached.amountCart).toString(),
    currency: Currency.sar,
    buyer: Buyer(
      email: CacheHelper.getData(key: AppCached.email)??"",
      phone: CacheHelper.getData(key: AppCached.phone)??"",
      name: CacheHelper.getData(key: AppCached.name)??"",
    ),
    buyerHistory: BuyerHistory(
      loyaltyLevel: 0,
      registeredSince: '2019-08-24T14:15:22Z',
      wishlistCount: 0,
    ),
    shippingAddress: const ShippingAddress(
      city: 'string',
      address: 'string',
      zip: 'string',
    ),
    order: Order(referenceId: 'id123', items: [
      OrderItem(
        title: 'Jersey',
        description: 'Jersey',
        quantity: 1,
        unitPrice: '10.00',
        referenceId: 'uuid',
        productUrl: 'http://example.com',
        category: 'clothes',
      )
    ]),
    orderHistory: [
      OrderHistoryItem(
        purchasedAt: '2019-08-24T14:15:22Z',
        amount: '10.00',
        paymentMethod: OrderHistoryItemPaymentMethod.card,
        status: OrderHistoryItemStatus.newOne,
      )
    ]
  );
  changeRadio(int i){
    value = i;
    emit(ChangeRadioState());
  }

}