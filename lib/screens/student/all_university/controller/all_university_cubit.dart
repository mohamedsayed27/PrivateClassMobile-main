import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/local/app_cached.dart';
import '../../../../core/local/global_config.dart';
import '../../../../shared/local/cache_helper.dart';
import '../../../../shared/remote/dio.dart';

import '../../saves/model/save_model.dart';
import '../model/search_model.dart';
import '../model/university_all_model.dart';
import 'all_university_states.dart';

class AllUniversityCubit extends Cubit<AllUniversityStates> {
  AllUniversityCubit() : super(AllUniversityInitialState());

  static AllUniversityCubit get(context) => BlocProvider.of(context);

  var searchCtrl = TextEditingController();

  Map<dynamic, dynamic> universityResponse = {};
  UniversityAllModel? universityAllModel;
  Future<void> getAllUniversity(BuildContext? context, dynamic id) async {
    emit(GetAllUniversityLoadingState());
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        if(CacheHelper.getData(key: AppCached.token)!=null )
          'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      universityResponse = await myDio(
        url: AllAppApiConfig.baseUrl +
            AllAppApiConfig.getAllUniversities +
            "/$id",
        methodType: "get",
        dioHeaders: headers,
        context: context!,
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioBody: null,
      );
      print(AllAppApiConfig.baseUrl +
          AllAppApiConfig.getAllUniversities +
          "/$id");
      if (universityResponse['status'] == false) {
        debugPrint("$universityResponse");
        emit(GetAllUniversityErrorState());
      } else {
        debugPrint("$universityResponse");
        universityAllModel = UniversityAllModel.fromJson(universityResponse);

        emit(GetAllUniversitySuccessState());
      }
    } catch (error) {
      debugPrint("catch error is ${error.toString()}");
    }
  }

  Map<dynamic, dynamic>? saveResponse;
  SaveModel? saveModel;
  Future<void> saveUniversityCourse({
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
        universityAllModel!.data[index1!].courses[index2!].isFavorite =
            !universityAllModel!.data[index1].courses[index2].isFavorite;
        emit(SaveCourseSuccessState());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  Map<dynamic, dynamic>? searchCourseResponse;
  SearchModel? searchModel;
  bool? isSearch = false;
  Future<void> searchCourse({
    required BuildContext? context,
    required String universityName,
    required int id,
  }) async {
    emit(GetAllUniversityLoadingState());
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
            'search': universityName,
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
        searchModel = SearchModel.fromJson(searchCourseResponse!);
        emit(SearchCourseSuccessState());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  Map<dynamic, dynamic>? saveSearchedResponse;
  Future<void> saveSearchedUniversityCourse({
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
        searchModel!.data![index1!].courses[index2!].isFavorite =
            !searchModel!.data![index1].courses[index2].isFavorite;
        emit(SaveCourseSuccessState());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }
}
