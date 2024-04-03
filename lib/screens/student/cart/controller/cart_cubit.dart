import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_toast.dart';
import 'package:private_courses/screens/common/btnNavBar/controller/custom_btn_nav_bar_cubit.dart';
import '../../../../core/local/app_cached.dart';
import '../../../../core/local/global_config.dart';
import '../../../../shared/local/cache_helper.dart';
import '../../../../shared/remote/dio.dart';
import '../../saves/model/save_model.dart';
import '../model/cart_model.dart';
import '../model/check_coupon_model.dart';
import './cart_states.dart';

class CartCubit extends Cubit<CartStates> {
  CartCubit() : super(CartInitialState());

  static CartCubit get(context) => BlocProvider.of(context);

  TextEditingController couponController = TextEditingController();

  int discount = 0;
  Map<dynamic, dynamic>? cartResponse;
  CartModel? cartModel;
  Future<void> getCart({required BuildContext? context, required bool isLoading}) async {
    isLoading==true? emit(GetCartLoadingState()):null;
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}',
      };
      cartResponse = await myDio(
          url: "${AllAppApiConfig.baseUrl}${AllAppApiConfig.cart}",
          methodType: "get",
          dioBody: null,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if (cartResponse!['status'] == false) {
        debugPrint(cartResponse.toString());
        emit(GetCartFailedState());
      } else {
        debugPrint(cartResponse!.toString());
        cartModel = CartModel.fromJson(cartResponse!);
        emit(GetCartSuccessState());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  Map<dynamic, dynamic>? deleteItemResponse;
  CartModel? deletedItem;
  Future<void> deleteItem({required BuildContext? context, required dynamic itemId}) async {
    emit(ItemDeleteLoadingState());
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      deleteItemResponse = await myDio(
          url: "${AllAppApiConfig.baseUrl}${AllAppApiConfig.deleteItem}/$itemId",
          methodType: "get",
          dioBody: null,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if (deleteItemResponse!['status'] == false) {
        debugPrint(deleteItemResponse.toString());
        emit(ItemDeleteFailedState());
      } else {
        debugPrint(cartResponse!.toString());
        deletedItem = CartModel.fromJson(deleteItemResponse!);
        await getCart(context: context,isLoading: false);
        await CustomBtnNavBarCubit.get(context).getProfile(context: context);
        //showSnackBar(context: context, text: deleteItemResponse!['message'], success: true);
        emit(ItemDeleteSuccessState());



      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  Map<dynamic, dynamic>? checkCouponResponse;
  CheckCouponModel? checkCouponModel;
  Future<void> checkCoupon({required BuildContext? context, required dynamic coupon}) async {
    emit(CheckCouponLoadingState());
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}',
      };
      checkCouponResponse = await myDio(
          url: AllAppApiConfig.baseUrl+AllAppApiConfig.checkCoupon,
          methodType: "post",
          dioBody: {"code": coupon},
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if (checkCouponResponse!['status'] == false) {
        debugPrint(checkCouponResponse.toString());
        showSnackBar(context: context, text: checkCouponResponse!['message'], success: false);
        emit(CheckCouponFailedState(error: checkCouponResponse!['message']));
      } else {
        debugPrint(checkCouponResponse!.toString());
        checkCouponModel = CheckCouponModel.fromJson(checkCouponResponse!);
        showSnackBar(context: context, text: checkCouponResponse!['message'], success: true);
        emit(CheckCouponSuccessState());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  Map<dynamic, dynamic>? saveResponse;
  SaveModel? saveModel;
  Future<void> saveCart({
    required BuildContext? context,
    required int index,
    required int id,
  }) async {
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      saveResponse = await myDio(
          url: "${AllAppApiConfig.baseUrl}""${AllAppApiConfig.save}""${id.toString()}",
          methodType: "get",
          dioBody: null,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if (saveResponse!['status'] == false) {
        debugPrint(saveResponse.toString());
        emit(SaveCartErrorState());
      } else {
        debugPrint(saveResponse!.toString());
        saveModel = SaveModel.fromJson(saveResponse!);
        cartModel!.data!.items![index].isFavorite = !cartModel!.data!.items![index].isFavorite!;
        emit(SaveCartSuccessState());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  // Map<dynamic, dynamic>? payResponse;
  //
  // Future<void> payNow({required BuildContext? context, required dynamic discount}) async {
  //   debugPrint("${AllAppApiConfig.baseUrl}${AllAppApiConfig.pay}");
  //   emit(PayLoadingState());
  //   try {
  //     Map<String, dynamic> headers = {
  //       'Accept': 'application/json',
  //       'Content-Type': 'application/json',
  //       'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
  //       'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}',
  //     };
  //     payResponse = await myDio(
  //         url: "${AllAppApiConfig.baseUrl}${AllAppApiConfig.pay}",
  //         methodType: "post",
  //         dioBody: {"discount": discount,
  //         },
  //         dioHeaders: headers,
  //         appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
  //         context: context!);
  //     if (payResponse!['status'] == false) {
  //       debugPrint(payResponse.toString());
  //       emit(PayFailedState(error: payResponse!['message']));
  //     } else {
  //       debugPrint(cartResponse!.toString());
  //       emit(PaySuccessState(message: cartResponse!['message']));
  //     }
  //   } catch (e, s) {
  //     print(e);
  //     print(s);
  //   }
  // }
}
