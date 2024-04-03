import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_toast.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/screens/common/btnNavBar/view/custom_btn_nav_bar_view.dart';
import 'package:private_courses/screens/common/drawer/components/custom_zoom_drawer.dart';
import 'package:private_courses/screens/student/cart/model/check_coupon_model.dart';
import 'package:private_courses/screens/student/course_details/model/couponModel.dart';
import '../../../../core/local/app_cached.dart';
import '../../../../core/local/global_config.dart';
import '../../../../shared/local/cache_helper.dart';
import '../../../../shared/remote/dio.dart';
import '../../saves/model/save_model.dart';
import '../model/chat_user_model.dart';
import '../model/courses_details_model.dart';
import 'course_details_states.dart';

class CourseDetailsCubit extends Cubit<CourseDetailsStates> {
  CourseDetailsCubit() : super(CourseDetailsInitialState());

  static CourseDetailsCubit get(context) => BlocProvider.of(context);

  Map<dynamic, dynamic>? courseDetailsResponse;
  CoursesDetailsModel? courseDetailsModel;

  List<Videos> courseVideos = [];
  Future<void> getCourseDetails({required BuildContext context, required int id}) async {
    emit(CourseDetailsLoadingState());
    print("'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'");
    print("'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.appLanguage)}'");
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      courseDetailsResponse = await myDio(
          context: context,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          dioHeaders: headers,
          dioBody: null,
          url:
              '${AllAppApiConfig.baseUrl}${AllAppApiConfig.getCoursesDetails}$id',
          methodType: 'get');
      if (courseDetailsResponse!['status'] == false) {
        emit(CourseDetailsFailureState());
      } else {
        print(courseDetailsResponse);
        courseDetailsModel =
            CoursesDetailsModel.fromJson(courseDetailsResponse!);
        for (int i = 0; i < courseDetailsModel!.data!.categories!.length; i++) {
          courseVideos.addAll(courseDetailsModel!.data!.categories![i].videos!);
          for (int x = 0; x < courseVideos.length; x++) {
            courseVideos[x].vedIndx = x;
          }
        }
        emit(CourseDetailsSuccessState());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  /// get chat users and check if user in this list
  getUsers(String? id) {
    FirebaseFirestore.instance.collection('users').doc(id!).get().then((value) {
      if (value.exists) {
        return true;
      } else {
        return false;
      }
    });
  }

  /// *************************************** b3ml create le collection ********************************************

  void createUser({required UsersModel? receiver, required UsersModel? sender}) async {
    debugPrint(">>>>>>>>>>>>>>>>>>> ${sender.toString()} <<<<<<<<<<<<<<<<");
    debugPrint(">>>>>>>>>>>>>>> User Create <<<<<<<<<<<<<<<<<<<");
    await FirebaseFirestore.instance
        .collection('users')
        .doc("userId_${sender!.id}")
        .collection('chats')
        .doc('receiver_id_${receiver!.id}')
        .collection('messages')
        .doc('message')
        .set({});

    /// >>>>>>>>>>>>>>>>>> bmla eldata bta3t sender <<<<<<<<<<<<<<<<<
    await FirebaseFirestore.instance
        .collection("users")
        .doc("userId_${sender.id}")
        .set({
      'chattingWith': sender.chattingWith,
      'email': sender.email,
      'id': "userId_${sender.id}",
      'lastSeen': sender.lastSeen,
      'name': sender.name,
      'photoUrl': sender.photoUrl,
      'status': sender.status,
      'isTyping': sender.chattingWith,
      'unReadingCount': sender.unReadingCount,
    });

    /// bmla daata el reciver
    await FirebaseFirestore.instance
        .collection("users")
        .doc("userId_${sender.id}")
        .collection('chats')
        .doc('receiver_id_${receiver.id}')
        .get()
        .then((value) async {
      debugPrint('value.data()userId >>>>>>>>>>>>>>>>>>>> ${value.data()}');
      if (value.data() == null) {
        debugPrint(
            'receiver.id.toString() >>>>>>>>>>>>>>>>>>>>> ${receiver.id}');
        await FirebaseFirestore.instance
            .collection("users")
            .doc("userId_${sender.id}")
            .collection('chats')
            .doc('receiver_id_${receiver.id}')
            .set({
          'lastSeen': receiver.lastSeen,
          'name': receiver.name,
          'photoUrl': receiver.photoUrl,
          'status': receiver.status,
          'typingTo': receiver.typingTo,
          'userId': receiver.id,
          // 'unReadingCount' : receiver.unReadingCount,
          // 'status' : receiver.status,
          // 'isTyping' : receiver.typingTo,
        });
      }
    });

    // await FirebaseFirestore.instance.collection('users').doc("userId_" +userId).collection('chats').doc('message');
  }

  Map<dynamic, dynamic>? saveResponse;
  SaveModel? saveModel;
  Future<void> saveCourse(
      {required BuildContext? context, required int id}) async {
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      saveResponse = await myDio(
          url: "${AllAppApiConfig.baseUrl}"
              "${AllAppApiConfig.save}"
              "${id.toString()}",
          methodType: "get",
          dioBody: null,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if (saveResponse!['status'] == false) {
        debugPrint(saveResponse.toString());
        emit(SaveCourseErrorState());
      } else {
        debugPrint(saveResponse!.toString());
        saveModel = SaveModel.fromJson(saveResponse!);
        courseDetailsModel!.data!.isFavorite =
            !courseDetailsModel!.data!.isFavorite!;
        emit(SaveCourseSuccessState());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  Map<dynamic, dynamic>? subscribeCourseResponse;
  Future<void> subscribeCourse({
    required BuildContext? context,
    required int id,
  }) async {
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      subscribeCourseResponse = await myDio(
          url: "${AllAppApiConfig.baseUrl}"
              "${AllAppApiConfig.subscribeCourse}"
              "/${id.toString()}",
          methodType: "get",
          dioBody: null,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if (subscribeCourseResponse!['status'] == false) {
        debugPrint(subscribeCourseResponse.toString());
        emit(SubscribeCourseErrorState(
            msg: subscribeCourseResponse!['message']));
      } else {
        debugPrint(subscribeCourseResponse!.toString());
        emit(SubscribeCourseSuccessState(
            msg: subscribeCourseResponse!['message']));
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }


  Map<dynamic, dynamic>? vedioFinishedResponse;
  Future<void> finishVedio({required BuildContext? context, required int id}) async {
    print("successssssssssssssssssssssssssss  finishVedio");

    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      subscribeCourseResponse = await myDio(
          url: "${AllAppApiConfig.baseUrl}"
              "${AllAppApiConfig.vedioFinished}"
              "/${id.toString()}",
          methodType: "get",
          dioBody: null,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      print("successssssssssssssssssssssssssss  " + subscribeCourseResponse.toString());
      print("successssssssssssssssssssssssssss  " + id.toString());

      // print(vedIndx.toString() + " ++++++++++++++++++++++++++++++++++++++++++++++");
      if (subscribeCourseResponse!['status'] == false) {
        debugPrint(subscribeCourseResponse.toString());
        emit(FinishedVedioErrorState(msg: subscribeCourseResponse!['message']));
      } else {
        debugPrint(subscribeCourseResponse!.toString());
        print("successssssssssssssssssssssssssss");
        emit(FinishedVedioSuccessState(
            msg: subscribeCourseResponse!['message']));
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }
  Map<dynamic, dynamic>? unSubscribeCourseResponse;
  final reasonCtrl = TextEditingController();
  final userNameCtrl = TextEditingController(text: CacheHelper.getData(key: AppCached.name));
  final phoneCtrl = TextEditingController(text: CacheHelper.getData(key: AppCached.phone));
  final accNumberCtrl = TextEditingController();
  final ibanCtrl = TextEditingController();
  Future<void> unSubscribe({required BuildContext context, required int id}) async {
    emit(UnSubscribeCourseLoadingState());
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      final formData  = ({
        'course_id':'$id',
        'reason':reasonCtrl.text,
        'username':userNameCtrl.text,
        'account_number':accNumberCtrl.text,
        'iban':ibanCtrl.text,
        'phone':phoneCtrl.text,
      });
      debugPrint(formData.toString());
      unSubscribeCourseResponse = await myDio(
          url: AllAppApiConfig.baseUrl+AllAppApiConfig.unSubscribe,
          methodType: "post",
          dioBody: formData,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context);

      if (unSubscribeCourseResponse!['status'] == false) {
        debugPrint(unSubscribeCourseResponse.toString());
        showSnackBar(context: context, text: unSubscribeCourseResponse!['message'], success: false);
        emit(UnSubscribeCourseErrorState());
      } else {
        debugPrint(unSubscribeCourseResponse!.toString());
        emit(UnSubscribeCourseSuccessState());
        showSnackBar(context: context, text: unSubscribeCourseResponse!['message'], success: true);
        navigateAndFinish(context: context, widget: CustomZoomDrawer(mainScreen: CustomBtnNavBarScreen(page: 0,isTeacher: CacheHelper.getData(key: AppCached.role)), isTeacher: CacheHelper.getData(key: AppCached.role)));
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }


  TextEditingController couponController = TextEditingController();
  Map<dynamic, dynamic>? checkCouponResponse;
  CourseCouponModel? checkCouponModel;
  Future<void> checkCoupon({required BuildContext? context, required dynamic coupon , required String? id}) async {
    emit(CheckCouponLoadingState());
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}',
      };
      checkCouponResponse = await myDio(
          url: AllAppApiConfig.baseUrl+AllAppApiConfig.courseCoupon+id.toString(),
          methodType: "post",
          dioBody: {"coupon": coupon},
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      debugPrint(checkCouponResponse!.toString());
      if (checkCouponResponse!['status'] == false) {
        debugPrint(checkCouponResponse.toString());
        showSnackBar(context: context, text: checkCouponResponse!['message']?? "field", success: false);
        emit(CheckCouponFailedState());
      } else {
        checkCouponModel = CourseCouponModel.fromJson(checkCouponResponse!);
        showSnackBar(context: context, text: checkCouponResponse!['message']??"success", success: true);
        emit(CheckCouponSuccessState());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }
}
