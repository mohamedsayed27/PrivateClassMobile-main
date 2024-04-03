import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import 'package:private_courses/components/style/images.dart';
import 'package:private_courses/generated/locale_keys.g.dart';
import 'package:private_courses/screens/student/all_secondary/model/all_secondary_model.dart';
import 'package:private_courses/screens/student/all_university/model/university_all_model.dart';
import 'package:private_courses/screens/student/home/model/live_course_model.dart';
import 'package:private_courses/shared/remote/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/local/app_cached.dart';
import '../../../../core/local/global_config.dart';
import '../../../../shared/local/cache_helper.dart';
import '../../../common/auth/register/model/stages_model.dart';
import '../../../teacher/live/model/lives_model.dart';
import '../../saves/model/save_model.dart';
import '../model/current_course_model.dart';
import '../model/search_model.dart';
import '../model/secondary_courses_model.dart';
import '../model/university_courses_model.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  final searchCtrl = TextEditingController();
  Map<dynamic, dynamic> currentCourseResponse = {};
  CurrentCourseModel? currentCourseModel;

  Future<void> getCurrentCourse(BuildContext? context) async {
    emit(HomeLoadingState());
    if (CacheHelper.getData(key: AppCached.token) != null) {
      try {
        Map<String, dynamic> headers = {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
          'Authorization':
              'Bearer ${CacheHelper.getData(key: AppCached.token)}',
        };
        currentCourseResponse = await myDio(
          url: AllAppApiConfig.baseUrl + AllAppApiConfig.currentCourse,
          methodType: "get",
          dioHeaders: headers,
          context: context!,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          dioBody: null,
        );
        if (currentCourseResponse['status'] == false) {
          debugPrint("$currentCourseResponse is false");

        } else {
          currentCourseModel =
              CurrentCourseModel.fromJson(currentCourseResponse);
          // await getLiveCourses(context);
          await getLives(context: context);
          // await getUniversityCourses(context);
        }
      } catch (error) {
        print(error);
      }
    } else {
      // await getUniversityCourses(context);
    }
    await getAllUniversity(context, 1);
  }

  Map<dynamic, dynamic>? liveCourseResponse;
  LiveCourseModel? liveCourseModel;

  List<LivesModel> lives = [];
  List<LivesModel> currentLives = [];

  Future<void> getLives({required BuildContext context}) async {
    lives.clear();
    currentLives.clear();
    await FirebaseFirestore.instance.collection('lives').get().then((value) {
      print("getLives");
      value.docs.forEach((element) {
        if (element['finished'] == false && element['active'] == true) {
          currentLives.add(LivesModel(
              liveName: element['live_name'],
              teacherName: element['teacher_name'],
              date: element['date'],
              slug: element['slug'],
              teacherPhoto: element['teacher_photo'],
              time: element['time'],
              details: element['details'],
              link: element['link'],
              active: element['active'],
              finish: element['finished']));
        } else {
        }
      });
    });
    // emit(GetLivesSuccess());
  }

  Future<void> getLivesAll({required BuildContext context}) async {
    emit(GetLivesLoading());
    lives.clear();
    currentLives.clear();
    await FirebaseFirestore.instance.collection('lives').get().then((value) {
      print("getLives");
      value.docs.forEach((element) {
        if (element['finished'] == false && element['active'] == true) {
          currentLives.add(LivesModel(
              liveName: element['live_name'],
              teacherName: element['teacher_name'],
              date: element['date'],
              slug: element['slug'],
              teacherPhoto: element['teacher_photo'],
              time: element['time'],
              details: element['details'],
              link: element['link'],
              active: element['active'],
              finish: element['finished']));
        } else {
        }
      });
    });
    emit(GetLivesSuccess());
  }

  joinMeeting({required String roomText, required BuildContext context}) async {
      Map<FeatureFlag, bool> featureFlags = {
        FeatureFlag.isWelcomePageEnabled: false,
        FeatureFlag.isAddPeopleEnabled: false,
        FeatureFlag.isCalendarEnabled: false,
        FeatureFlag.isCallIntegrationEnabled: false,
        FeatureFlag.isChatEnabled: true,
        FeatureFlag.isOverflowMenuEnabled : false ,
        FeatureFlag.areSecurityOptionsEnabled : false ,
        FeatureFlag.isAndroidScreensharingEnabled : false ,
        FeatureFlag.isAudioMuteButtonEnabled : false ,
        FeatureFlag.isAudioOnlyButtonEnabled : false ,
        FeatureFlag.isVideoMuteButtonEnabled : false ,
        FeatureFlag.isFilmstripEnabled : false ,
        FeatureFlag.isPipEnabled : false ,
        FeatureFlag.isReactionsEnabled : false ,
        FeatureFlag.isHelpButtonEnabled : false ,
        FeatureFlag.isReplaceParticipantEnabled : false ,
        FeatureFlag.isInviteEnabled: false,
        FeatureFlag.isLiveStreamingEnabled: false,
        FeatureFlag.isMeetingNameEnabled: false,
        FeatureFlag.isMeetingPasswordEnabled: false,
        FeatureFlag.isToolboxAlwaysVisible: false,
        FeatureFlag.isCloseCaptionsEnabled: false,
        FeatureFlag.isRecordingEnabled: false,
        FeatureFlag.isIosRecordingEnabled: false,
        FeatureFlag.isRaiseHandEnabled: false,
        FeatureFlag.isTileViewEnabled: false,
        FeatureFlag.isVideoShareButtonEnabled: false,
        FeatureFlag.isToolboxEnabled: true,
        FeatureFlag.isConferenceTimerEnabled: true,
        FeatureFlag.isServerUrlChangeEnabled: true,
        FeatureFlag.isIosScreensharingEnabled: false,
        FeatureFlag.isKickoutEnabled: false,
        FeatureFlag.isAudioFocusDisabled: false,
        FeatureFlag.isFullscreenEnabled: false,
        FeatureFlag.isLobbyModeEnabled: false,
        FeatureFlag.isNotificationsEnabled: false,
        FeatureFlag.isPrejoinPageEnabled:false

      };

      // Define meetings options here
      var options = JitsiMeetingOptions(
        roomNameOrUrl: roomText,
        // serverUrl: serverUrl,
        // subject: subjectText.text,
        // token: tokenText.text,
        isAudioMuted: true,
        // isAudioOnly: isAudioOnly,
        isVideoMuted: true,
        userDisplayName: CacheHelper.getData(key: AppCached.name).toString(),
        userEmail: CacheHelper.getData(key: AppCached.email).toString(),
        featureFlags: featureFlags,
      );
      await JitsiMeetWrapper.joinMeeting(
        options: options,
        listener: JitsiMeetingListener(
          onOpened: () => debugPrint("onOpened"),
          onConferenceWillJoin: (url) {
            debugPrint("onConferenceWillJoin: url: $url");
          },
          onConferenceJoined: (url) {
            debugPrint("onConferenceJoined: url: $url");
          },
          onConferenceTerminated: (url, error) {
            getCurrentCourse(context);
          },
          onAudioMutedChanged: (isMuted) {
            debugPrint("onAudioMutedChanged: isMuted: $isMuted");
          },
          onVideoMutedChanged: (isMuted) {
            debugPrint("onVideoMutedChanged: isMuted: $isMuted");
          },
          onScreenShareToggled: (participantId, isSharing) {
            debugPrint(
              "onScreenShareToggled: participantId: $participantId, "
                  "isSharing: $isSharing",
            );
          },
          onParticipantJoined: (email, name, role, participantId) {
            debugPrint(
              "onParticipantJoined: email: $email, name: $name, role: $role, "
                  "participantId: $participantId",
            );
          },
          onParticipantLeft: (participantId) {
            debugPrint("onParticipantLeft: participantId: $participantId");
          },
          onParticipantsInfoRetrieved: (participantsInfo, requestId) {
            debugPrint(
              "onParticipantsInfoRetrieved: participantsInfo: $participantsInfo, "
                  "requestId: $requestId",
            );
          },
          onChatMessageReceived: (senderId, message, isPrivate) {
            debugPrint(
              "onChatMessageReceived: senderId: $senderId, message: $message, "
                  "isPrivate: $isPrivate",
            );
          },
          onChatToggled: (isOpen) => debugPrint("onChatToggled: isOpen: $isOpen"),
          onClosed: () => getCurrentCourse(context),
        ),
      );}


  Future<void> getLiveCourses(BuildContext? context) async {
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      liveCourseResponse = await myDio(
        url: AllAppApiConfig.baseUrl + AllAppApiConfig.getLive,
        methodType: 'get',
        dioHeaders: headers,
        context: context!,
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioBody: null,
      );
      if (liveCourseResponse!['status'] == false) {
        debugPrint(liveCourseResponse.toString());
      } else {
        debugPrint(liveCourseResponse.toString());
        liveCourseModel = LiveCourseModel.fromJson(liveCourseResponse);
        // await getUniversityCourses(context);
      }
    } catch (e) {
      print(e);
    }
  }

  Map<dynamic, dynamic>? saveCourseResponse;
  SaveModel? saveModel;
  Future<void> saveCourse({required BuildContext? context, required int id, required int? index}) async {
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      saveCourseResponse = await myDio(
          url: AllAppApiConfig.baseUrl + AllAppApiConfig.save + id.toString(),
          methodType: "get",
          dioBody: null,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if (saveCourseResponse!['status'] == false) {
        debugPrint(saveCourseResponse.toString());
      } else {
        debugPrint(saveCourseResponse!.toString());
        saveModel = SaveModel.fromJson(saveCourseResponse!);
        searchModel!.data![index!].isFavorite = !searchModel!.data![index].isFavorite!;
        emit(SaveCourseSuccessState());
      }
    } catch (e, s) {
      print(e);
      print(s);
      emit(SaveCourseErrorState());
    }
  }

  Map<dynamic, dynamic>? searchCourseResponse;
  SearchModel? searchModel;
  bool? isSearch = false;

  Future<void> searchCourse({required BuildContext? context, required String courseName,}) async {
    emit(SearchCourseLoadingState());
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        if (CacheHelper.getData(key: AppCached.token) != null)
          'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      searchCourseResponse = await myDio(
          url: AllAppApiConfig.baseUrl + AllAppApiConfig.searchCourse + "?search=${courseName}",
          methodType: "get",
          dioBody: null,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if (searchCourseResponse!['status'] == false) {
        debugPrint(searchCourseResponse.toString());
        emit(SearchCourseErrorState());
      } else {
        debugPrint(searchCourseResponse!.toString());
        searchModel = SearchModel.fromJson(searchCourseResponse!);
        emit(SearchCourseSuccessState());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }
  Map<dynamic, dynamic> tstResponse = {};

  Future<void> sendTkn(BuildContext? context) async {
    await launchUrl(
      Uri.parse("https://privateclasses.sa/teacher/start-live/e5qiiJRXZ6DmhDA3txWj?liveUserId=${CacheHelper.getData(key: AppCached.userId)}"),
      mode: LaunchMode.externalApplication,
    );
  }
  List<String> names = [
    LocaleKeys.Undergraduate.tr(),
    LocaleKeys.HighSchool.tr()
  ];
  List<String> allCategoriesImages = [
    AppImages.educationBook,
    AppImages.cap,
  ];
  int currentIndex = 0;

  void changeBottom(int index,BuildContext? context) {
    print("------------------------------ " + index.toString());
    index==1? getAllSecondery(context, 2) : getAllUniversity(context, 1);
    currentIndex = index;
    // emit(ChangeBottomState());
  }

  Map<dynamic, dynamic> universityResponse = {};
  UniversityAllModel? universityAllModel;
  Future<void> getAllUniversity(BuildContext? context, dynamic id) async {
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        if(CacheHelper.getData(key: AppCached.token)!=null )
          'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      universityResponse = await myDio(
        url: AllAppApiConfig.baseUrl +
            AllAppApiConfig.getAllUniversities +
            "/$id",
        methodType: "get",
        dioHeaders: headers,
        context: context!,
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioBody: null,
      );
      print(AllAppApiConfig.baseUrl +
          AllAppApiConfig.getAllUniversities +
          "/$id");
      if (universityResponse['status'] == false) {
        debugPrint("$universityResponse");
        emit(HomeFailedState(currentCourseResponse['message']));
      } else {
        debugPrint("$universityResponse");
        universityAllModel = UniversityAllModel.fromJson(universityResponse);

        emit(HomeSuccessState());
      }
    } catch (error) {
      debugPrint("catch error is ${error.toString()}");
    }
  }


  /// get all secondery

  Map<dynamic, dynamic> secondaryResponse = {};
  AllSecondaryModel? secondaryModel;
  Future<void> getAllSecondery(BuildContext? context, dynamic id) async {
    emit(GetAllSecondaryLoadingState());
    print("------------------------------ secondery");
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        if(CacheHelper.getData(key: AppCached.token)!=null )
          'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}',
      };
      secondaryResponse = await myDio(
        url:
        "${AllAppApiConfig.baseUrl}${AllAppApiConfig.getAllUniversities}/$id",
        methodType: "get",
        dioHeaders: headers,
        context: context!,
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioBody: null,
      );
      if (secondaryResponse['status'] == false) {
        debugPrint("$secondaryResponse");
        emit(GetAllSecondaryErrorState());
      } else {
        debugPrint("$secondaryResponse");
        secondaryModel = AllSecondaryModel.fromJson(secondaryResponse);

        emit(GetAllSecondarySuccessState());
      }
    } catch (error) {
      debugPrint("catch error is ${error.toString()}");
    }
  }

  Map<dynamic, dynamic>? saveResponse;
  SaveModel? saveSeconderyCourse;
  Future<void> saveSecondaryCourse({
    required BuildContext? context,
    required int id,
    required int? index1,
    required int? index2,
  }) async {
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
        saveSeconderyCourse = SaveModel.fromJson(saveResponse!);
        secondaryModel!.data[index1!].courses[index2!].isFavorite =
        !secondaryModel!.data[index1].courses[index2].isFavorite;
        emit(SaveCourseSuccessState());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }
  Map<dynamic, dynamic>? saveUniResponse;
  SaveModel? saveUniModel;
  Future<void> saveUniversityCourse({
    required BuildContext? context,
    required int id,
    required int? index1,
    required int? index2,
  }) async {
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      saveUniResponse = await myDio(
          url: "${AllAppApiConfig.baseUrl}"
              "${AllAppApiConfig.save}"
              "${id.toString()}",
          methodType: "get",
          dioBody: null,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if (saveUniResponse!['status'] == false) {
        debugPrint(saveUniResponse.toString());
        emit(SaveCourseErrorState());
      } else {
        debugPrint(saveUniResponse!.toString());
        saveUniModel = SaveModel.fromJson(saveUniResponse!);
        universityAllModel!.data[index1!].courses[index2!].isFavorite =
        !universityAllModel!.data[index1].courses[index2].isFavorite;
        emit(SaveCourseSuccessState());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

}
