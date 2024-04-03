import 'dart:io';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:private_courses/components/custom_toast.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/generated/locale_keys.g.dart';
import 'package:private_courses/screens/common/btnNavBar/view/custom_btn_nav_bar_view.dart';
import 'package:private_courses/screens/common/drawer/components/custom_zoom_drawer.dart';
import 'package:private_courses/screens/common/edit_profile/model/update_profile_model.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import '../../../../core/local/global_config.dart';
import '../../../../shared/remote/dio.dart';
import '../../../student/home/components/custom_filter/model/stages_model.dart';
import '../../auth/register/model/subjects_model.dart';
import '../model/profile_model.dart';
import 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileStates> {
  EditProfileCubit() : super(EditProfileInitialState());

  static EditProfileCubit get(context) => BlocProvider.of(context);

  var formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final aboutYouController = TextEditingController();

  String? dropValue;
  void changeDropVal(val) {
    dropValue = val;
    emit(ChangeValueOfDropDownState());
  }

  String? dropValueTwo;

  void changeDropValTwo(val) {
    dropValueTwo = val;
    emit(ChangeValueOfDropDownState());
  }

  File? file;
  void pickFromGallery({required BuildContext context}) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
    showSnackBar(text: LocaleKeys.Loading.tr(), context: context, success: true);
    if (pickedFile == null) return;
    file = File(pickedFile.path);
    debugPrint(file!.path);
    emit(EditProfileImageState());
  }

  void pickFromCamera({required BuildContext context}) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 80);
    showSnackBar(text: LocaleKeys.Loading.tr(), context: context, success: true);
    if (pickedFile == null) return;
    file = File(pickedFile.path);
    debugPrint(file!.path);
    emit(EditProfileImageState());
  }

  String? phone;

  void getPhone(String phoneNumber) {
    phone = phoneNumber;
    emit(GetPhoneCompleteState());
  }

  String? phoneKey;

  void getPhoneKey(String phoneKeyCountry) {
    phoneKey = phoneKeyCountry;
    emit(GetPhoneCompleteState());
  }

  /// Get Profile Data

  ProfileModel? profileModel;
  Map<dynamic, dynamic>? profileResponse;
  Future<void> getProfile({required BuildContext context}) async {
    debugPrint('>>>>>>>>>>>>>> Get Profile Loading data <<<<<<<<<<<<<');
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };

      profileResponse = await myDio(
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          dioHeaders: headers,
          url: AllAppApiConfig.baseUrl + AllAppApiConfig.userProfile,
          methodType: 'get',
          context: context,
          dioBody: null);

      if (profileResponse!['status'] == false) {
        debugPrint(profileResponse.toString());
        debugPrint(
            ">>>>>>>>>>>>>>>>> Get Profile Find Error <<<<<<<<<<<<<<<<<<<<<<<");
        emit(GetProfileErrorState());
      } else {
        debugPrint(profileResponse.toString());
        profileModel = ProfileModel.fromJson(profileResponse!);
        debugPrint(
            '>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get Profile Successes <<<<<<<<<<<<<<<<<<<<<<<<<');
        emailController.text = profileModel!.data!.email.toString();
        nameController.text = profileModel!.data!.name.toString();
        phoneController.text =profileModel!.data!.phone==null? "": profileModel!.data!.phone.toString();
        phoneKey =profileModel!.data!.phoneKey==null?"SA": profileModel!.data!.phoneKey.toString();
        dropValue =profileModel!.data!.subjectId==null? null: profileModel!.data!.subjectId.toString();
        dropValueTwo =profileModel!.data!.stageId==null? null: profileModel!.data!.stageId.toString();
        aboutYouController.text =profileModel!.data!.pio==null?"": profileModel!.data!.pio.toString();
        CacheHelper.saveData(AppCached.image, profileModel!.data!.photo.toString());
        emit(GetProfileSuccessState());
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    debugPrint('>>>>>>>>>>>>>> Finishing Getting Profile data Ok >>>>>>>>>');
  }

  /// Get Data
  Map<dynamic, dynamic>? getSubjectsResponse;
  SubjectsModel? subjectsModel;
  Map<dynamic, dynamic>? getStagesResponse;
  StagesModel? stagesModel;
  Future<void> getData({required BuildContext context}) async {
    if (CacheHelper.getData(key: AppCached.role) == "teacher") {
      debugPrint(">>> Loading Get Subjects <<<");
      emit(GetProfileLoadingState());
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
          emit(GetProfileErrorState());
        } else {
          debugPrint(">>> Success Get Subjects <<<");
          debugPrint(getSubjectsResponse.toString());
          subjectsModel = SubjectsModel.fromJson(getSubjectsResponse!);
          getProfile(context: context);
        }
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
      }
      debugPrint(">>> Finishing Getting Data Subjects <<<");
    } else {
      debugPrint(">>> Loading Get Stages <<<");
      emit(GetProfileLoadingState());
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
          emit(GetProfileErrorState());
        } else if (getStagesResponse!['status'] == true) {
          debugPrint(">>> Success Get Stages <<<");
          debugPrint(getStagesResponse.toString());
          stagesModel = StagesModel.fromJson(getStagesResponse!);
          getProfile(context: context);
        }
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
      }
      debugPrint(">>> Finishing Getting Data Stages <<<");
    }
  }

  /// UpDate Image
  Map<dynamic, dynamic>? upDateImageResponse;

  Future<void> upDateImage({required BuildContext context}) async {
    emit(UpDateLoadingState());
    debugPrint('>>>>>>>>>>>>>>>> UpDate Image Loading <<<<<<<<<<<<<<');
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };

      FormData formData = FormData.fromMap({
        'photo': file == null ? null : await MultipartFile.fromFile(file!.path),
      });

      debugPrint(formData.toString());

      upDateImageResponse = await myDio(
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioHeaders: headers,
        url: AllAppApiConfig.baseUrl + AllAppApiConfig.updateImage,
        methodType: 'post',
        context: context,
        dioBody: formData,
      );

      if (upDateImageResponse!['status'] == false) {
        debugPrint('>>>>>>>>>>>>>>>> UpDate Image Find Error <<<<<<<<<<<<<<');
        debugPrint(upDateImageResponse.toString());
        showSnackBar(text: upDateImageResponse!['message'], context: context, success: false);
        emit(UpDateImageErrorState());
      } else {
        debugPrint(
            '>>>>>>>>>>>>>>>>> UpDate Image Success <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<');
        debugPrint(upDateImageResponse.toString());
        //showSnackBar(text: upDateImageResponse!['message'], context: context, success: true);
        CacheHelper.saveData(AppCached.image, upDateImageResponse!['data']);
        emit(UpDateImageSuccessState());
        // navigateAndFinish(
        //     context: context,
        //     widget: CustomZoomDrawer(
        //         mainScreen: CustomBtnNavBar(
        //             isTeacher: CacheHelper.getData(key: AppCached.role)),
        //         isTeacher: CacheHelper.getData(key: AppCached.role)));
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    debugPrint('>>>>>>>>>>>>>> Finishing Update Image data Ok >>>>>>>>>');
  }

  /// UpDate Profile
  Map<dynamic, dynamic>? upDateProfileResponse;
  UpdateProfileModel? updateProfileModel;

  Future<void> upDateProfile({required BuildContext context}) async {
    debugPrint('>>>>>>>>>>>>>>>> UpDate Profile Loading <<<<<<<<<<<<<<');

    emit(UpDateLoadingState());

    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };

      final formData = ({
        'name': nameController.text,
        'phone': phone ?? phoneController.text,
        'email': emailController.text,
        'phone_key': phoneKey,
        'stage_id': CacheHelper.getData(key: AppCached.role) == "teacher"
            ? ''
            : dropValueTwo,
        'subject_id': CacheHelper.getData(key: AppCached.role) == "teacher"
            ? dropValue
            : '',
        'role': CacheHelper.getData(key: AppCached.role),
        'pio': CacheHelper.getData(key: AppCached.role) == "teacher"
            ? aboutYouController.text
            : '',
      });

      debugPrint(formData.toString());

      upDateProfileResponse = await myDio(
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioHeaders: headers,
        url: AllAppApiConfig.baseUrl + AllAppApiConfig.updateUser,
        methodType: 'post',
        context: context,
        dioBody: formData,
      );

      if (upDateProfileResponse!['status'] == false) {
        debugPrint(
            '>>>>>>>>>>>>>>> Update Profile Find Error <<<<<<<<<<<<<<<<<<<<<');
        debugPrint(upDateProfileResponse.toString());
        showSnackBar(
            text: upDateProfileResponse!['message'],
            context: context,
            success: false);
        emit(UpDateProfileErrorState());
      } else {
        debugPrint(
            '>>>>>>>>>>>>>>>>>>>> UpDate Profile data Successes <<<<<<<<<<<<<<<<<<<<');
        debugPrint(upDateProfileResponse.toString());
        showSnackBar(
            text: upDateProfileResponse!['message'],
            context: context,
            success: true);
        updateProfileModel = UpdateProfileModel.fromJson(upDateProfileResponse!);
        saveDataToShared(updateProfileModel!.data!);
        emit(UpDateProfileSuccessState());
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

    debugPrint('>>>>>>>>>>>>>> Finishing upDate Profile data Ok >>>>>>>>>');
  }

  saveDataToShared(DataUpdate user) async {
    debugPrint('Start Saving data');
    CacheHelper.saveData(AppCached.userId, user.id);
    CacheHelper.saveData(AppCached.stageId, user.stageId);
    CacheHelper.saveData(AppCached.subject, user.subject);
    CacheHelper.saveData(AppCached.subjectId, user.subjectId);
    CacheHelper.saveData(AppCached.name, user.name);
    CacheHelper.saveData(AppCached.email, user.email);
    CacheHelper.saveData(AppCached.phone, user.phone);
    CacheHelper.saveData(AppCached.pio, user.pio);
    CacheHelper.saveData(AppCached.phoneKey, user.phoneKey);
    CacheHelper.saveData(AppCached.image, user.photo);
    CacheHelper.saveData(AppCached.isNotify, user.isNotifiy);
    CacheHelper.saveData(AppCached.role, user.role);
    debugPrint('Finish Saving data');
  }
}
