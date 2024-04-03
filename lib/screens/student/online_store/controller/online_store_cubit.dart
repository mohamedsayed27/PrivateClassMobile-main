import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_toast.dart';
import 'package:private_courses/components/style/images.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/core/local/global_config.dart';
import 'package:private_courses/generated/locale_keys.g.dart';
import 'package:private_courses/screens/common/btnNavBar/controller/custom_btn_nav_bar_cubit.dart';
import 'package:private_courses/screens/student/online_store/model/categoriesModel.dart';
import 'package:private_courses/screens/student/online_store/model/courses_by_category_model.dart';
import 'package:private_courses/screens/student/online_store/model/slider_model.dart';
import 'package:private_courses/screens/student/saves/model/save_model.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import 'package:private_courses/shared/remote/dio.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../product_details/model/add_to_cart_model.dart';
import '../model/store_search_model.dart';
import 'online_store_states.dart';

class OnlineStoreCubit extends Cubit<OnlineStoreStates> {
  OnlineStoreCubit() : super(OnlineStoreInitialState());

  static OnlineStoreCubit get(context) => BlocProvider.of(context);

  int numSlider = 0;
  void changeSlider(int index) {
    numSlider = index;
    emit(ChangeSliderState());
  }

  List<String> allCategories = [
    LocaleKeys.All.tr(),
    LocaleKeys.HighSchool.tr(),
    LocaleKeys.Undergraduate.tr(),
  ];
  List<String> allCategoriesImages = [
    AppImages.all,
    AppImages.educationBook,
    AppImages.cap,
  ];

  int currentIndex = 0;
  void changeColor(int index) {
    currentIndex = index;
    emit(ChangeColorState());
  }

