import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../components/custom_toast.dart';
import '../../../../../components/my_navigate.dart';
import '../../../../../core/local/app_cached.dart';
import '../../../../../core/local/global_config.dart';
import '../../../../../shared/local/cache_helper.dart';
import '../../../../../shared/remote/dio.dart';
import '../../pin_code/view/pin_code_view.dart';
import 'forget_pass_states.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordStates> {
  ForgetPasswordCubit() : super(ForgetPasswordInitialState());

  static ForgetPasswordCubit get(context) => BlocProvider.of(context);

  var formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  /// Forget Pass To Send Code
  Map<dynamic, dynamic>? forgetPassResponse;

  Future<void> forgetPass({required BuildContext context}) async {
    debugPrint('>>>>>>>>>>>>>> Forget Pass To Send Code Loading >>>>>>>>>');
    CacheHelper.saveData(AppCached.email, emailController.text);
    emit(ForgetPasswordLoadingState());
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
      };
      final formData = ({
        'email': emailController.text
      });
      debugPrint(formData.toString());
      forgetPassResponse = await myDio(
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioHeaders: headers,
        url: AllAppApiConfig.baseUrl + AllAppApiConfig.forgetPass,
        methodType: 'post',
        dioBody: formData,
        context: context
      );
      if (forgetPassResponse!['status'] == false) {
        showSnackBar(
            context: context,
            text: forgetPassResponse!['message'],
            success: false);
        emit(ForgetPasswordErrorState());
        debugPrint('>>>>>>>>>>>>>> Forget Pass To Send Code Find Error >>>>>>>>>');
      } else {
        showSnackBar(
            context: context,
            text: forgetPassResponse!['message'],
            success: true);
        debugPrint(forgetPassResponse.toString());
        debugPrint('>>>>>>>>>>>>>> Forget Pass To Send Code Success >>>>>>>>>');
        emit(ForgetPasswordSuccessState());
        CacheHelper.saveData(AppCached.codeType, "email");
        navigateTo(context, PinCodeScreen(isPass: true));
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    debugPrint(
        '>>>>>>>>>>>>>> Finishing Forget Pass To Send Code Ok >>>>>>>>>');
  }
}
