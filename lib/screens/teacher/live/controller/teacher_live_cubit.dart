import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import 'package:private_courses/components/custom_toast.dart';
import 'package:private_courses/screens/teacher/live/controller/teacher_live_states.dart';
import 'package:private_courses/screens/teacher/live/model/lives_model.dart';
import '../../../../core/local/app_cached.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/local/cache_helper.dart';

class TeacherLiveCubit extends Cubit<TeacherLiveStates> {
  TeacherLiveCubit() : super(TeacherLiveInitialState());

  static TeacherLiveCubit get(context) => BlocProvider.of(context);

  Map<dynamic, dynamic>? getLivesResponse;

  LivesModel? livesModel;


    int? currentLiveIndex;
  List<LivesModel> lives = [] ;
  List liveStatus = [] ;
  Future<void> getLives({required BuildContext ? context}) async {
    emit(GetLivesLoading());
    currentLiveIndex=null;
    lives.clear();
    liveStatus.clear();
    await FirebaseFirestore.instance.collection('lives').orderBy('date',descending: true).get().then((value) {
      value.docs.forEach((element) {
       if(element["user_id"].toString()== CacheHelper.getData(key: AppCached.userId).toString()){
         lives.add(LivesModel(
           docName: element.id,
             liveName: element['live_name'],
             roomStudent: element['slug'],
             date: element['date'],
             time: element['time'],
             details: element['details'],
             link: element['link'],
             active: element['active'],
             finish: element['finished']
         ));
       } else{
         print("not my user");
       }
      });
      print(lives);
    });
    emit(GetLivesSuccess());
  }

  /// live time ... time of day
  /// current time ... time of day
  /// current date ... date time
  /// live date ... date time

  DateTime? liveDate;
  DateTime? dateNow;
  TimeOfDay? liveTime ;
  TimeOfDay? timeNow ;

  void onClick({required BuildContext context,required int index})async{
    currentLiveIndex=index;
    DateTime now = DateTime.now();
    dateNow = DateTime(now.year,now.month,now.day);
    liveDate = DateTime.parse(lives[index].date);
    timeNow = TimeOfDay.now();
    liveTime = TimeOfDay(hour:int.parse(lives[index].time.split(":")[0]),minute: int.parse(lives[index].time.split(":")[1]));
    if((dateNow!.isAtSameMomentAs(liveDate!)&& ((timeNow!.hour>=liveTime!.hour)&&(timeNow!.minute>=liveTime!.minute))&&(lives[index].finish==false))
    ||
    (dateNow!.isAtSameMomentAs(liveDate!)&& ((timeNow!.hour>=liveTime!.hour)&&(timeNow!.minute<liveTime!.minute))&&(lives[index].finish==false))){
      joinMeeting(roomText: lives[index].roomStudent!,context: context);
    }else if ((lives[index].active==false)&&(lives[index].finish==true)){
      showSnackBar(context: context, text: LocaleKeys.BroadcastCompleted.tr(), success: true);
    }else if ((dateNow!.isAtSameMomentAs(liveDate!)&& ((timeNow!.hour<=liveTime!.hour))&&(lives[index].finish==false))
        ||
        (dateNow!.isAtSameMomentAs(liveDate!)&& ((timeNow!.hour<=liveTime!.hour)&&(timeNow!.minute<=liveTime!.minute))&&(lives[index].finish==false))){
      showSnackBar(context: context, text: LocaleKeys.MomentsBroadcast.tr(), success: true);
    }else if (dateNow!.isBefore(liveDate!)&&(lives[index].finish==false)){
      showSnackBar(context: context, text: LocaleKeys.NotDay.tr(), success: true);
    }else if (dateNow!.isAfter(liveDate!)&& (lives[index].active==false)&&(lives[index].finish==false)){
      showSnackBar(context: context, text: LocaleKeys.TimeEndLive.tr(), success: true);
    }
  }

  String? text({required int index}){
    DateTime now = DateTime.now();
    dateNow = DateTime(now.year,now.month,now.day);
    liveDate = DateTime.parse(lives[index].date);
    timeNow = TimeOfDay.now();
    liveTime = TimeOfDay(hour:int.parse(lives[index].time.split(":")[0]),minute: int.parse(lives[index].time.split(":")[1]));

    if((dateNow!.isAtSameMomentAs(liveDate!)&& ((timeNow!.hour>=liveTime!.hour)&&(timeNow!.minute>=liveTime!.minute))&&(lives[index].finish==false))
        ||
        (dateNow!.isAtSameMomentAs(liveDate!)&& ((timeNow!.hour>=liveTime!.hour)&&(timeNow!.minute<liveTime!.minute))&&(lives[index].finish==false))) {
      return LocaleKeys.BroadcastNow.tr();
    }else if ((lives[index].active==false)&&(lives[index].finish==true)){
      return LocaleKeys.BroadcastCompleted.tr();
    }else if ((dateNow!.isAtSameMomentAs(liveDate!)&& ((timeNow!.hour<=liveTime!.hour))&&(lives[index].finish==false))
        ||
        (dateNow!.isAtSameMomentAs(liveDate!)&& ((timeNow!.hour<=liveTime!.hour)&&(timeNow!.minute<=liveTime!.minute))&&(lives[index].finish==false))){
      return LocaleKeys.MomentsBroadcast.tr();
    }else if (dateNow!.isBefore(liveDate!)&&(lives[index].finish==false)){
      return LocaleKeys.NotDay.tr();
    }else if (dateNow!.isAfter(liveDate!)&& (lives[index].active==false)&&(lives[index].finish==false)){
      return LocaleKeys.TimeEndLive.tr();
    }

    return text(index: index);
  }

