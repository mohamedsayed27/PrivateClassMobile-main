
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_toast.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/core/local/global_config.dart';
import 'package:private_courses/generated/locale_keys.g.dart';
import 'package:private_courses/screens/common/btnNavBar/view/custom_btn_nav_bar_view.dart';
import 'package:private_courses/screens/common/drawer/components/custom_zoom_drawer.dart';
import 'package:private_courses/screens/student/payment_cart/components/payment_cart_success.dart';
import 'package:private_courses/screens/student/payment_types/controller/payment_states.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import 'package:private_courses/shared/remote/dio.dart';
import 'package:tabby_flutter_inapp_sdk/tabby_flutter_inapp_sdk.dart';

class PayCartTypesCubit extends Cubit<PayCartTypesStates> {
  PayCartTypesCubit() : super(PayCartTypesInitialState());

  static PayCartTypesCubit get(context) => BlocProvider.of(context);


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

      if (payCartResponse!['status'] == false) {
        debugPrint(payCartResponse.toString());
        showSnackBar(context: context, text: payCartResponse!['message'], success: false);
        emit(PayNowErrorState());
      } else {
        debugPrint(payCartResponse.toString());
        //showSnackBar(context: context, text: payCartResponse!['message'], success: true);
        CacheHelper.saveData(AppCached.cartCount, 0);
        showDialog(context: context, builder: (context) => CartPaymentSuccess());
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
    ctx=context;
    try {
      session = await TabbySDK().createSession(TabbyCheckoutPayload(
        merchantCode: 'ae',
        lang: CacheHelper.getData(key: AppCached.appLanguage)== 'ar' ? Lang.ar : Lang.en,
        payment: mockPayload,

      ));
        print("-*-*-*-*-*--*-*-*-*-*-*-*-");
        print("-*-*-*-*-*--*-*-*-*-*-*-*- "+session.toString());
        print("-*-*-*-*-*--*-*-*-*-*-*-*- "+session!.availableProducts.installments!.webUrl.toString());
        emit(NewState());
    } catch (e, s) {
    }
  }
   void openInAppBrowser() {
    TabbyWebView.showWebView(
      context: ctx!,
      webUrl: session!.availableProducts.installments!.webUrl,
      onResult: (WebViewResult resultCode) async {
        if(resultCode.name == "authorized"){
          await paymentCart(context: ctx!);
        }else if  (resultCode.name == "rejected"){
          Navigator.pop(ctx!);
          showSnackBar(context: ctx!, text: LocaleKeys.OperationField.tr(), success: false);
        }else if  (resultCode.name == "close"){
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
    ],
  );
  changeRadio(int i){
    value=i;
    emit(ChangeRadioState());
  }
}
