import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/core/local/global_config.dart';
import 'package:private_courses/screens/common/contact_us/model/contact_us_model.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import 'package:private_courses/shared/remote/dio.dart';

import 'contact_us_states.dart';

class ContactUsCubit extends Cubit<ContactUsStates> {
  ContactUsCubit() : super(ContactUsInitialState());

  static ContactUsCubit get(context) => BlocProvider.of(context);

  Map<dynamic, dynamic>? contactUsResponse;
  ContactUsModel? contactUsModel;

  Future<void> fetchContactUs({required BuildContext? context}) async {
    emit(LoadingState());
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
      };
      contactUsResponse = await myDio(
          url: AllAppApiConfig.baseUrl + AllAppApiConfig.contactUs,
          methodType: "get",
          dioBody: null,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if (contactUsResponse!['status'] == false) {
        debugPrint(contactUsResponse.toString());
        emit(FieldState(msg: contactUsResponse!['msg']));
      } else {
        debugPrint(contactUsResponse.toString());
        contactUsModel = ContactUsModel.fromJson(contactUsResponse!);
        emit(SuccessState());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}
