import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_toast.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/components/toast.dart';
import 'package:private_courses/core/local/global_config.dart';
import 'package:private_courses/generated/locale_keys.g.dart';
import 'package:private_courses/screens/common/btnNavBar/view/custom_btn_nav_bar_view.dart';
import 'package:private_courses/shared/remote/dio.dart';
import '../../../../../../core/local/app_cached.dart';
import '../../../../../../shared/local/cache_helper.dart';
import 'live_states.dart';

class LiveCubit extends Cubit<LiveStates> {
  LiveCubit() : super(LiveCubitInitial());

  static LiveCubit get(context) => BlocProvider.of(context);
  final lectureNameCtrl = TextEditingController();
  final liveDateCtrl = TextEditingController();
  final liveTimeCtrl = TextEditingController();
  final detailsCtrl = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? valueBackend ;
  void pickedTime({required TimeOfDay value, required BuildContext context}) {
    final now = DateTime.now();
    final formatted = DateTime(now.year, now.month, now.day, value.hour, value.minute);
   String formatUI  = context.locale.languageCode == "ar" ?DateFormat.jm("ar").format(formatted):DateFormat.jm("en").format(formatted);
    liveTimeCtrl.text = formatUI ;
    valueBackend = '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}' ;
    print(valueBackend);
    print(formatUI+" Ui ");
    emit(SelectTime());
  }


  String? formatUiDate ;
  String? formatBackendDate ;
  void pickedDate({required dynamic value, required BuildContext context}){
    formatBackendDate = DateFormat("yyyy-MM-dd",'en').format(value);
    formatUiDate = context.locale.languageCode == "ar"?DateFormat.yMMMMd('ar').format(value):DateFormat.yMMMMd('en').format(value);
    liveDateCtrl.text = formatUiDate! ;
    print(formatBackendDate);
    print(formatUiDate);
    emit(SelectDay());
  }
  var slug ;
  // Future createLiveLink({required BuildContext context}) async {
  //   if(formKey.currentState!.validate()){
  //     emit(CreateLiveLoading());
  //     debugPrint(">>>>>>>>>>>>>>> User Create <<<<<<<<<<<<<<<<<<<");
  //     slug = FirebaseFirestore.instance.collection('lives').doc().id ;
  //     await FirebaseFirestore.instance.collection('lives').doc().set({
  //       'active': false,
  //       'date': formatBackendDate,
  //       'details': detailsCtrl.text,
  //       'link' : "https://meet.jit.si/${slug}",
  //       'slug':'${slug}',
  //       'finished': false,
  //       'live_name': lectureNameCtrl.text,
  //       'teacher_name': CacheHelper.getData(key: AppCached.name),
  //       'teacher_photo': CacheHelper.getData(key: AppCached.image),
  //       'time': valueBackend,
  //       'user_id': CacheHelper.getData(key: AppCached.userId).toString(),
  //     });
  //     navigatorPop(context);
  //     showSnackBar(context: context, text: LocaleKeys.LiveCreatedSuccess.tr(), success: true);
  //   }
  //   else{
  //       print("Emlaaaa Ya nailaaaa");
  //   }
  //
  //   emit(CreateLiveSuccess());
  // }

  Map<dynamic, dynamic>? createLiveResponse;
  Future<void> createLive (BuildContext? context) async {
    emit(CreateLiveLoading());
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      final body = {
        "name": lectureNameCtrl.text,
        "live_time_from": valueBackend,
        "date_live": formatBackendDate,
        "details": detailsCtrl.text
      };
      debugPrint(body.toString());
      createLiveResponse = await myDio(
          url: AllAppApiConfig.baseUrl+AllAppApiConfig.createLive,
          methodType: "post",
          dioBody: body,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if (createLiveResponse!['status'] == false) {
         debugPrint(createLiveResponse.toString());
         showToast(text: createLiveResponse!['message'], state: ToastStates.error);
         //showSnackBar(context: context, text: createLiveResponse!['message'], success: false);
        emit(CreateLiveError());
      } else {
        debugPrint(createLiveResponse!.toString());
        slug = FirebaseFirestore.instance.collection('lives').doc().id ;
        await FirebaseFirestore.instance.collection('lives').doc().set({
          'active': false,
          'date': formatBackendDate,
          'details': detailsCtrl.text,
          'link' : "https://meet.jit.si/${slug}",
          'slug':'${slug}',
          'finished': false,
          'live_name': lectureNameCtrl.text,
          'teacher_name': CacheHelper.getData(key: AppCached.name),
          'teacher_photo': CacheHelper.getData(key: AppCached.image),
          'time': valueBackend,
          'user_id': CacheHelper.getData(key: AppCached.userId).toString(),
        });
        emit(CreateLiveSuccess());
        navigatorPop(context);
        showSnackBar(context: context, text: createLiveResponse!['message'], success: true);
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }







}
