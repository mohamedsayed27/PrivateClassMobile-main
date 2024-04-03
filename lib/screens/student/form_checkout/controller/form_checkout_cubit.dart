import 'dart:io';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:private_courses/components/custom_toast.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/core/local/global_config.dart';
import 'package:private_courses/screens/common/btnNavBar/view/custom_btn_nav_bar_view.dart';
import 'package:private_courses/screens/common/drawer/components/custom_zoom_drawer.dart';
import 'package:private_courses/screens/student/form_checkout/controller/form_checkout_states.dart';
import 'package:private_courses/screens/student/form_checkout/model/banks_model.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import 'package:private_courses/shared/remote/dio.dart';

class FormCheckoutCubit extends Cubit<FormCheckoutStates> {
  FormCheckoutCubit() : super(FormCheckoutInitialState());

  static FormCheckoutCubit get(context) => BlocProvider.of(context);
  final amountCtrl = TextEditingController();
  final dateCtrl = TextEditingController();
  final adapterNameCtrl = TextEditingController();
  final linkPhotoCtrl = TextEditingController();

  String? dropDownValue;
  void changeDropDown(context,val) {
    dropDownValue = val;
    getBankIban(context: context, id: int.parse(val));
    emit(ChangeDropDown());
  }

  File? file;
  void pickFromGallery({required BuildContext context}) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile == null) return;
    file = File(pickedFile.path);
    linkPhotoCtrl.text = file!.path ;
    debugPrint(file!.path);
    emit(PickGalleryImageState());
  }

  void pickFromCamera({required BuildContext context}) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 80);
    if (pickedFile == null) return;
    file = File(pickedFile.path);
    linkPhotoCtrl.text = file!.path ;
    debugPrint(file!.path);
    emit(PickCameraImageState());
  }


  String? formatBackendDate ;
  void pickedDate({required dynamic value, required BuildContext context}){
    formatBackendDate = DateFormat("yyyy-MM-dd",'en').format(value);
    final formatUiDate = context.locale.languageCode == "ar"?DateFormat.yMMMMd('ar').format(value):DateFormat.yMMMMd('en').format(value);
    dateCtrl.text = formatUiDate ;
    print(formatBackendDate);
    print(formatUiDate);
    emit(SelectDayState());
  }


  BanksModel? banksModel ;
  Map<dynamic,dynamic>? banksResponse ;

  Future<void> getBanks ({required BuildContext context})async{
    emit(GetBanksLoadingState());
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage)
      };

      banksResponse = await myDio(
          url: AllAppApiConfig.baseUrl + AllAppApiConfig.banks,
          methodType: "get",
          dioBody: null,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context);
      if (banksResponse!['status'] == false) {
        debugPrint(banksResponse.toString());
        emit(GetBanksErrorState());
      } else {
        debugPrint(banksResponse.toString());
        banksModel = BanksModel.fromJson(banksResponse!);
        emit(GetBanksSuccessState());
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
  }

  Map<dynamic,dynamic>? bankFormResponse ;

  Future<void> formBank({required BuildContext context,required int courseId}) async {

    emit(FormLoadingState());

    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };

      final formData = FormData.fromMap({
        'bank_id': dropDownValue,
        'course_id':'$courseId',
        'type': 'course',
        'price' : CacheHelper.getData(key: AppCached.amountCart).toString(),
        'commission_amount': amountCtrl.text,
        'transfer_date': formatBackendDate,
        'converter_name': adapterNameCtrl.text,
        'image': file == null ? null : await MultipartFile.fromFile(file!.path),
      });

      debugPrint(CacheHelper.getData(key: AppCached.amountCart).toString());
      debugPrint(formData.toString());

      bankFormResponse = await myDio(
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioHeaders: headers,
        url: AllAppApiConfig.baseUrl + AllAppApiConfig.formBank,
        methodType: 'post',
        context: context,
        dioBody: formData
      );
      if (bankFormResponse!['status'] == false) {
        debugPrint(bankFormResponse.toString());
        showSnackBar(
            text: bankFormResponse!['message'],
            context: context,
            success: false);
        emit(FormErrorState());
      } else {
        debugPrint(bankFormResponse.toString());
        showSnackBar(
            text: bankFormResponse!['message'],
            context: context,
            success: true);
        emit(FormSuccessState());
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

  }

  Future<void> formBankCart ({required BuildContext context}) async {

    emit(FormLoadingState());

    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };

      final formData = FormData.fromMap({
        'bank_id': dropDownValue,
        'course_id':'',
        'type': 'cart',
        'commission_amount': amountCtrl.text,
        'transfer_date': formatBackendDate,
        'converter_name': adapterNameCtrl.text,
        'image': file == null ? null : await MultipartFile.fromFile(file!.path),
      });

      debugPrint(formData.toString());

      bankFormResponse = await myDio(
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioHeaders: headers,
        url: AllAppApiConfig.baseUrl + AllAppApiConfig.formBank,
        methodType: 'post',
        context: context,
        dioBody: formData
      );
      if (bankFormResponse!['status'] == false) {
        debugPrint(bankFormResponse.toString());
        showSnackBar(
            text: bankFormResponse!['message'],
            context: context,
            success: false);
        emit(FormErrorState());
      } else {
        debugPrint(bankFormResponse.toString());
        showSnackBar(
            text: bankFormResponse!['message'],
            context: context,
            success: true);
        emit(FormSuccessState());
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

  }

  /// *-*-*-*-*-* get IBAN

  String? accNumber;
  String? bankIban;
  Map<dynamic,dynamic>? bankIbanResponse ;

  Future<void> getBankIban ({required BuildContext context , required int id})async{
    emit(BankIbanLoadingState());
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage)
      };

      bankIbanResponse = await myDio(
          url: AllAppApiConfig.baseUrl + AllAppApiConfig.bankIban+id.toString(),
          methodType: "get",
          dioBody: null,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context);
      if (bankIbanResponse!['status'] == false) {
        debugPrint(bankIbanResponse.toString());
        emit(BankIbanFieldState());
      } else {
        debugPrint(bankIbanResponse.toString());
        bankIban=bankIbanResponse!['data']['iban'];
        accNumber=bankIbanResponse!['data']['account_number'];
        emit(BankIbanSuccessState());
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
  }

}