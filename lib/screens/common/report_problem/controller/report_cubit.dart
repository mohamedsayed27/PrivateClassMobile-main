import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_toast.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/core/local/global_config.dart';
import 'package:private_courses/screens/common/btnNavBar/view/custom_btn_nav_bar_view.dart';
import 'package:private_courses/screens/common/contact_us/model/send_report_model.dart';
import 'package:private_courses/screens/common/drawer/components/custom_zoom_drawer.dart';
import 'package:private_courses/screens/student/home/view/home_view.dart';
import 'package:private_courses/screens/teacher/home_teacher/view/home_teacher_view.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import 'package:private_courses/shared/remote/dio.dart';
import '../controller/report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  ReportCubit() : super(ReportInitial());

  static ReportCubit get(context) => BlocProvider.of(context);

  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController problemDetails = TextEditingController();

  Map<dynamic,dynamic>? sendReportResponse;
  SendReportModel? sendReportmModel;
  Future<void> sendReport({required BuildContext? context})async{
    emit(LoadingState());
    try{
      Map <String , dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
      };
      Map <String , dynamic> body = {
        'name': fullName.text,
        'email': email.text,
        'msg': problemDetails.text,
      };
      print(body);
      sendReportResponse = await myDio(
          url: AllAppApiConfig.baseUrl + AllAppApiConfig.sendReport,
          methodType: "post",
          dioBody: body,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if(sendReportResponse!['status']==false){
        showSnackBar(context: context, text: sendReportResponse!["message"], success: false);
        debugPrint(sendReportResponse.toString());
        emit(FieldState());
      }else {
        showSnackBar(context: context, text: sendReportResponse!["message"], success: true);
        debugPrint(sendReportResponse!.toString());
        navigateAndFinish(context: context, widget: CustomZoomDrawer(mainScreen: CustomBtnNavBarScreen(page: 0,isTeacher: CacheHelper.getData(key: AppCached.role)),isTeacher: CacheHelper.getData(key: AppCached.role)));
        sendReportmModel = SendReportModel.fromJson(sendReportResponse!);
        emit(SuccessState());
      }
    }catch(e,s){
      print(e);
      print(s);
    }
  }
}
