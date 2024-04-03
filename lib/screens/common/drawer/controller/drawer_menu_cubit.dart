import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:private_courses/screens/common/auth/login/view/login_view.dart';
import '../../../../components/custom_toast.dart';
import '../../../../components/my_navigate.dart';
import '../../../../core/local/app_cached.dart';
import '../../../../core/local/global_config.dart';
import '../../../../shared/local/cache_helper.dart';
import '../../../../shared/remote/dio.dart';
import 'drawer_menu_states.dart';

class DrawerMenuCubit extends Cubit<DrawerMenuStates> {
  DrawerMenuCubit() : super(DrawerMenuInitialState());

  static DrawerMenuCubit get(context) => BlocProvider.of(context);

  /// Log Out
  Map<dynamic, dynamic>? logOutResponse;

  Future<void> logOut({required BuildContext context}) async {
    debugPrint('>>>>>>>>>>>>>> Log Out Loading >>>>>>>>>');

    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };

      logOutResponse = await myDio(
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioHeaders: headers,
        url: AllAppApiConfig.baseUrl + AllAppApiConfig.logout,
        methodType: 'get',
        dioBody: null,
        context: context,
      );

      if (logOutResponse!['status'] == false) {
        showSnackBar(
            context: context, text: logOutResponse!['message'], success: false);
        debugPrint('>>>>>>>>>>>>>> Log Out Find Error >>>>>>>>>');
        emit(LogOutError());
      } else {
        showSnackBar(
            context: context, text: logOutResponse!['message'], success: true);
        debugPrint(logOutResponse.toString());
        debugPrint('>>>>>>>>>>>>>> Log Out Success >>>>>>>>>');
        removeDataFromShared();
        emit(LogOutSuccess());
        navigateAndFinish(context: context, widget: const LoginScreen());
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    debugPrint('>>>>>>>>>>>>>> Finishing Log Out Ok >>>>>>>>>');
  }

  removeDataFromShared() async {
    debugPrint('Start removing data');
    CacheHelper.removeData(AppCached.userId);
    CacheHelper.removeData(AppCached.loginType);
    CacheHelper.removeData(AppCached.token);

    debugPrint('Finish removing data');
  }
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn =  GoogleSignIn();


  Future<void> signOutGmail(context)async{
    // Sign out with firebase
    await firebaseAuth.signOut();
    // Sign out with google
    await googleSignIn.signOut();
    logOut(context: context);
  }
  // Future<void> signOutFaceBook(context)async{
  //   // Sign out with facebook
  //   print("1");
  //   await FacebookAuth.instance.logOut();
  //     logOut(context: context);
  //   print("2");
  // }

}
