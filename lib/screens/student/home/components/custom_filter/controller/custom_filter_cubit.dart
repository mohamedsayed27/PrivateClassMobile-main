import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/screens/student/saves/model/save_model.dart';

import '../../../../../../core/local/app_cached.dart';
import '../../../../../../core/local/global_config.dart';
import '../../../../../../shared/local/cache_helper.dart';
import '../../../../../../shared/remote/dio.dart';
import '../model/colleges_model.dart';
import '../model/filter_courses_model.dart';
import '../model/stages_model.dart';
import '../model/university_model.dart';
import 'custom_filter_states.dart';

class CustomFilterCubit extends Cubit<CustomFilterStates> {
  CustomFilterCubit() : super(CustomFilterInitialState());

  static CustomFilterCubit get(context) => BlocProvider.of(context);

  int selectedValue = 100;

  bool isFiltered = false;

  bool isPicked = false;

  String? stageId;

  String? universityId;

  String? collegeId;

  void radioCheckVal(value) {
    selectedValue = value;
    emit(RadioCheckState());
  }

  Map<dynamic, dynamic> stagesResponse = {};
  StagesModel? stagesModel;

  Future<void> getStages(BuildContext? context) async {
    emit(GetStagesLoadingState());
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        if(CacheHelper.getData(key: AppCached.token)!=null )
          'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      stagesResponse = await myDio(
        url: AllAppApiConfig.baseUrl + AllAppApiConfig.stages,
        methodType: "get",
        dioHeaders: headers,
        context: context!,
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioBody: null,
      );
      if (stagesResponse['status'] == false) {
        debugPrint("$stagesResponse");
        emit(GetStagesErrorState(stagesResponse["message"]));
      } else {
        debugPrint("$stagesResponse");
        stagesModel = StagesModel.fromJson(stagesResponse);
        emit(GetStagesSuccessState());
      }
    } catch (error) {
      debugPrint("catch error is ${error.toString()}");
    }
  }

  Map<dynamic, dynamic> universityResponse = {};
  UniversityModel? universityModel;
  Future<void> getUniversity(BuildContext? context, dynamic id) async {
    emit(GetUniversityLoadingState());
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        if(CacheHelper.getData(key: AppCached.token)!=null )
          'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      universityResponse = await myDio(
        url: "${AllAppApiConfig.baseUrl}${AllAppApiConfig.university}/$id",
        methodType: "get",
        dioHeaders: headers,
        context: context!,
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioBody: null,
      );
      if (universityResponse['status'] == false) {
        debugPrint("$universityResponse");
        emit(GetUniversityErrorState());
      } else {
        debugPrint("$universityResponse");
        universityModel = UniversityModel.fromJson(universityResponse);
        emit(GetUniversitySuccessState());
      }
    } catch (error) {
      debugPrint("catch error is ${error.toString()}");
    }
  }

  Map<dynamic, dynamic> collegesResponse = {};
  CollegesModel? collegesModel;

  Future<void> getColleges(BuildContext? context, dynamic id) async {
    emit(GetCollegesLoadingState());
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        if(CacheHelper.getData(key: AppCached.token)!=null )
          'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      collegesResponse = await myDio(
        url: "${AllAppApiConfig.baseUrl}${AllAppApiConfig.colleges}/$id",
        methodType: "get",
        dioHeaders: headers,
        context: context!,
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioBody: null,
      );
      if (collegesResponse['status'] == false) {
        debugPrint("$collegesResponse");
        emit(GetCollegesErrorState());
      } else {
        debugPrint("$collegesResponse");
        collegesModel = CollegesModel.fromJson(collegesResponse);
        emit(GetCollegesSuccessState());
      }
    } catch (error) {
      debugPrint("catch error is ${error.toString()}");
    }
  }

  Map<dynamic, dynamic> filterCourseResponse = {};
  FilterCoursesModel? filterCoursesModel;

  Future<void> filterCourses(BuildContext? context,
      {required String stageId,
      required String universityId,
      required String collegeId}) async {
    emit(FilterCoursesLoadingState());

    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        if(CacheHelper.getData(key: AppCached.token)!=null )
          'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      filterCourseResponse = await myDio(
        url: AllAppApiConfig.baseUrl + AllAppApiConfig.filterCourses,
        methodType: "post",
        dioHeaders: headers,
        context: context!,
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioBody: {
          "stage_id": stageId,
          "university_id": universityId,
          "college_id": collegeId
        },
      );
      if (filterCourseResponse['status'] == false) {
        debugPrint("$filterCourseResponse");
        emit(FilterCoursesErrorState());
      }
      debugPrint("$filterCourseResponse");
      filterCoursesModel = FilterCoursesModel.fromJson(filterCourseResponse);
      debugPrint("$filterCoursesModel");
      emit(FilterCoursesSuccessState());
    } catch (error) {
      debugPrint("catch error is ${error.toString()}");
    }
  }

  Map<dynamic, dynamic>? saveCourseResponse;
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
      saveCourseResponse = await myDio(
          url: AllAppApiConfig.baseUrl + AllAppApiConfig.save + id.toString(),
          methodType: "get",
          dioBody: null,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if (saveCourseResponse!['status'] == false) {
        debugPrint(saveCourseResponse.toString());
        emit(SaveCourseErrorState());
      } else {
        debugPrint(saveCourseResponse!.toString());
        saveModel = SaveModel.fromJson(saveCourseResponse!);
        filterCoursesModel!.data[index!].isFavorite =
            !filterCoursesModel!.data[index].isFavorite;
        emit(SaveCourseSuccessState());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  String? dropDownValueOne;
  void changeDropDownOne(val) {
    dropDownValueOne = val;
    emit(ChangeDropDown());
  }

  String? dropDownValueTwo;
  void changeDropDownTwo(val) {
    dropDownValueTwo = val;
    emit(ChangeDropDownTwo());
  }

  String? dropDownValueThree;
  void changeDropDownThree(val) {
    dropDownValueThree = val;
    emit(ChangeDropDown());
  }

  String? dropDownValueFour;
  void changeDropDownFour(val) {
    dropDownValueFour = val;
    emit(ChangeDropDown());
  }
}