  /// *-*-*-*-*-*-*-*-*-*-*-*-*-*  Store Slider  *-*-*-*-*-*-*-*-*-*-*-*-*-*
  Map<dynamic, dynamic>? sliderResponse;
  CartSliderModel? storeSliderModel;
  Future<void> fetchStoreSlider({required BuildContext? context}) async {
    print(CacheHelper.getData(key: AppCached.token));

    if(CacheHelper.getData(key: AppCached.token)!=null){
      emit(LoadingState());
    catStage.clear();
    currentPage = 1;
    catIndex = 1;
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      sliderResponse = await myDio(
          url: AllAppApiConfig.baseUrl + AllAppApiConfig.storeSlider,
          methodType: "get",
          dioBody: null,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if (sliderResponse!['status'] == false) {
        print("objssssect");
        debugPrint(sliderResponse.toString());
      } else {
        print("object");
        debugPrint(sliderResponse!.toString());
        storeSliderModel = CartSliderModel.fromJson(sliderResponse!);
        await fetchCategories(context: context);
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
    }else{
      print("No Tokennnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn");
      await fetchCategories(context: context);
    }
  }

  /// *-*-*-*-*-*-*-*-*-*-*-*-*-*  Store category  *-*-*-*-*-*-*-*-*-*-*-*-*-*
  List<Dataaa> categories = [Dataaa(id: 0, name: LocaleKeys.All.tr())];
  Map<dynamic, dynamic>? categoriesResponse;
  CategoriesModel? categoriesModel;
  Future<void> fetchCategories({required BuildContext? context}) async {
    CacheHelper.getData(key: AppCached.token)!=null ? null:emit(LoadingState());
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        if(CacheHelper.getData(key: AppCached.token)!=null )
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      categoriesResponse = await myDio(
          url: AllAppApiConfig.baseUrl + AllAppApiConfig.storeCategories,
          methodType: "get",
          dioBody: null,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if (categoriesResponse!['status'] == false) {
        print("objssssect");
        debugPrint(categoriesResponse.toString());
      } else {
        debugPrint(categoriesResponse!.toString());
        categoriesModel = CategoriesModel.fromJson(categoriesResponse!);
        categoriesModel!.data!.forEach((element) {
          categories.add(element);
        });
        await fetchCouersesById(context: context);
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  /// *-*-*-*-*-*-*-*-*-*-*-*-*-*  Fetch Courses By Category ID  *-*-*-*-*-*-*-*-*-*-*-*-*-*
  ScrollController scrollCtrl = ScrollController();
  Map<dynamic, dynamic>? coursesByCatIdResponse;
  CoursesByCategoryModel? coursesByCatIdModel;
  int currentPage = 1;
  int catIndex = 1;
  int? currentId;
  List<CourseData> catStage = [];
  var refreshController = RefreshController();
  Future<void> fetchCouersesById({required BuildContext? context}) async {
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        if(CacheHelper.getData(key: AppCached.token)!=null )
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      coursesByCatIdResponse = await myDio(
          url: '${AllAppApiConfig.baseUrl}${AllAppApiConfig.coursesById}?page=${currentPage}',
          methodType: "post",
          dioBody: {"stage_id": currentId},
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      print('${AllAppApiConfig.baseUrl}${AllAppApiConfig.coursesById}?page=${currentPage}');
      if (coursesByCatIdResponse!['status'] == false) {
        debugPrint(coursesByCatIdResponse.toString());
        // emit(FieldState());
      } else {
        print("Cat ID Successsssssssssssssss");
        debugPrint(coursesByCatIdResponse!.toString());
        coursesByCatIdModel = CoursesByCategoryModel.fromJson(coursesByCatIdResponse!);
        print("Cat ID Successsssssssssssssss");
        print("last pagee    " + coursesByCatIdModel!.data!.meta!.lastPage.toString());
        print("idddddddddd    " + currentId.toString());
        catStage.addAll(coursesByCatIdModel!.data!.data!);
        print("Cat ID Successsssssssssssssss");
        print("sssssssssss + " + catStage.toString());
        emit(SuccessState());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  fetchMoreCat({required BuildContext? context, bool isRefresh = false}) async {
    print("cubiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiit");
    if (currentPage > coursesByCatIdModel!.data!.meta!.lastPage!) {
      debugPrint("Finishshshhsh Paginationnn");
      refreshController.loadFailed();
    } else {
      currentPage = currentPage + 1;
      debugPrint(" Paginationnn   " + currentPage.toString());
      await fetchCouersesById(context: context);
      refreshController.loadComplete();
    }

    emit(FinishLoading());
  }

  changeCurrentPage(int? index) {
    currentPage = 1;
    currentId = categories[index!].id == 0 ? null : categories[index].id;
    catStage = [];
    emit(ChangeColorState());
  }

  /// *-*-*-*-*-*-*-*-*-*-*-*-*-*  Save / UnSave course  *-*-*-*-*-*-*-*-*-*-*-*-*-*

  Map<dynamic, dynamic>? saveResponse;
  SaveModel? saveModel;
  Future<void> saveCourse({required BuildContext? context, required int id, required int? index}) async {
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      saveResponse = await myDio(
          url: AllAppApiConfig.baseUrl + AllAppApiConfig.save + id.toString(),
          methodType: "get",
          dioBody: null,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if (saveResponse!['status'] == false) {
        debugPrint(saveResponse.toString());
        emit(SaveCourseField());
      } else {
        debugPrint(saveResponse!.toString());
        saveModel = SaveModel.fromJson(saveResponse!);
        // coursesByCatIdModel!.data!.data![index!].isFavorite =
        //     !coursesByCatIdModel!.data!.data![index].isFavorite!;
        debugPrint("${catStage[index!].id}");
        catStage[index].isFavorite = !catStage[index].isFavorite!;

        emit(SaveCourseSuccess());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }
  Future<void> saveSearchCourse({required BuildContext? context, required int id, required int index}) async {
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      saveResponse = await myDio(
          url: AllAppApiConfig.baseUrl + AllAppApiConfig.save + id.toString(),
          methodType: "get",
          dioBody: null,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if (saveResponse!['status'] == false) {
        debugPrint(saveResponse.toString());
        emit(SaveCourseField());
      } else {
        debugPrint(saveResponse!.toString());
        saveModel = SaveModel.fromJson(saveResponse!);
        storeSearchModel!.data![index].isFavorite = !storeSearchModel!.data![index].isFavorite;
        emit(SaveCourseSuccess());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  var searchCtrl = TextEditingController();
  Map<dynamic, dynamic>? storeSearchResponse;
  StoreSearchModel? storeSearchModel;
  bool? isSearch = false;
  Future<void> searchCourse({
    required BuildContext? context,
    required String courseName,
  }) async {
    emit(LoadingState());
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        if(CacheHelper.getData(key: AppCached.token)!=null )
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      storeSearchResponse = await myDio(
          url: "${AllAppApiConfig.baseUrl}"
              "${AllAppApiConfig.searchCourse}",
          methodType: "get",
          dioBody: {
            'search': courseName,
          },
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if (storeSearchResponse!['status'] == false) {
        debugPrint(storeSearchResponse.toString());
        emit(SearchStoreErrorState());
      } else {
        debugPrint(storeSearchResponse!.toString());
        storeSearchModel = StoreSearchModel.fromJson(storeSearchResponse!);
        emit(SearchStoreSuccessState());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  Map<dynamic, dynamic>? addToCartResponse;
  AddToCartModel? addToCartModel;
  Future<void> addToCart({required BuildContext? context, required dynamic id}) async {
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
        showSnackBar(context: context, success: false, text: addToCartResponse!['message']);
        emit(AddToCartFailedState(msg: addToCartResponse!['message']));
      } else {
        debugPrint(addToCartResponse!.toString());
        addToCartModel = AddToCartModel.fromJson(addToCartResponse!);
        showSnackBar(context: context, success: true, text: addToCartResponse!['message']);
        await CustomBtnNavBarCubit.get(context).getProfile(context: context);
        emit(AddToCartSuccessState());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

}
