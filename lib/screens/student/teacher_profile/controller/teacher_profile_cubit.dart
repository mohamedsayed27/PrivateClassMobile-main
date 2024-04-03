import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/generated/locale_keys.g.dart';
import 'package:private_courses/screens/student/teacher_profile/controller/teacher_profile_states.dart';

import '../../../../core/local/app_cached.dart';
import '../../../../core/local/global_config.dart';
import '../../../../shared/local/cache_helper.dart';
import '../../../../shared/remote/dio.dart';
import '../../saves/model/save_model.dart';
import '../model/teacher_profile_model.dart';

class TeacherProfileCubit extends Cubit<TeacherProfileStates> {
  TeacherProfileCubit() : super(TeacherProfileInitialState());

  static TeacherProfileCubit get(context) => BlocProvider.of(context);

  Map<dynamic, dynamic>? teacherProfileResponse;
  TeacherProfileModel? teacherProfileModel;

  Future<void> getTeacherProfile(
      {required BuildContext context, required int id}) async {
    emit(TeacherProfileLoadingState());
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
      };
      teacherProfileResponse = await myDio(
        dioHeaders: headers,
        context: context,
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioBody: null,
        url:
            '${AllAppApiConfig.baseUrl}${AllAppApiConfig.getTeacherProfile}$id',
        methodType: "get",
      );
      if (teacherProfileResponse!['status'] == false) {
        emit(TeacherProfileFailureState());
        print("status is ${teacherProfileResponse!['status']}");
      } else {
        print('get teacher profile success');
        teacherProfileModel =
            TeacherProfileModel.fromJson(teacherProfileResponse!);
        emit(TeacherProfileSuccessState());
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
    required int index,
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
        emit(SaveTeacherCourseError());
      } else {
        debugPrint(saveResponse!.toString());
        saveModel = SaveModel.fromJson(saveResponse!);
        teacherProfileModel!.data!.courses![index].isFavorite =
            !teacherProfileModel!.data!.courses![index].isFavorite!;
        emit(SaveTeacherCourseSuccess());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }
}
