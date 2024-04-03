import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/local/app_cached.dart';
import '../../../../core/local/global_config.dart';
import '../../../../shared/local/cache_helper.dart';
import '../../../../shared/remote/dio.dart';
import '../../all_secondary_department/model/search_model.dart';
import '../../saves/model/save_model.dart';
import '../model/all_university_department_model.dart';
import 'all_university_department_states.dart';

class AllUniversityDepartmentCubit
    extends Cubit<AllUniversityDepartmentStates> {
  AllUniversityDepartmentCubit() : super(AllUniversityDepartmentInitialState());
  static AllUniversityDepartmentCubit get(context) => BlocProvider.of(context);

  var searchCtrl = TextEditingController();

  Map<dynamic, dynamic> departmentResponse = {};
  AllUniversityDepartmentModel? allUniversityDepartmentModel;

  Future<void> getAllUniversityDepartment(
      BuildContext? context, dynamic id) async {
    emit(GetAllUniversityDepartmentLoadingState());
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        if(CacheHelper.getData(key: AppCached.token)!=null )
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}',
      };
      departmentResponse = await myDio(
        url: AllAppApiConfig.baseUrl + AllAppApiConfig.getAllColleges + "/$id",
        methodType: "get",
        dioHeaders: headers,
        context: context!,
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioBody: null,
      );
      if (departmentResponse['status'] == false) {
        debugPrint("$departmentResponse");
        emit(GetAllUniversityDepartmentErrorState());
      } else {
        debugPrint("$departmentResponse");
        allUniversityDepartmentModel =
            AllUniversityDepartmentModel.fromJson(departmentResponse);

        emit(GetAllUniversityDepartmentSuccessState());
      }
    } catch (error) {
      debugPrint("catch error is ${error.toString()}");
    }
  }

  Map<dynamic, dynamic>? saveResponse;
  SaveModel? saveModel;
  Future<void> saveCourse({
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
        allUniversityDepartmentModel!
                .data[index1!].courses[index2!].isFavorite =
            !allUniversityDepartmentModel!
                .data[index1].courses[index2].isFavorite;
        emit(SaveCourseSuccessState());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  Map<dynamic, dynamic>? searchCollegeResponse;
  SearchModel? searchModel;
  bool? isSearch = false;
  Future<void> searchCollege({
    required BuildContext? context,
    required String courseName,
    required int collegeId,
  }) async {
    emit(SearchCourseLoadingState());
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        if(CacheHelper.getData(key: AppCached.token)!=null )
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      searchCollegeResponse = await myDio(
          url: "${AllAppApiConfig.baseUrl}"
              "${AllAppApiConfig.searchCollege}",
          methodType: "get",
          dioBody: {
            'search': courseName,
            'id': collegeId,
          },
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if (searchCollegeResponse!['status'] == false) {
        debugPrint(searchCollegeResponse.toString());
        emit(SearchCourseErrorState());
      } else {
        debugPrint(searchCollegeResponse!.toString());
        searchModel = SearchModel.fromJson(searchCollegeResponse!);
        emit(SearchCourseSuccessState());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  Map<dynamic, dynamic>? saveSearchCollegeDeptResponse;
  Future<void> saveSearchCollegeDepartment({
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
      saveSearchCollegeDeptResponse = await myDio(
          url: "${AllAppApiConfig.baseUrl}"
              "${AllAppApiConfig.save}"
              "${id.toString()}",
          methodType: "get",
          dioBody: null,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if (saveSearchCollegeDeptResponse!['status'] == false) {
        debugPrint(saveSearchCollegeDeptResponse.toString());
        emit(SaveCourseErrorState());
      } else {
        debugPrint(saveSearchCollegeDeptResponse!.toString());
        saveModel = SaveModel.fromJson(saveSearchCollegeDeptResponse!);
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
