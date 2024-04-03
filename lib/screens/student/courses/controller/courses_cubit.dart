import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/custom_toast.dart';
import '../../../../core/local/app_cached.dart';
import '../../../../core/local/global_config.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/local/cache_helper.dart';
import '../../../../shared/remote/dio.dart';
import '../model/current_courses_model.dart';
import '../model/previous-courses_model.dart';
import 'courses_states.dart';

class CoursesCubit extends Cubit<CoursesStates> {
  CoursesCubit() : super(CoursesInitialState());

  static CoursesCubit get(context) => BlocProvider.of(context);

  List<String> names = [
    LocaleKeys.CurrentCourses.tr(),
    LocaleKeys.CoursesCompleted.tr()
  ];

  int currentIndex = 0;

  void changeBottom(int index) {
    currentIndex = index;
    emit(ChangeBottomState());
  }

  Map<dynamic, dynamic>? currentCoursesResponse;
  CurrentCoursesModel? currentCourseModel;
  List<CurrentData>? currentCourses = [];

  Future<void> getCurrentCourses(context) async {
    emit(CurrentCoursesLoadingState());
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}',
      };
      currentCoursesResponse = await myDio(
        dioHeaders: headers,
        context: context!,
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioBody: null,
        url: AllAppApiConfig.baseUrl + AllAppApiConfig.getCurrentCourses,
        methodType: "get",
      );
      if (currentCoursesResponse!['status'] == false) {
        showSnackBar(
            context: context,
            text: currentCoursesResponse!['message'],
            success: false);
        debugPrint('>>>>>>>>>>>>>> Current Courses Failure >>>>>>>>>');
        emit(CurrentCoursesFailureState());
        print("status is ${currentCoursesResponse!['status']}");
      } else {
        // showSnackBar(context: context, text: currentCoursesResponse!['message'], success: true);
        debugPrint(currentCoursesResponse.toString());
        currentCourseModel =
            CurrentCoursesModel.fromJson(currentCoursesResponse!);
        currentCourses!.addAll(currentCourseModel!.data!);
        await getPreviousCourses(context);
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  Map<dynamic, dynamic>? prevCoursesResponse;
  PreviousCoursesModel? prevCoursesModel;
  List<Data>? prevCourses = [];

  Future<void> getPreviousCourses(context) async {
    emit(PreviousCoursesLoadingState());
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}',
      };
      prevCoursesResponse = await myDio(
        dioHeaders: headers,
        context: context!,
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioBody: null,
        url: AllAppApiConfig.baseUrl + AllAppApiConfig.getPreviousCourses,
        methodType: "get",
      );
      if (prevCoursesResponse!['status'] == false) {
        showSnackBar(
            context: context,
            text: prevCoursesResponse!['message'],
            success: false);
        debugPrint('>>>>>>>>>>>>>> Prev Courses Failure >>>>>>>>>');
        emit(PreviousCoursesFailureState());
        print("status is ${prevCoursesResponse!['status']}");
      } else {
        //  showSnackBar(context: context, text: prevCoursesResponse!['message'], success: true);
        debugPrint(prevCoursesResponse.toString());
        print('prev courses success');
        prevCoursesModel = PreviousCoursesModel.fromJson(prevCoursesResponse!);
        prevCourses!.addAll(prevCoursesModel!.data!);
        // prevCoursesModel!.data!.forEach((element) {
        //   prevCourses!.add(element);
        // });
        emit(CurrentCoursesSuccessState());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }
}
