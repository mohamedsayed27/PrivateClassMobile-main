import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/screens/common/auth/login/view/login_view.dart';
import '../../../../../components/custom_toast.dart';
import '../../../../../components/my_navigate.dart';
import '../../../../../core/local/app_cached.dart';
import '../../../../../core/local/global_config.dart';
import '../../../../../shared/local/cache_helper.dart';
import '../../../../../shared/remote/dio.dart';
import 'change_pass_states.dart';

class ChangePassCubit extends Cubit<ChangePassword> {
  ChangePassCubit() : super(ChangePassInitialState());

  static ChangePassCubit get(context) => BlocProvider.of(context);

  bool isSecure1 = true;

  void changeSecurePass1() {
    isSecure1 = !isSecure1;
    emit(SecurePassState());
  }

  bool isSecure2 = true;

  void changeSecurePass2() {
    isSecure2 = !isSecure2;
    emit(SecurePassState());
  }

  var formKey = GlobalKey<FormState>();
  TextEditingController newPassController = TextEditingController();
  TextEditingController confirmNewPassController = TextEditingController();

  Map<dynamic, dynamic>? changePassResponse;

  Future<void> changePass({required BuildContext context,required String token}) async {
    if (!formKey.currentState!.validate()) return;
    debugPrint('>>>>>>>>>>>>>> Change Password Loading >>>>>>>>>');
    emit(ChangePassLoadingState());

    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${token}'
      };

      final formData = ({
        'password': newPassController.text,
        'confirm_password': confirmNewPassController.text,
      });

      debugPrint(formData.toString());

      changePassResponse = await myDio(
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioHeaders: headers,
        url: AllAppApiConfig.baseUrl + AllAppApiConfig.changePass,
        methodType: 'post',
        dioBody: formData,
        context: context,
      );

      if (changePassResponse!['status'] == false) {
        showSnackBar(
            context: context, text: changePassResponse!['message'], success: false);
        debugPrint('>>>>>>>>>>>>>> Change Password Find Error >>>>>>>>>');
        emit(ChangePassErrorState());
      } else {
        showSnackBar(
            context: context,
            text: changePassResponse!['message'],
            success: true);
        debugPrint(changePassResponse.toString());
        debugPrint('>>>>>>>>>>>>>> Change Password Success >>>>>>>>>');
        emit(ChangePassSuccessState());
        navigateAndFinish(
            context: context,
            widget: const LoginScreen());
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    debugPrint('>>>>>>>>>>>>>> Finishing Change Password Ok >>>>>>>>>');
  }
}
