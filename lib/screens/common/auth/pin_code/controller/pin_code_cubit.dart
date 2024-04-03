import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_text.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/components/style/colors.dart';
import 'package:private_courses/components/style/size.dart';
import 'package:private_courses/screens/common/btnNavBar/view/custom_btn_nav_bar_view.dart';
import 'package:private_courses/screens/common/drawer/components/custom_zoom_drawer.dart';
import '../../../../../components/custom_toast.dart';
import '../../../../../core/local/app_cached.dart';
import '../../../../../core/local/global_config.dart';
import '../../../../../shared/local/cache_helper.dart';
import '../../../../../shared/remote/dio.dart';
import '../../change_pass/view/change_pass_view.dart';
import '../model/pin_code_model.dart';
import 'pin_code_states.dart';

class PinCodeCubit extends Cubit<PinCodeStates> {
  PinCodeCubit() : super(PinCodeInitialState());

  static PinCodeCubit get(context) => BlocProvider.of(context);

  /// Resend Code
  Map<dynamic, dynamic>? resendCodeResponse;

  Future<void> resendCode({required BuildContext context}) async {
    debugPrint('>>>>>>>>>>>>>> ReSend Code Loading >>>>>>>>>');
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
      };

      final formData = ({
        'phone': CacheHelper.getData(key: AppCached.codeType) == "phone"
            ? CacheHelper.getData(key: AppCached.phone)
            : "",
        'type': CacheHelper.getData(key: AppCached.codeType),
        'email': CacheHelper.getData(key: AppCached.codeType) == "email"
            ? CacheHelper.getData(key: AppCached.email)
            : "",
      });

      debugPrint(formData.toString());

      resendCodeResponse = await myDio(
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioHeaders: headers,
        url: AllAppApiConfig.baseUrl + AllAppApiConfig.sendCode,
        methodType: 'post',
        dioBody: formData,
        context: context,
      );

      if (resendCodeResponse!['status'] == false) {
        showSnackBar(
            context: context,
            text: resendCodeResponse!['message'],
            success: false);
        debugPrint('>>>>>>>>>>>>>> ReSend Code Find Error >>>>>>>>>');
      } else {
        showSnackBar(
            context: context,
            text: resendCodeResponse!['message'],
            success: true); // saveDataToShared(registerModel!.data!);
        debugPrint(resendCodeResponse.toString());
        debugPrint('>>>>>>>>>>>>>> ReSend Code Success >>>>>>>>>');
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    debugPrint('>>>>>>>>>>>>>> Finishing ReSend Code Ok >>>>>>>>>');
  }

  /// Active Account
  Map<dynamic, dynamic>? activeAccResponse;
  PinCodeModel? pinCodeModel;
  final pinCtrl = TextEditingController();

  Future<void> activeAccount({required BuildContext context}) async {
    debugPrint('>>>>>>>>>>>>>> Active Account Loading >>>>>>>>>');
    emit(ActiveAccLoadingState());
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
      };

      final formData = ({
        'phone_or_email':
            CacheHelper.getData(key: AppCached.codeType) == "phone"
                ? CacheHelper.getData(key: AppCached.phone)
                : CacheHelper.getData(key: AppCached.email),
        'type': CacheHelper.getData(key: AppCached.codeType),
        'code': pinCtrl.text,
        "request_type": "active"
      });

      debugPrint(formData.toString());

      activeAccResponse = await myDio(
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioHeaders: headers,
        url: AllAppApiConfig.baseUrl + AllAppApiConfig.activeCode,
        methodType: 'post',
        dioBody: formData,
        context: context,
      );

      if (activeAccResponse!['status'] == false) {
        showSnackBar(
            context: context,
            text: activeAccResponse!['message'],
            success: false);
        emit(ActiveAccErrorState());
        debugPrint('>>>>>>>>>>>>>> Active Account Find Error >>>>>>>>>');
      } else {
        showSnackBar(
            context: context,
            text: activeAccResponse!['message'],
            success: true);
        debugPrint(activeAccResponse.toString());
        pinCodeModel = PinCodeModel.fromJson(activeAccResponse!);
        saveDataToShared(pinCodeModel!.data!.user!, pinCodeModel!.data!.token!);
        emit(ActiveAccSuccessState());
        CacheHelper.getData(key: AppCached.role) == "teacher"?
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              Future.delayed(Duration(seconds: 3),() {
                CacheHelper.sharedPreferences.clear();
                CacheHelper.saveData(AppCached.role, "visitor");
                CacheHelper.saveData(AppCached.appLanguage, "ar");
                navigateAndFinish(
                    context : context,
                    widget : CustomZoomDrawer(
                        mainScreen: CustomBtnNavBarScreen(
                            page: 0,
                            isTeacher: CacheHelper.getData(key: AppCached.role)),
                        isTeacher: CacheHelper.getData(key: AppCached.role)));
              });
              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                content: CustomText(
                    text: activeAccResponse!['message'],
                    fontSize: AppFonts.t5,
                    color: AppColors.mainColor,
                    textAlign: TextAlign.center,
                ),
              );
            }) :
        navigateAndFinish(
            context: context,
            widget: CustomZoomDrawer(
                mainScreen: CustomBtnNavBarScreen(
                    page: 0,
                    isTeacher: CacheHelper.getData(key: AppCached.role)),
                isTeacher: CacheHelper.getData(key: AppCached.role)));
        debugPrint('>>>>>>>>>>>>>> Active Account Success >>>>>>>>>');
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    debugPrint('>>>>>>>>>>>>>> Finishing Active Account Ok >>>>>>>>>');
  }

  /// Active Code For Change Pass
  Map<dynamic, dynamic>? activeCodeResponse;
  PinCodeModel? activeCodeModel;
  Future<void> activeCode({required BuildContext context}) async {
    debugPrint('>>>>>>>>>>>>>> Active Code For Change Pass Loading >>>>>>>>>');
    emit(ActiveAccLoadingState());
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
      };

      final formData = ({
        'phone_or_email': CacheHelper.getData(key: AppCached.email),
        'type': CacheHelper.getData(key: AppCached.codeType),
        'code': pinCtrl.text,
        "request_type":"forget-password"
      });

      debugPrint(formData.toString());

      activeCodeResponse = await myDio(
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioHeaders: headers,
        url: AllAppApiConfig.baseUrl + AllAppApiConfig.activeCode,
        methodType: 'post',
        dioBody: formData,
        context: context,
      );

      if (activeCodeResponse!['status'] == false) {
        showSnackBar(
            context: context,
            text: activeCodeResponse!['message'],
            success: false);
        emit(ActiveAccErrorState());
        debugPrint('>>>>>>>>>>>>>> Active Code For Change Pass Find Error >>>>>>>>>');
      } else {
        showSnackBar(
            context: context,
            text: activeCodeResponse!['message'],
            success: true);
        debugPrint(activeCodeResponse.toString());
        activeCodeModel = PinCodeModel.fromJson(activeCodeResponse!);
        emit(ActiveAccSuccessState());
        navigateAndReplace(context: context, widget:  ChangePassScreen(token: activeCodeModel!.data!.token!));
        debugPrint('>>>>>>>>>>>>>> Active Code For Change Pass Success >>>>>>>>>');
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    debugPrint(
        '>>>>>>>>>>>>>> Finishing Active Code For Change Pass Ok >>>>>>>>>');
  }

  saveDataToShared(User user, String token) async {
    debugPrint('Start Saving For Change Pass data');
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
    debugPrint('Finish Saving For Change Pass data');
  }
}
