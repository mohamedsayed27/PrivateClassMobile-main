import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/screens/student/one_of_faculty/model/one_of_faculty_model.dart';

import '../../../../core/local/app_cached.dart';
import '../../../../core/local/global_config.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/local/cache_helper.dart';
import '../../../../shared/remote/dio.dart';
import '../../home/model/search_model.dart';
import '../../saves/model/save_model.dart';
import 'one_of_faculty_states.dart';

class OneOfFacultyCubit extends Cubit<OneOfFacultyStates> {
  OneOfFacultyCubit() : super(OneOfFacultyInitialState());

  static OneOfFacultyCubit get(context) => BlocProvider.of(context);

  var searchCtrl = TextEditingController();

  Map<dynamic, dynamic> oneOfFacultyResponse = {};
  OneOfFacultyModel? oneOfFacultyModel;
  Future<void> getOneOfFacultyCourses(BuildContext? context, dynamic id) async {
    emit(GetOneOfFacultyLoadingState());
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        if(CacheHelper.getData(key: AppCached.token)!=null )
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}',
      };
      oneOfFacultyResponse = await myDio(
        url: AllAppApiConfig.baseUrl +
            AllAppApiConfig.getCoursesFromCollege +
            "/$id",
        methodType: "get",
        dioHeaders: headers,
        context: context!,
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioBody: null,
      );
      if (oneOfFacultyResponse['status'] == false) {
        debugPrint("$oneOfFacultyResponse");
        emit(GetOneOfFacultyErrorState());
      } else {
        debugPrint("$oneOfFacultyResponse");
        oneOfFacultyModel = OneOfFacultyModel.fromJson(oneOfFacultyResponse);

        emit(GetOneOfFacultySuccessState());
      }
    } catch (error) {
      debugPrint("catch error is ${error.toString()}");
    }
  }

  Map<dynamic, dynamic>? saveResponse;
  SaveModel? saveModel;
  Future<void> saveCourse(
      {required BuildContext? context,
      required int id,
      required int? index}) async {
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
        oneOfFacultyModel!.data[index!].isFavorite =
            !oneOfFacultyModel!.data[index].isFavorite;
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
    required String courseName,
    required int id,
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
      searchCourseResponse = await myDio(
          url: "${AllAppApiConfig.baseUrl}"
              "${AllAppApiConfig.searchCourse}",
          methodType: "get",
          dioBody: {
            'search': courseName,
            'id': id,
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
  Future<void> saveSearchedCourse(
      {required BuildContext? context,
      required int id,
      required int? index}) async {
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
      if (saveSearchedResponse!['status'] == false) {
        debugPrint(saveSearchedResponse.toString());
        emit(SaveCourseErrorState());
      } else {
        debugPrint(saveResponse!.toString());
        saveModel = SaveModel.fromJson(saveSearchedResponse!);
        searchModel!.data![index!].isFavorite = !searchModel!.data![index].isFavorite!;
        emit(SaveCourseSuccessState());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }
}
