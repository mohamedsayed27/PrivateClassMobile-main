import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/local/app_cached.dart';
import '../../../../core/local/global_config.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/local/cache_helper.dart';
import '../../../../shared/remote/dio.dart';
import '../../saves/model/save_model.dart';
import '../model/all_secondary_model.dart';
import '../model/search_model.dart';
import 'all_secondary_states.dart';

class AllSecondaryCubit extends Cubit<AllSecondaryStates> {
  AllSecondaryCubit() : super(AllSecondaryInitialState());

  static AllSecondaryCubit get(context) => BlocProvider.of(context);

  var searchCtrl = TextEditingController();
  Map<dynamic, dynamic> secondaryResponse = {};
  AllSecondaryModel? secondaryModel;
  Future<void> getAllUniversity(BuildContext? context, dynamic id) async {
    emit(GetAllSecondaryLoadingState());
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        if(CacheHelper.getData(key: AppCached.token)!=null )
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}',
      };
      secondaryResponse = await myDio(
        url:
            "${AllAppApiConfig.baseUrl}${AllAppApiConfig.getAllUniversities}/$id",
        methodType: "get",
        dioHeaders: headers,
        context: context!,
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioBody: null,
      );
      if (secondaryResponse['status'] == false) {
        debugPrint("$secondaryResponse");
        emit(GetAllSecondaryErrorState());
      } else {
        debugPrint("$secondaryResponse");
        secondaryModel = AllSecondaryModel.fromJson(secondaryResponse);

        emit(GetAllSecondarySuccessState());
      }
    } catch (error) {
      debugPrint("catch error is ${error.toString()}");
    }
  }

  Map<dynamic, dynamic>? saveResponse;
  SaveModel? saveModel;
  Future<void> saveSecondaryCourse({
    required BuildContext? context,
    required int id,
    required int? index1,
    required int? index2,
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
        secondaryModel!.data[index1!].courses[index2!].isFavorite =
            !secondaryModel!.data[index1].courses[index2].isFavorite;
        emit(SaveCourseSuccessState());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  Map<dynamic, dynamic>? searchCourseResponse;
  SearchModel? searchSecondaryModel;
  bool? isSearch = false;
  Future<void> searchSecondary({
    required BuildContext? context,
    required String secondaryName,
    required int id,
  }) async {
    print(id);
    print(secondaryName);
    emit(SearchCourseLoadingState());
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        if(CacheHelper.getData(key: AppCached.token)!=null )
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      searchCourseResponse = await myDio(
          url: "${AllAppApiConfig.baseUrl}"
              "${AllAppApiConfig.searchUniversity}",
          methodType: "get",
          dioBody: {
            'search': secondaryName,
            'stage_id': id,
          },
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if (searchCourseResponse!['status'] == false) {
        debugPrint(searchCourseResponse.toString());
        emit(SearchCourseErrorState());
      } else {
        debugPrint(searchCourseResponse!.toString());
        searchSecondaryModel = SearchModel.fromJson(searchCourseResponse!);
        emit(SearchCourseSuccessState());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  Map<dynamic, dynamic>? saveSearchedResponse;
  Future<void> saveSearchedSecondaryCourse({
    required BuildContext? context,
    required int id,
    required int? index1,
    required int? index2,
  }) async {
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      saveSearchedResponse = await myDio(
          url: "${AllAppApiConfig.baseUrl}"
              "${AllAppApiConfig.save}"
              "${id.toString()}",
          methodType: "get",
          dioBody: null,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if (saveSearchedResponse!['status'] == false) {
        debugPrint(saveSearchedResponse.toString());
        emit(SaveCourseErrorState());
      } else {
        debugPrint(saveSearchedResponse!.toString());
        saveModel = SaveModel.fromJson(saveSearchedResponse!);
        searchSecondaryModel!.data![index1!].courses[index2!].isFavorite =
            !searchSecondaryModel!.data![index1].courses[index2].isFavorite;
        emit(SaveCourseSuccessState());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }
}

List<String> names = [
  LocaleKeys.PrimarySecondary.tr(),
  LocaleKeys.SecondSecondary.tr(),
  LocaleKeys.ThirdSecondary.tr()
];
