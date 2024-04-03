import 'dart:async';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/style/images.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/core/local/global_config.dart';
import 'package:private_courses/generated/locale_keys.g.dart';
import 'package:private_courses/screens/common/btnNavBar/controller/custom_btn_nav_bar_cubit.dart';
import 'package:private_courses/screens/student/product_details/model/course_details_model.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import 'package:private_courses/shared/remote/dio.dart';

import '../../saves/model/save_model.dart';
import '../model/add_to_cart_model.dart';
import 'product_details_states.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsStates> {
  ProductDetailsCubit() : super(ProductDetailsInitialState());

  static ProductDetailsCubit get(context) => BlocProvider.of(context);

  /// *-*-*-*-*-*-*-*-*-*-*-*-*-*  Store Slider  *-*-*-*-*-*-*-*-*-*-*-*-*-*
  Map<dynamic, dynamic>? courseDetailsResponse;
  CourseDetailsModel? courseDetailsModel;
  Future<void> fetchCourseDetails(
      {required BuildContext? context, required int? id}) async {
    emit(LoadingState());
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      courseDetailsResponse = await myDio(
          url: AllAppApiConfig.baseUrl + AllAppApiConfig.courseDetails + id.toString(),
          methodType: "get",
          dioBody: null,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if (courseDetailsResponse!['status'] == false) {
        debugPrint(courseDetailsResponse.toString());
        emit(FieldState());
      } else {
        debugPrint(courseDetailsResponse!.toString());
        courseDetailsModel = CourseDetailsModel.fromJson(courseDetailsResponse!);
        emit(SuccessState());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  Map<dynamic, dynamic>? addToCartResponse;
  AddToCartModel? addToCartModel;
  Future<void> addToCart(
      {required BuildContext? context, required dynamic id}) async {
    emit(AddToCartLoadingState());
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}',
      };
      addToCartResponse = await myDio(
          url: "${AllAppApiConfig.baseUrl}${AllAppApiConfig.addToCart}/$id",
          methodType: "get",
          dioBody: null,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if (addToCartResponse!['status'] == false) {
        debugPrint(addToCartResponse.toString());
        emit(AddToCartFailedState(msg: addToCartResponse!['message']));
      } else {
        debugPrint(addToCartResponse!.toString());
        addToCartModel = AddToCartModel.fromJson(addToCartResponse!);
        await CustomBtnNavBarCubit.get(context).getProfile(context: context);
        emit(AddToCartSuccessState(msg: addToCartResponse!['message']));

      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  Map<dynamic, dynamic>? saveResponse;
  SaveModel? saveModel;
  Future<void> saveCourse({
    required BuildContext? context,
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
          url: "${AllAppApiConfig.baseUrl}"
              "${AllAppApiConfig.save}"
              "${id.toString()}",
          methodType: "get",
          dioBody: null,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if (saveResponse!['status'] == false) {
        debugPrint(saveResponse.toString());
        emit(SaveCourseErrorState());
      } else {
        debugPrint(saveResponse!.toString());
        saveModel = SaveModel.fromJson(saveResponse!);
        courseDetailsModel!.data!.isFavorite =
            !courseDetailsModel!.data!.isFavorite!;
        emit(SaveCourseSuccessState());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }
}
