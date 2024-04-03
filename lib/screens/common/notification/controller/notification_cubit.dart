
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import '../../../../components/custom_toast.dart';
import '../../../../core/local/app_cached.dart';
import '../../../../core/local/global_config.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/local/cache_helper.dart';
import '../../../../shared/remote/dio.dart';
import '../model/get_notification_model.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  static NotificationCubit get(context) => BlocProvider.of(context);

  Map<dynamic, dynamic>? getNotificationResponse;
  GetNotificationModel? getNotificationModel;

  Future<void> getAllNotifications({required BuildContext context, required bool isLoading}) async {
    isLoading == true ? emit(NotificationLoadingState()) : null;
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      getNotificationResponse = await myDio(
          context: context,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          dioHeaders: headers,
          dioBody: null,
          url: AllAppApiConfig.baseUrl + AllAppApiConfig.getNotification,
          methodType: 'get');
      if (getNotificationResponse!['status'] == false) {
        print('notification Failed');
        emit(NotificationFailureState());
      } else {
        print('Notifications Successes');
        print(getNotificationResponse.toString());
        getNotificationModel = GetNotificationModel.fromJson(getNotificationResponse!);
        emit(NotificationSuccessState());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  Map<dynamic, dynamic>? deleteOneNotificationsResponse;

  Future<void> deleteNotify({required BuildContext context,required String id}) async {
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      deleteOneNotificationsResponse = await myDio(
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioHeaders: headers,
        url: AllAppApiConfig.baseUrl + AllAppApiConfig.deleteOneNotification + id,
        methodType: 'get',
        context: context,
        dioBody: null,
      );
      if (deleteOneNotificationsResponse!['status'] == false) {
        print('Delete one Notify Failed');
        print(deleteOneNotificationsResponse.toString());
        emit(NotificationFailureState());
      } else {
        print('Delete One Notify Successes');
        await getAllNotifications(context: context, isLoading: false);
        showSnackBar(
            context: context,
            text: deleteOneNotificationsResponse!['message'],
            success: true);
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  Map<dynamic, dynamic>? deleteAllNotificationsResponse;

  Future<void> deleteAllNotification({required BuildContext context}) async {
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      deleteAllNotificationsResponse = await myDio(
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioHeaders: headers,
        url: AllAppApiConfig.baseUrl + AllAppApiConfig.deleteAllNotification,
        methodType: 'get',
        context: context,
        dioBody: null,
      );
      if (deleteAllNotificationsResponse!['status'] == false) {
        print('Delete All Notify Failed');
        showSnackBar(
            context: context,
            text: deleteAllNotificationsResponse!['message'],
            success: false);
        emit(NotificationFailureState());
      } else {
        print('Delete All Message Successes');
        emit(NotificationSuccessState());
        showSnackBar(
            context: context,
            text: deleteAllNotificationsResponse!['message'],
            success: true);
        await getAllNotifications(context: context, isLoading: false);
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }


  void onClick({required int id, required BuildContext context, required String slug}) async {
    print(id.toString());
    DocumentSnapshot<Map<String, dynamic>> group = await FirebaseFirestore.instance.collection('groups').doc("$id").get();
    if(group.exists){
      print('موجود ياباشااااا');
      if (group['active'] == false && group['finished'] == false) {
        showSnackBar(context: context, text: LocaleKeys.GroupBegin.tr(), success: false);
      } else if (group['active'] == true && group['finished'] == false) {
        joinMeeting(roomText: slug, context: context);
      } else if (group['active'] == false && group['finished'] == true) {
        showSnackBar(context: context, text: LocaleKeys.GroupEnd.tr(), success: false);
      }
    }else if (!group.exists){
      print('مش موجود ياباشااااا');
      showSnackBar(context: context, text: LocaleKeys.DeletedGroup.tr(), success: false);
    }

    emit(GetGroupState());
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
      FeatureFlag.isAudioMuteButtonEnabled : true ,
      FeatureFlag.isAudioOnlyButtonEnabled : false ,
      FeatureFlag.isVideoMuteButtonEnabled : true ,
      FeatureFlag.isFilmstripEnabled : true ,
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
      FeatureFlag.isRaiseHandEnabled: true,
      FeatureFlag.isTileViewEnabled: true,
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
        onConferenceTerminated: (url, error)async {
          await getAllNotifications(isLoading: false, context: context);
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
        onClosed: ()async {
          await getAllNotifications(isLoading: false, context: context);
        },
      ),
    );}
}
