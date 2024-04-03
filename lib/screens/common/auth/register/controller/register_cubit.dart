//import 'dart:convert';
//import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:private_courses/components/custom_text.dart';
import 'package:private_courses/components/custom_toast.dart';
import 'package:private_courses/components/style/colors.dart';
import 'package:private_courses/components/style/size.dart';
import 'package:private_courses/screens/common/auth/login/model/login_model.dart';
import 'package:private_courses/screens/common/auth/register/model/register_model.dart';
import 'package:private_courses/screens/common/btnNavBar/view/custom_btn_nav_bar_view.dart';
import 'package:private_courses/screens/common/drawer/components/custom_zoom_drawer.dart';
import '../../../../../components/device_id.dart';
import '../../../../../components/my_navigate.dart';
import '../../../../../core/local/app_cached.dart';
import '../../../../../core/local/global_config.dart';
import '../../../../../shared/local/cache_helper.dart';
import '../../../../../shared/remote/dio.dart';
import '../../confirm_register_by/view/confirm_register_by_view.dart';
import '../model/stages_model.dart';
import '../model/subjects_model.dart';
import 'register_states.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);
  String? gender;

  void changeGender(String? val) {
    gender = val;
    emit(ChangeGenderState());
  }

  bool isSecure = true;

  void changeSecurePass() {
    isSecure = !isSecure;
    emit(SecurePassState());
  }

  var formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  String? dropValue;

  void changeDropVal(value) {
    dropValue = value;
    emit(ChangeValueOfDropDownTeacherState());
  }

  String? dropValue2;

  void changeDropVal2(value) {
    dropValue2 = value;
    emit(ChangeValueOfDropDownStudentState());
  }

  /// Get Data
  Map<dynamic, dynamic>? getSubjectsResponse;
  SubjectsModel? subjectsModel;
  Map<dynamic, dynamic>? getStagesResponse;
  StagesModel? stagesModel;

  Future<void> getData({required BuildContext context}) async {
    if (CacheHelper.getData(key: AppCached.isTeacher) == true) {
      debugPrint(">>> Loading Get Subjects <<<");
      emit(GetDataLoadingState());
      try {
        Map<String, dynamic> headers = {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        };

        getSubjectsResponse = await myDio(
            url: AllAppApiConfig.baseUrl + AllAppApiConfig.subjects,
            methodType: "get",
            dioBody: null,
            dioHeaders: headers,
            appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
            context: context);
        if (getSubjectsResponse!['status'] == false) {
          debugPrint(">>> Error Get Subjects <<<");
          debugPrint(getSubjectsResponse.toString());
          emit(GetDataErrorState());
        } else {
          debugPrint(">>> Success Get Subjects <<<");
          debugPrint(getSubjectsResponse.toString());
          subjectsModel = SubjectsModel.fromJson(getSubjectsResponse!);
          emit(GetDataSuccessState());
        }
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
      }
      debugPrint(">>> Finishing Getting Data Subjects <<<");
    } else {
      debugPrint(">>> Loading Get Stages <<<");
      emit(GetDataLoadingState());
      try {
        Map<String, dynamic> headers = {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        };

        getStagesResponse = await myDio(
            url: AllAppApiConfig.baseUrl + AllAppApiConfig.stages,
            methodType: "get",
            dioBody: null,
            dioHeaders: headers,
            appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
            context: context);
        if (getStagesResponse!['status'] == false) {
          debugPrint(">>> Error Get Stages <<<");
          debugPrint(getStagesResponse.toString());
          emit(GetDataErrorState());
        } else if (getStagesResponse!['status'] == true) {
          debugPrint(">>> Success Get Stages <<<");
          debugPrint(getStagesResponse.toString());
          stagesModel = StagesModel.fromJson(getStagesResponse!);
          emit(GetDataSuccessState());
        }
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
      }
      debugPrint(">>> Finishing Getting Data Stages <<<");
    }
  }

  String? token;

  getToken() async {
    token = await FirebaseMessaging.instance.getToken();
    debugPrint(token);
  }

  String? phone;
  String? phoneKey;

  void getPhone(String phoneNumber) {
    phone = phoneNumber;
    emit(GetPhoneCompleteState());
  }

  void getPhoneKey(String phoneKeyCountry) {
    phoneKey = phoneKeyCountry;
    emit(GetPhoneCompleteState());
  }

  /// Register
  Map<dynamic, dynamic>? registerResponse;
  RegisterModel? registerModel;

  Future<void> register({required BuildContext context}) async {
    await getToken();
    debugPrint(token);
    if (!formKey.currentState!.validate()) return;
    debugPrint('>>>>>>>>>>>>>> Register Loading >>>>>>>>>');
    emit(RegisterLoadingState());

    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
      };

      final formData = ({
        'name': nameController.text,
        'phone': phone,
        'phone_key': phoneKey??'SA',
        'email': emailController.text,
        'password': passController.text,
        'confirm_password': passController.text,
        'gender': gender,
        'token_firebase': token,
        'stage_id': dropValue2,
        'subject_id': dropValue,
        'role': CacheHelper.getData(key: AppCached.isTeacher) == true ? 'teacher' : 'student',
        'device_id': await getId(),
      });

      debugPrint(formData.toString());

      registerResponse = await myDio(
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioHeaders: headers,
        url: AllAppApiConfig.baseUrl + AllAppApiConfig.register,
        methodType: 'post',
        dioBody: formData,
        context: context,
      );

      if (registerResponse!['status'] == false) {
        showSnackBar(context: context, text: registerResponse!['message'], success: false);
        debugPrint('>>>>>>>>>>>>>> Register Find Error >>>>>>>>>');
        emit(RegisterFailureState());
      } else {
        showSnackBar(context: context, text: registerResponse!['message'], success: true);        // saveDataToShared(registerModel!.data!);
        debugPrint(registerResponse.toString());
        registerModel=RegisterModel.fromJson(registerResponse!);
        saveDataToShared(registerModel!.data!);
        debugPrint('>>>>>>>>>>>>>> Register Success >>>>>>>>>');
        emit(RegisterSuccessState());
        navigateTo(context, const ConfirmRegisterByScreen());

      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    debugPrint('>>>>>>>>>>>>>> Finishing Register Ok >>>>>>>>>');
  }
  saveDataToShared(DataUser user) async {
    debugPrint('Start Saving data');
    CacheHelper.saveData(AppCached.userId, user.id);
    CacheHelper.saveData(AppCached.stageId, user.stageId);
    CacheHelper.saveData(AppCached.subjectId, user.subjectId);
    CacheHelper.saveData(AppCached.subject, user.subject);
    CacheHelper.saveData(AppCached.notifyCount, user.notificationCount);
    CacheHelper.saveData(AppCached.name, user.name);
    CacheHelper.saveData(AppCached.cartCount, user.cartCount);
    CacheHelper.saveData(AppCached.email, user.email);
    CacheHelper.saveData(AppCached.phone, user.phone);
    CacheHelper.saveData(AppCached.pio, user.pio);
    CacheHelper.saveData(AppCached.phoneKey, user.phoneKey);
    CacheHelper.saveData(AppCached.image, user.photo);
    CacheHelper.saveData(AppCached.role, user.role);
    CacheHelper.saveData(AppCached.isNotify, user.isNotifiy);
    debugPrint('Finish Saving data');
  }

  ///  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* Login Gmail  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

  UserCredential? user;
  Future<void> signWitGoogle(BuildContext context) async {

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser!.authentication;
      if (googleAuth!.idToken != null && googleAuth.accessToken != null) {
        final credential = GoogleAuthProvider.credential(
            idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
        user = await FirebaseAuth.instance.signInWithCredential(credential);
        print(">>>>>>>>>>>>>>>>>>Finishing Sign Gmail <<<<<<<<<<<<<<<<<<<<<<<<");
      }
      await loginGoogle(context,googleUser.id);
    } on FirebaseAuthException catch (error) {
      print(error.toString());
      showSnackBar(text: error.toString(), success: false, context: context);
      emit(LoginGoogleFailureState());
    }
  }

  Map<dynamic, dynamic>? loginGoogleResponse;
  LoginModel? loginGoogleModel;
  Future<void> loginGoogle(context,id) async {
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
        'role': CacheHelper.getData(key: AppCached.isTeacher) == true ? 'teacher' : 'student',
        if(user!.user!.photoURL!=null)
          'photo': user!.user!.photoURL,
        'uid' : id,
      });

      print(formData.toString() + " body");

      loginGoogleResponse = await myDio(
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioHeaders: headers,
        url: AllAppApiConfig.baseUrl + AllAppApiConfig.loginProvider,
        methodType: 'post',
        dioBody: formData,
        context: context,
      );

      if (loginGoogleResponse!['status'] == false) {
        showSnackBar(context: context, text: loginGoogleResponse!['message'], success: false);
        emit(LoginGoogleFailureState());
      } else {
        print("++++++++++++++++++++++++++++++++++++++");

        if(loginGoogleResponse!['data']['user']['approved']==false) {
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
                  navigateAndFinish(
                      context : context,
                      widget: CustomZoomDrawer(
                          mainScreen: CustomBtnNavBarScreen(
                              page: 0,
                              isTeacher: CacheHelper.getData(key: AppCached.role)),
                          isTeacher: CacheHelper.getData(key: AppCached.role)));
                });
                return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  content: CustomText(
                    text: loginGoogleResponse!['message'],
                    fontSize: AppFonts.t5,
                    color: AppColors.mainColor,
                    textAlign: TextAlign.center,
                  ),
                );
              });
          emit(LoginGoogleSuccessState());
        }else{
          print("------------------------------------------------");
          showSnackBar(context: context, text: loginGoogleResponse!['message'], success: true);
          loginGoogleModel = LoginModel.fromJson(loginGoogleResponse!);
          saveDataGmailToShared(loginGoogleModel!.data!.user!, loginGoogleModel!.data!.token!);
          navigateAndFinish(
              context: context,
              widget: CustomZoomDrawer(
                  mainScreen: CustomBtnNavBarScreen(
                      page: 0,
                      isTeacher: CacheHelper.getData(key: AppCached.role)),
                  isTeacher: CacheHelper.getData(key: AppCached.role)));
        }
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
    CacheHelper.saveData(AppCached.email, user.email);
    CacheHelper.saveData(AppCached.phone, user.phone);
    CacheHelper.saveData(AppCached.phoneKey, user.phoneKey);
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
  //
  //   final graphResponse = await http.get(Uri.parse(
  //       'https://graph.facebook.com/v2.12/me?fields=name,picture.width(800).height(800),first_name,last_name,email&access_token=${result.accessToken!.token}'));
  //   final profile = jsonDecode(graphResponse.body);
  //   print(profile['name']);
  //   print(profile['id']);
  //   print(profile['email']);
  //   print(profile['picture']['data']['url']);
  //   if(result.status == LoginStatus.success){
  //     loginFaceBook(context: context, id: profile['id'], email: profile['email'], name: profile['name'], photo: profile['picture']['data']['url']);
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
  //         appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
  //         dioHeaders: headers,
  //         url: AllAppApiConfig.baseUrl + AllAppApiConfig.loginProvider,
  //         methodType: 'post',
  //         dioBody: formData,
  //         context: context
  //     );
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
  //                           isTeacher:
  //                           CacheHelper.getData(key: AppCached.role)),
  //                       isTeacher: CacheHelper.getData(key: AppCached.role)));
  //             });
  //             return AlertDialog(
  //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //                 content: CustomText(
  //                     text: loginFaceBookResponse!['message'],
  //                     fontSize: AppFonts.t5,
  //                     color: AppColors.mainColor,
  //                     textAlign: TextAlign.center
  //                 )
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
