import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/local/app_cached.dart';
import '../../../../core/local/global_config.dart';
import '../../../../shared/local/cache_helper.dart';
import '../../../../shared/remote/dio.dart';
import '../model/courses_teacher_model.dart';
import 'courses_teacher_states.dart';

class CoursesTeacherCubit extends Cubit<CoursesTeacherStates> {
  CoursesTeacherCubit() : super(CoursesTeacherInitialState());

  static CoursesTeacherCubit get(context) => BlocProvider.of(context);


  Map<dynamic, dynamic>? getCourserTeacherResponse;
  CoursesTeacherModel? getCourserTeacherModel;

  Future<void> getAllCourserTeacher(context)async{
    emit(CoursesTeacherLoadingState());
    try{
      Map<String, dynamic> headers={
        'Accept': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      getCourserTeacherResponse=await myDio(
          context: context,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          dioHeaders: headers,
          dioBody: null,
          url:AllAppApiConfig.baseUrl + AllAppApiConfig.coursesTeacher,
          methodType: 'get');
      if(getCourserTeacherResponse!['status']== false){
        print('get Courses Failed');
        emit(CoursesTeacherFailureState());
      }
      else{
        print('get Courses Successes');
        getCourserTeacherModel = CoursesTeacherModel.fromJson(getCourserTeacherResponse!);
        emit(CoursesTeacherSuccessState());
      }
    }
    catch (e, s) {
      print(e);
      print(s);
    }
  }






}