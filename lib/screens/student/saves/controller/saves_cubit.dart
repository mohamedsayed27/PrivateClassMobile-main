import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/core/local/global_config.dart';
import 'package:private_courses/screens/student/saves/model/save_model.dart';
import 'package:private_courses/screens/student/saves/model/savesModel.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import 'package:private_courses/shared/remote/dio.dart';
import 'saves_states.dart';

class SavesCubit extends Cubit<SavesStates> {
  SavesCubit() : super(InitialSaveStates());

  static SavesCubit get(context) => BlocProvider.of(context);

  Map<dynamic, dynamic>? savesResponse;
  SavesModel? savesModel;
  Future<void> fetchSaves({required BuildContext? context}) async {
    emit(LoadingState());
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}',
      };
      savesResponse = await myDio(
          url: AllAppApiConfig.baseUrl + AllAppApiConfig.saves,
          methodType: "get",
          dioBody: null,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if (savesResponse!['status'] == false) {
        debugPrint(savesResponse.toString());
        emit(FieldState());
      } else {
        debugPrint(savesResponse!.toString());
        savesModel = SavesModel.fromJson(savesResponse!);
        emit(SuccessState());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  Map<dynamic, dynamic>? saveResponse;
  SaveModel? saveModel;
  Future<void> unSave(
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
          url: AllAppApiConfig.baseUrl + AllAppApiConfig.save + id.toString(),
          methodType: "get",
          dioBody: null,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if (saveResponse!['status'] == false) {
        debugPrint(saveResponse.toString());
        emit(FieldSaveState());
      } else {
        debugPrint(saveResponse!.toString());
        saveModel = SaveModel.fromJson(saveResponse!);
        savesModel!.data!.removeWhere((element) => element.id == id);
        emit(SuccessSaveState());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }
}
