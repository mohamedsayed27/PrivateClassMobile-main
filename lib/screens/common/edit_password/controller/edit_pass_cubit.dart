import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/screens/common/btnNavBar/view/custom_btn_nav_bar_view.dart';
import 'package:private_courses/screens/common/drawer/components/custom_zoom_drawer.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import '../../../../components/custom_toast.dart';
import '../../../../core/local/global_config.dart';
import '../../../../shared/remote/dio.dart';
import 'edit_pass_state.dart';

class EditPassCubit extends Cubit<EditPassStates> {
  EditPassCubit() : super(EditPassInitialState());

  static EditPassCubit get(context) => BlocProvider.of(context);

  var formKey = GlobalKey<FormState>();
  TextEditingController oldPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController confirmNewPassController = TextEditingController();

  bool isSecure = true;

  void changeSecurePass() {
    isSecure = !isSecure;
    emit(SecurePassState());
  }

  bool isSecure2 = true;

  void changeSecurePass2() {
    isSecure2 = !isSecure2;
    emit(SecurePassState());
  }

  bool isSecure3 = true;

  void changeSecurePass3() {
    isSecure3 = !isSecure3;
    emit(SecurePassState());
  }

  Map<dynamic, dynamic>? updatePassResponse;

  Future<void> updatePass({required BuildContext context}) async {
    if (!formKey.currentState!.validate()) return;
    debugPrint('>>>>>>>>>>>>>> Update Password Loading >>>>>>>>>');
    emit(UpdatePassLoadingState());

    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };

      final formData = ({
        'current_password': oldPassController.text,
        'password': newPassController.text,
        'confirm_password': confirmNewPassController.text,
      });

      debugPrint(formData.toString());

      updatePassResponse = await myDio(
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioHeaders: headers,
        url: AllAppApiConfig.baseUrl + AllAppApiConfig.updatePass,
        methodType: 'post',
        dioBody: formData,
        context: context,
      );

      if (updatePassResponse!['status'] == false) {
        showSnackBar(
            context: context,
            text: updatePassResponse!['message'],
            success: false);
        debugPrint('>>>>>>>>>>>>>> Update Password Find Error >>>>>>>>>');
        emit(UpdatePassErrorState());
      } else {
        showSnackBar(
            context: context,
            text: updatePassResponse!['message'],
            success: true);
        debugPrint(updatePassResponse.toString());
        debugPrint('>>>>>>>>>>>>>> Update Password Success >>>>>>>>>');
        emit(UpdatePassSuccessState());
        navigateAndFinish(context: context, widget: CustomZoomDrawer(mainScreen: CustomBtnNavBarScreen(page: 0,isTeacher: CacheHelper.getData(key: AppCached.role)), isTeacher: CacheHelper.getData(key: AppCached.role)));
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    debugPrint('>>>>>>>>>>>>>> Finishing Update Password Ok >>>>>>>>>');
  }

}
