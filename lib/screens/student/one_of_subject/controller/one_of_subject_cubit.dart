import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/local/app_cached.dart';
import '../../../../core/local/global_config.dart';
import '../../../../shared/local/cache_helper.dart';
import '../../../../shared/remote/dio.dart';
import '../../all_secondary/model/search_model.dart';
import '../../saves/model/save_model.dart';
import '../model/one_of_subject_model.dart';
import '../model/search_subject_model.dart';
import 'one_of_subject_states.dart';

class OneOfSubjectCubit extends Cubit<OneOfSubjectStates> {
  OneOfSubjectCubit() : super(OneOfSubjectInitialState());

  static OneOfSubjectCubit get(context) => BlocProvider.of(context);
  var searchCtrl = TextEditingController();
  Map<dynamic, dynamic> oneOfSubjectResponse = {};
  OneOfSubjectModel? oneOfSubjectModel;
  Future<void> getOneOfSubjectCourses(BuildContext? context, dynamic id) async {
    emit(GetOneOfSubjectLoadingState());
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        if(CacheHelper.getData(key: AppCached.token)!=null )
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}',
      };
      oneOfSubjectResponse = await myDio(
        url: AllAppApiConfig.baseUrl +
            AllAppApiConfig.getCoursesFromCollege +
            "/$id",
        methodType: "get",
        dioHeaders: headers,
        context: context!,
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioBody: null,
      );
      if (oneOfSubjectResponse['status'] == false) {
        debugPrint("$oneOfSubjectResponse");
        emit(GetOneOfSubjectErrorState());
      } else {
        debugPrint("$oneOfSubjectResponse");
        oneOfSubjectModel = OneOfSubjectModel.fromJson(oneOfSubjectResponse);

        emit(GetOneOfSubjectSuccessState());
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
        if(CacheHelper.getData(key: AppCached.token)!=null )
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
        oneOfSubjectModel!.data[index!].isFavorite =
            !oneOfSubjectModel!.data[index].isFavorite;
        emit(SaveCourseSuccessState());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  Map<dynamic, dynamic>? searchCourseResponse;
  SearchSubjectModel? searchModel;
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
        searchModel = SearchSubjectModel.fromJson(searchCourseResponse!);
        emit(SearchCourseSuccessState());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  Map<dynamic, dynamic>? saveSearchCourseResponse;
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
      saveSearchCourseResponse = await myDio(
          url: "${AllAppApiConfig.baseUrl}"
              "${AllAppApiConfig.save}"
              "${id.toString()}",
          methodType: "get",
          dioBody: null,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if (saveSearchCourseResponse!['status'] == false) {
        debugPrint(saveSearchCourseResponse.toString());
        emit(SaveCourseErrorState());
      } else {
        debugPrint(saveSearchCourseResponse!.toString());
        saveModel = SaveModel.fromJson(saveSearchCourseResponse!);
        searchModel!.data![index!].isFavorite =
            !searchModel!.data![index].isFavorite;
        emit(SaveCourseSuccessState());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }
}