 joinMeeting({required String roomText, required BuildContext context}) async {
    Map<FeatureFlag, bool> featureFlags = {
      FeatureFlag.isWelcomePageEnabled: false,
      FeatureFlag.isAddPeopleEnabled: false,
      FeatureFlag.isCalendarEnabled: false,
      FeatureFlag.isCallIntegrationEnabled: false,
      FeatureFlag.isChatEnabled: true,
      FeatureFlag.isOverflowMenuEnabled : true ,
      FeatureFlag.areSecurityOptionsEnabled : false ,
      FeatureFlag.isAndroidScreensharingEnabled : false ,
      FeatureFlag.isAudioMuteButtonEnabled : true ,
      FeatureFlag.isAudioOnlyButtonEnabled : true ,
      FeatureFlag.isVideoMuteButtonEnabled : true ,
      FeatureFlag.isFilmstripEnabled : true ,
      FeatureFlag.isPipEnabled : false ,
      FeatureFlag.isReactionsEnabled : false ,
      FeatureFlag.isHelpButtonEnabled : false ,
      FeatureFlag.isReplaceParticipantEnabled : true ,
      FeatureFlag.isInviteEnabled: false,
      FeatureFlag.isLiveStreamingEnabled: false,
      FeatureFlag.isMeetingNameEnabled: false,
      FeatureFlag.isMeetingPasswordEnabled: false,
      FeatureFlag.isToolboxAlwaysVisible: true,
      FeatureFlag.isCloseCaptionsEnabled: false,
      FeatureFlag.isRecordingEnabled: true,
      FeatureFlag.isIosRecordingEnabled: false,
      FeatureFlag.isRaiseHandEnabled: false,
      FeatureFlag.isTileViewEnabled: true,
      FeatureFlag.isVideoShareButtonEnabled: false,
      FeatureFlag.isToolboxEnabled: true,
      FeatureFlag.isConferenceTimerEnabled: true,
      FeatureFlag.isServerUrlChangeEnabled: false,
      FeatureFlag.isIosScreensharingEnabled: false,
      FeatureFlag.isKickoutEnabled: true,
      FeatureFlag.isAudioFocusDisabled: false,
      FeatureFlag.isFullscreenEnabled: true,
      FeatureFlag.isLobbyModeEnabled: false,
      FeatureFlag.isNotificationsEnabled: true,
      FeatureFlag.isPrejoinPageEnabled:false,

    };


    // Define meetings options here
    var options =  JitsiMeetingOptions(
        roomNameOrUrl: roomText,
        userDisplayName: CacheHelper.getData(key: AppCached.name).toString(),
        userAvatarUrl:CacheHelper.getData(key: AppCached.image).toString(),
        userEmail : CacheHelper.getData(key: AppCached.email).toString(),
        isAudioOnly : false,
        isAudioMuted : false,
        isVideoMuted : false,
        // overflowMenuEnabled :true,
        featureFlags: featureFlags,
    );
    debugPrint("JitsiMeetingOptions: $options");

    await JitsiMeetWrapper.joinMeeting(
      options: options,
      listener: JitsiMeetingListener(
        onOpened: () => debugPrint("onOpened"),
        onConferenceWillJoin: (url) {
          debugPrint("onConferenceWillJoin: url: $url");
        },
        onConferenceJoined: onConferenceJoined,
        onConferenceTerminated: (url, error) async{
          FirebaseFirestore.instance.collection('lives').doc(lives[currentLiveIndex!].docName).update({
            'active': false,
            'finished': true
          });
          debugPrint("Finished Yaa Teacher مبرووووووووووووووك $error");
          await getLives(context: context);
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
        onClosed: ()async{
          FirebaseFirestore.instance.collection('lives').doc(lives[currentLiveIndex!].docName).update({
            'active': false,
            'finished': true
          });
          debugPrint("Finished Yaa Teacher مبرووووووووووووووك ");
          await getLives(context: context);
        },
      ),

      // onConferenceJoined: onConferenceJoined,
      // onConferenceTerminated: (message)async{
      //   FirebaseFirestore.instance.collection('lives').doc(lives[currentLiveIndex!].docName).update({
      //     'active': false,
      //     'finished': true
      //   });
      //   debugPrint("Finished Yaa Teacher مبرووووووووووووووك $message");
      //   await getLives(context: context);
      // },
    );
  }

  Future onConferenceJoined(message) async{
    await FirebaseFirestore.instance.collection('lives').doc(lives[currentLiveIndex!].docName).update({
      'active': true,
      'finished': false
    });
    debugPrint("Joined Yaa Teacher مبروووووووووووووك $message");
  }
  // void onConferenceTerminated(message)async {
  //   await FirebaseFirestore.instance.collection('lives').doc(lives[currentLiveIndex!].docName).update({
  //     'active': false,
  //     'finished': true
  //   });
  //   debugPrint("Finished Yaa Teacher مبرووووووووووووووك $message");
  // }
}

