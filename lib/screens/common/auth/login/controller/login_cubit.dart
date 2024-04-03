//import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' as fireAuth;
//import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:private_courses/components/custom_text.dart';
import 'package:private_courses/components/style/colors.dart';
import 'package:private_courses/components/style/size.dart';
import 'package:private_courses/screens/common/auth/login/model/login_model.dart';
import 'package:private_courses/screens/common/btnNavBar/view/custom_btn_nav_bar_view.dart';
import '../../../../../components/custom_toast.dart';
import '../../../../../components/device_id.dart';
import '../../../../../components/my_navigate.dart';
import '../../../../../core/local/app_cached.dart';
import '../../../../../core/local/global_config.dart';
import '../../../../../shared/local/cache_helper.dart';
import '../../../../../shared/remote/dio.dart';
import '../../../drawer/components/custom_zoom_drawer.dart';
import '../../confirm_register_by/view/confirm_register_by_view.dart';
import 'login_states.dart';
//import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  bool isSecure = true;

  void changeSecurePass() {
    isSecure = !isSecure;
    emit(SecurePassState());
  }

  String? token;

  getToken() async {
    token = await FirebaseMessaging.instance.getToken();
    debugPrint(token);
  }

  var formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  ///Login
  Map<dynamic, dynamic>? loginResponse;
  LoginModel? loginModel;

  Future<void> login({required BuildContext context}) async {
    await getToken();
    debugPrint(token);
    if (!formKey.currentState!.validate()) return;
    debugPrint('>>>>>>>>>>>>>> Login Loading >>>>>>>>>');
    emit(LoginLoadingState());

    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
      };
      final lang = CacheHelper.getData(key: AppCached.appLanguage);
      print("langggggggggg " + lang.toString());
      final formData = ({
        'email': emailController.text,
        'password': passController.text,
        'token_firebase': token,
        'device_id': await getId(),
      });

      debugPrint(formData.toString());

      loginResponse = await myDio(
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          dioHeaders: headers,
          url: AllAppApiConfig.baseUrl + AllAppApiConfig.login,
          methodType: 'post',
          dioBody: formData,
          context: context);
      if (loginResponse!['status'] == false) {
        debugPrint(loginResponse.toString());
        if (loginResponse!['data'] == null) {
          showSnackBar(
              context: context,
              text: loginResponse!['message'],
              success: false);
          emit(LoginErrorState());
        } else if (loginResponse!['data']['check'] == "student_not_active") {
          CacheHelper.saveData(
              AppCached.phone, loginResponse!['data']['phone']);
          CacheHelper.saveData(
              AppCached.email, loginResponse!['data']['email']);
          showSnackBar(
              context: context,
              text: loginResponse!['message'],
              success: false);
          debugPrint('>>>>>>>>>>>>>> Account Is Not Active !! >>>>>>>>>');
          navigateTo(context, ConfirmRegisterByScreen());
          emit(LoginErrorState());
        } else if (loginResponse!['data']['check'] == "teacher_not_active") {
          print("------------------------------------------------------");
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                Future.delayed(Duration(seconds: 3), () {
                  CacheHelper.sharedPreferences.clear();
                  CacheHelper.saveData(AppCached.role, "visitor");
                  CacheHelper.saveData(AppCached.appLanguage, lang);
                  navigatorPop(context);
                  navigateTo(
                      context,
                      CustomZoomDrawer(
                          mainScreen: CustomBtnNavBarScreen(
                              page: 0,
                              isTeacher:
                                  CacheHelper.getData(key: AppCached.role)),
                          isTeacher: CacheHelper.getData(key: AppCached.role)));
                });
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  content: CustomText(
                    text: loginResponse!['message'],
                    fontSize: AppFonts.t5,
                    color: AppColors.mainColor,
                    textAlign: TextAlign.center,
                  ),
                );
              });
          emit(LoginErrorState());
        }
      } else {
        showSnackBar(
            context: context, text: loginResponse!['message'], success: true);
        debugPrint(loginResponse.toString());
        loginModel = LoginModel.fromJson(loginResponse!);
        saveDataToShared(loginModel!.data!.user!, loginModel!.data!.token!);
        emit(LoginSuccessState());
        navigateAndFinish(
            context: context,
            widget: CustomZoomDrawer(
                mainScreen: CustomBtnNavBarScreen(
                    page: 0,
                    isTeacher: CacheHelper.getData(key: AppCached.role)),
                isTeacher: CacheHelper.getData(key: AppCached.role)));
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    debugPrint('>>>>>>>>>>>>>> Finishing Login Ok >>>>>>>>>');
  }

  saveDataToShared(EmailUser user, String token) async {
    debugPrint('Start Saving data');
    CacheHelper.saveData(AppCached.userId, user.id);
    CacheHelper.saveData(AppCached.stageId, user.stageId);
    CacheHelper.saveData(AppCached.subjectId, user.subjectId);
    CacheHelper.saveData(AppCached.cartCount, user.cartCount);
    CacheHelper.saveData(AppCached.subject, user.subject);
    CacheHelper.saveData(AppCached.name, user.name);
    CacheHelper.saveData(AppCached.email, user.email);
    CacheHelper.saveData(AppCached.phone, user.phone);
    CacheHelper.saveData(AppCached.pio, user.pio);
    CacheHelper.saveData(AppCached.phoneKey, user.phoneKey);
    CacheHelper.saveData(AppCached.image, user.photo);
    CacheHelper.saveData(AppCached.isNotify, user.isNotifiy);
    CacheHelper.saveData(AppCached.role, user.role);
    CacheHelper.saveData(AppCached.notifyCount, user.notificationCount);
    CacheHelper.saveData(AppCached.token, token);
    debugPrint('Finish Saving data');
  }

  ///  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* Login Gmail  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

  fireAuth.UserCredential? user;

  Future<void> signWitGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser!.authentication;
      if (googleAuth!.idToken != null && googleAuth.accessToken != null) {
        final credential = fireAuth.GoogleAuthProvider.credential(
            idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
        user = await fireAuth.FirebaseAuth.instance
            .signInWithCredential(credential);
        print(">>>>>>>>>>>>>>>>>>Finishing Sign Gmail <<<<<<<<<<<<<<<<<<<<<<<<");
      }
      await loginGoogle(context, googleUser.id);
    } on fireAuth.FirebaseAuthException catch (error) {
      print(error.toString());
      showSnackBar(text: error.toString(), success: false, context: context);
      emit(LoginGoogleFailureState());
    }
  }


  Map<dynamic, dynamic>? loginGoogleResponse;
  LoginModel? loginGoogleModel;

  Future<void> loginGoogle(context, id) async {
    emit(LoginGoogleLoadingState());
    await getToken();

    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
      };
      final lang = CacheHelper.getData(key: AppCached.appLanguage);
      print("rollllllllle " + lang.toString());
      final formData = ({
        'email': user!.user!.email,
        'name': user!.user!.displayName,
        'role': CacheHelper.getData(key: AppCached.role),
        if (user!.user!.photoURL != null) 'photo': user!.user!.photoURL,
        'uid': id,
      });
      print(formData);

      print(user!.user!.photoURL.toString() + " body");

      loginGoogleResponse = await myDio(
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioHeaders: headers,
        url: AllAppApiConfig.baseUrl + AllAppApiConfig.loginProvider,
        methodType: 'post',
        dioBody: formData,
        context: context,
      );
      print(loginGoogleResponse!);
      if (loginGoogleResponse!['data']['user']['approved'] == false) {
        print("------------------------------------------------------");
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              Future.delayed(Duration(seconds: 3), () {
                CacheHelper.sharedPreferences.clear();
                CacheHelper.saveData(AppCached.role, "visitor");
                CacheHelper.saveData(AppCached.appLanguage, lang);
                navigatorPop(context);
                navigateTo(
                    context,
                    CustomZoomDrawer(
                        mainScreen: CustomBtnNavBarScreen(
                            page: 0,
                            isTeacher:
                                CacheHelper.getData(key: AppCached.role)),
                        isTeacher: CacheHelper.getData(key: AppCached.role)));
              });
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                content: CustomText(
                  text: loginGoogleResponse!['message'],
                  fontSize: AppFonts.t5,
                  color: AppColors.mainColor,
                  textAlign: TextAlign.center,
                ),
              );
            });
        emit(LoginGoogleSuccessState());
      } else {
        showSnackBar(
            context: context,
            text: loginGoogleResponse!['message'],
            success: true);
        loginGoogleModel = LoginModel.fromJson(loginGoogleResponse!);
        saveDataGmailToShared(loginGoogleModel!.data!.user!, loginGoogleModel!.data!.token!);
        navigateAndFinish(
            context: context,
            widget: CustomZoomDrawer(
                mainScreen: CustomBtnNavBarScreen(
                    page: 0,
                    isTeacher: CacheHelper.getData(key: AppCached.role)),
                isTeacher: CacheHelper.getData(key: AppCached.role)));
        emit(LoginGoogleSuccessState());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  saveDataGmailToShared(EmailUser user, String userToken) async {
    print('Start Saving Gmail data');
    CacheHelper.saveData(AppCached.userId, user.id);
    CacheHelper.saveData(AppCached.image, user.photo);
    CacheHelper.saveData(AppCached.isNotify, user.isNotifiy);
    CacheHelper.saveData(AppCached.stageId, user.stageId);
    CacheHelper.saveData(AppCached.cartCount, user.cartCount);
    CacheHelper.saveData(AppCached.subjectId, user.subjectId);
    CacheHelper.saveData(AppCached.phone, user.phone);
    CacheHelper.saveData(AppCached.phoneKey, user.phoneKey);
    CacheHelper.saveData(AppCached.email, user.email);
    CacheHelper.saveData(AppCached.pio, user.pio);
    CacheHelper.saveData(AppCached.notifyCount, user.notificationCount);
    CacheHelper.saveData(AppCached.name, user.name);
    CacheHelper.saveData(AppCached.role, user.role);
    CacheHelper.saveData(AppCached.token, userToken);
    CacheHelper.saveData(AppCached.loginType, "gmail");
    print('Finish Saving Gmail data');
  }





  /// Sign With FaceBook


  // Future<void> signWitFaceBook({required BuildContext context}) async {
  //   final LoginResult result = await FacebookAuth.instance.login();
  //   final graphResponse = await http.get(Uri.parse('https://graph.facebook.com/v2.12/me?fields=name,picture.width(800).height(800),first_name,last_name,email&access_token=${result.accessToken!.token}'));
  //   final profile = jsonDecode(graphResponse.body);
  //   print(profile['name']);
  //   print(profile['id']);
  //   print(profile['email']);
  //   print(profile['picture']['data']['url']);
  //   if(result.status == LoginStatus.success){
  //     loginFaceBook(context: context, id: profile['id'], email: profile['email'], name: profile['name'], photo: profile['picture']['data']['url']);
  //      FacebookAuth.instance.logOut();
  //   }
  // }
  //
  // Map<dynamic, dynamic>? loginFaceBookResponse;
  // LoginModel? loginFaceBookModel;
  //
  // Future<void> loginFaceBook({required BuildContext context , required String id,required String email , required String name,required String photo}) async {
  //   emit(LoginFaceBookLoadingState());
  //   await getToken();
  //   try {
  //     Map<String, dynamic> headers = {
  //       'Accept': 'application/json',
  //       'Content-Type': 'application/json',
  //       'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage)
  //     };
  //     final lang = CacheHelper.getData(key: AppCached.appLanguage);
  //     final formData = ({
  //       'email': email,
  //       'name': name,
  //       'role': CacheHelper.getData(key: AppCached.role),
  //       'photo': photo,
  //       'uid': id
  //     });
  //     print(formData);
  //     loginFaceBookResponse = await myDio(
  //       appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
  //       dioHeaders: headers,
  //       url: AllAppApiConfig.baseUrl + AllAppApiConfig.loginProvider,
  //       methodType: 'post',
  //       dioBody: formData,
  //       context: context);
  //     print(loginFaceBookResponse!);
  //     if (loginFaceBookResponse!['data']['user']['approved'] == false) {
  //       print("------------------------------------------------------");
  //       showDialog(
  //           context: context,
  //           barrierDismissible: false,
  //           builder: (context) {
  //             Future.delayed(Duration(seconds: 3), () {
  //               CacheHelper.sharedPreferences.clear();
  //               CacheHelper.saveData(AppCached.role, "visitor");
  //               CacheHelper.saveData(AppCached.appLanguage, lang);
  //               navigatorPop(context);
  //               navigateTo(
  //                   context,
  //                   CustomZoomDrawer(
  //                       mainScreen: CustomBtnNavBarScreen(
  //                           page: 0,
  //                           isTeacher: CacheHelper.getData(key: AppCached.role)),
  //                       isTeacher: CacheHelper.getData(key: AppCached.role)));
  //             });
  //             return AlertDialog(
  //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //               content: CustomText(
  //                 text: loginFaceBookResponse!['message'],
  //                 fontSize: AppFonts.t5,
  //                 color: AppColors.mainColor,
  //                 textAlign: TextAlign.center
  //               )
  //             );
  //           });
  //       emit(LoginFaceBookSuccessState());
  //     } else {
  //       showSnackBar(
  //           context: context,
  //           text: loginFaceBookResponse!['message'],
  //           success: true);
  //       loginFaceBookModel = LoginModel.fromJson(loginFaceBookResponse!);
  //       saveDataFaceBookToShared(loginFaceBookModel!.data!.user!, loginFaceBookModel!.data!.token!);
  //       navigateAndFinish(context: context,
  //           widget: CustomZoomDrawer(mainScreen: CustomBtnNavBarScreen(page: 0,isTeacher: CacheHelper.getData(key: AppCached.role)), isTeacher: CacheHelper.getData(key: AppCached.role)));
  //
  //       emit(LoginGoogleSuccessState());
  //     }
  //   } catch (e, s) {
  //     print(e);
  //     print(s);
  //   }
  // }
  //
  // saveDataFaceBookToShared(EmailUser user, String userToken) async {
  //   print('Start Saving FaceBook data');
  //   CacheHelper.saveData(AppCached.userId, user.id);
  //   CacheHelper.saveData(AppCached.image, user.photo);
  //   CacheHelper.saveData(AppCached.isNotify, user.isNotifiy);
  //   CacheHelper.saveData(AppCached.stageId, user.stageId);
  //   CacheHelper.saveData(AppCached.subjectId, user.subjectId);
  //   CacheHelper.saveData(AppCached.phone, user.phone);
  //   CacheHelper.saveData(AppCached.phoneKey, user.phoneKey);
  //   CacheHelper.saveData(AppCached.email, user.email);
  //   CacheHelper.saveData(AppCached.pio, user.pio);
  //   CacheHelper.saveData(AppCached.notifyCount, user.notificationCount);
  //   CacheHelper.saveData(AppCached.name, user.name);
  //   CacheHelper.saveData(AppCached.role, user.role);
  //   CacheHelper.saveData(AppCached.token, userToken);
  //   CacheHelper.saveData(AppCached.loginType, "faceBook");
  //   print('Finish Saving FaceBook data');
  // }
}
