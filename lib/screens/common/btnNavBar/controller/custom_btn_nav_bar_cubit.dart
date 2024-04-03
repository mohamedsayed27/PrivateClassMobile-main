import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/core/local/global_config.dart';
import 'package:private_courses/screens/common/btnNavBar/controller/custom_btn_nav_bar_states.dart';
import 'package:private_courses/screens/common/edit_profile/model/profile_model.dart';
import 'package:private_courses/screens/student/cart/view/cart_view.dart';
import 'package:private_courses/screens/student/courses/view/courses_view.dart';
import 'package:private_courses/screens/student/home/view/home_view.dart';
import 'package:private_courses/screens/student/online_store/view/online_store_view.dart';
import 'package:private_courses/screens/teacher/courses_teacher/view/courses_teacher_view.dart';
import 'package:private_courses/screens/teacher/home_teacher/view/home_teacher_view.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import 'package:private_courses/shared/remote/dio.dart';
import '../../contact_us/view/contact_us_view.dart';
import '../../profile/view/profile_screen.dart';

class CustomBtnNavBarCubit extends Cubit<CustomBtnNavBarStates> {
  CustomBtnNavBarCubit() : super(CustomBtnNavBarInitialState());

  static CustomBtnNavBarCubit get(context) => BlocProvider.of(context);


  final btnWidget1 = [
    HomeScreen(),
    const CoursesScreen(),
    OnlineStoreScreen(),
    const CartScreen(),
    const ContactUsScreen()
  ];
  final btnWidget2 = [
    const HomeTeacherScreen(),
    const CoursesTeacherScreen(),
    const ContactUsScreen(),
    ProfileScreen(isTeacher: CacheHelper.getData(key: AppCached.role),isDrawer: false),
  ];

  int? currentIndex ;


  changePage({required int page , required BuildContext context}) {
    debugPrint(page.toString());
    currentIndex = page;
      debugPrint(currentIndex.toString());
      getProfile(context: context) ;
      emit(ChangeBottomNavBarState());
  }
  getPage(int page){
    currentIndex=page;
    emit(ChangeBottomNavBarState());
  }
 /// Get User Auth
  ProfileModel? profileModel;
  Map<dynamic, dynamic>? profileResponse;
  Future<void> getProfile({required BuildContext context}) async {
    debugPrint('>>>>>>>>>>>>>> Get Profile Loading data <<<<<<<<<<<<<');
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      profileResponse = await myDio(
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          dioHeaders: headers,
          url: AllAppApiConfig.baseUrl + AllAppApiConfig.userProfile,
          methodType: 'get',
          context: context,
          dioBody: null);
      if (profileResponse!['status'] == false) {
        debugPrint(profileResponse.toString());
        debugPrint(">>>>>>>>>>>>>>>>> Get Profile Find Error <<<<<<<<<<<<<<<<<<<<<<<");
        emit(GetProfileErrorState());
      } else {
        debugPrint(profileResponse.toString());
        profileModel = ProfileModel.fromJson(profileResponse!);
        debugPrint('>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get Profile Successes <<<<<<<<<<<<<<<<<<<<<<<<<');
        saveDataToShared(profileModel!.data!);
        emit(GetProfileSuccessState());
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    debugPrint('>>>>>>>>>>>>>> Finishing Getting Profile data Ok >>>>>>>>>');
  }


  saveDataToShared(Data user) async {
    debugPrint('Start Saving For Change Pass data');
    CacheHelper.saveData(AppCached.stageId, user.stageId);
    CacheHelper.saveData(AppCached.subjectId, user.subjectId);
    CacheHelper.saveData(AppCached.name, user.name);
    CacheHelper.saveData(AppCached.cartCount, user.cartCount);
    CacheHelper.saveData(AppCached.subject, user.subject);
    CacheHelper.saveData(AppCached.email, user.email);
    CacheHelper.saveData(AppCached.phone, user.phone);
    CacheHelper.saveData(AppCached.pio, user.pio);
    CacheHelper.saveData(AppCached.phoneKey, user.phoneKey);
    CacheHelper.saveData(AppCached.image, user.photo);
    CacheHelper.saveData(AppCached.isNotify, user.isNotifiy);
    CacheHelper.saveData(AppCached.role, user.role);
    CacheHelper.saveData(AppCached.notifyCount, user.notificationCount);
    debugPrint('Finish Saving For Change Pass data');
  }

}