import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../components/style/images.dart';
import '../../../../core/local/app_cached.dart';
import '../../../../core/local/global_config.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/local/cache_helper.dart';
import '../../../../shared/remote/dio.dart';
import '../model/on_boarding_model.dart';
import 'on_boarding_states.dart';

class OnBoardingCubit extends Cubit<OnBoardingStates>{
  OnBoardingCubit(): super(OnBoardingInitialState());

  static OnBoardingCubit get(context)=> BlocProvider.of(context);

  int currentIndex=0;

  Map<dynamic,dynamic>? onBoardingResponse;
  OnBoardingModel? onBoardingModel;

  Future<void> onBoardingDate({required context})async{
    emit(OnBoardingLoadingState());
    try{
      Map <String , dynamic> headers = {
        'Accept': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
      };
      onBoardingResponse = await myDio(
          url: AllAppApiConfig.baseUrl + AllAppApiConfig.introduction,
          methodType: "get",
          dioBody: null,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if(onBoardingResponse!['status']==false){
        print(onBoardingResponse);
        emit(OnBoardingFailureState());
      }
      else {
        onBoardingModel = OnBoardingModel.fromJson(onBoardingResponse!);
        print(onBoardingModel);
        emit(OnBoardingSuccessState());
      }
    }catch(e,s){
      print(e);
      print(s);
    }
  }

  void changeIndex(index){
    currentIndex=index;
    emit(OnBoardingChangeState());
  }
}