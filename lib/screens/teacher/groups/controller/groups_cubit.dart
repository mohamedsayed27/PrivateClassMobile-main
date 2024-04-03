
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import 'package:private_courses/components/custom_toast.dart';
import 'package:private_courses/generated/locale_keys.g.dart';
import 'package:private_courses/screens/teacher/live/model/lives_model.dart';
import '../../../../core/local/app_cached.dart';
import '../../../../shared/local/cache_helper.dart';
import 'groups_state.dart';

class GroupsCubit extends Cubit<GroupsStates> {
  GroupsCubit() : super(GroupsInitialState());

  static GroupsCubit get(context) => BlocProvider.of(context);

  Map<dynamic, dynamic>? groupsResponse;
  List <LivesModel> grpsList=[];
  Future<void> getGroups(BuildContext? context) async {
    emit(GetGroupsLoading());
    grpsList.clear();
    try {
      await FirebaseFirestore.instance.collection('groups').get().then((value) {
        value.docs.forEach((element) {
          if(element["user_id"].toString()== CacheHelper.getData(key: AppCached.userId).toString()){
            grpsList.add(LivesModel(
                  docName: element.id,
                active: element['active'],
                slug: element['slug'],
                date: element['date'],
                groupId: element['group_id'],
                details: element['details'],
                finish: element['finished'],
                groupName: element['group_name'],
                teacherName: element['teacher_name'],
                time: element['time'],
                link: element['link'],
            ));
          } else{
            print("not my user");
          }
        });
      });
      print(grpsList);
      // Map<String, dynamic> headers = {
      //   'Accept': 'application/json',
      //   'Content-Type': 'application/json',
      //   'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
      //   'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      // };
      // groupsResponse = await myDio(
      //     url: "${AllAppApiConfig.baseUrl}"
      //         "${AllAppApiConfig.getGroups}",
      //     methodType: "get",
      //     dioBody: null,
      //     dioHeaders: headers,
      //     appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
      //     context: context!);
      // if (groupsResponse!['status'] == false) {
      //   debugPrint(groupsResponse.toString());
      //   emit(GetGroupsError(msg: groupsResponse!['message']));
      // } else {
      //   debugPrint(groupsResponse!.toString());
      //   groupsModel = GroupsModel.fromJson(groupsResponse!);
      //   emit(GetGroupsSuccess());
      // }
      emit(GetGroupsSuccess());

    } catch (e, s) {
      print(e);
      print(s);
    }
  }



  int? currentLiveIndex;
  DateTime? grpDate;
  DateTime? dateNow;
  TimeOfDay? grpTime ;
  TimeOfDay? timeNow ;

  void onClick({required BuildContext context,required int index,required String slug})async{
    print(index);
    print(slug);
    currentLiveIndex=index;
    DateTime now = DateTime.now();
    dateNow = DateTime(now.year,now.month,now.day);
    grpDate = DateTime.parse(grpsList[index].date);
    timeNow = TimeOfDay.now();
    grpTime = TimeOfDay(hour:int.parse(grpsList[index].time.split(":")[0]),minute: int.parse(grpsList[index].time.split(":")[1]));
    print(timeNow!.hour);
    print(grpTime!.hour);
    print(timeNow!.minute);
    print(grpTime!.minute);
    if((dateNow!.isAtSameMomentAs(grpDate!)&& ((timeNow!.hour>=grpTime!.hour)&&(timeNow!.minute>=grpTime!.minute))&&(grpsList[index].finish==false))
        ||
    (dateNow!.isAtSameMomentAs(grpDate!)&& ((timeNow!.hour>=grpTime!.hour)&&(timeNow!.minute<grpTime!.minute))&&(grpsList[index].finish==false))) {
      joinMeeting(roomText: slug,context: context);
    }else if ((grpsList[index].active==false)&&(grpsList[index].finish==true)){
      showSnackBar(context: context, text: LocaleKeys.BroadcastCompleted.tr(), success: true);
    }else if ((dateNow!.isAtSameMomentAs(grpDate!)&& ((timeNow!.hour<=grpTime!.hour))&&(grpsList[index].finish==false))
        ||
        (dateNow!.isAtSameMomentAs(grpDate!)&& ((timeNow!.hour<=grpTime!.hour)&&(timeNow!.minute<=grpTime!.minute))&&(grpsList[index].finish==false))){
      showSnackBar(context: context, text: LocaleKeys.MomentsBroadcast.tr(), success: true);
    }else if (dateNow!.isBefore(grpDate!)&&(grpsList[index].finish==false)){
      showSnackBar(context: context, text: LocaleKeys.NotDay.tr(), success: true);
    }else if (dateNow!.isAfter(grpDate!)&& (grpsList[index].active==false)&&(grpsList[index].finish==false)){
      showSnackBar(context: context, text: LocaleKeys.TimeEnd.tr(), success: true);
      }
  }




  joinMeeting({required String roomText,required BuildContext context}) async {

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
      FeatureFlag.isReplaceParticipantEnabled : false ,
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
      FeatureFlag.isPrejoinPageEnabled:false
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
      featureFlags: featureFlags,
    );


    debugPrint("JitsiMeetingOptions: $options");

    await JitsiMeetWrapper.joinMeeting(
        options:options,
        listener:JitsiMeetingListener(
      onConferenceJoined: onConferenceJoined,
      onConferenceTerminated: (message,url) async{
        await FirebaseFirestore.instance.collection('groups').doc(grpsList[currentLiveIndex!].docName).update({
          'active': false,
          'finished': true
        });
        debugPrint("Joined Yaa Teacher مبروووووووووووووك $message");
        await getGroups(context);
      },
          onClosed: ()async{
            await FirebaseFirestore.instance.collection('groups').doc(grpsList[currentLiveIndex!].docName).update({
              'active': false,
              'finished': true
            });
            debugPrint("Joined Yaa Teacher مبروووووووووووووك ");
            await getGroups(context);
          }
    ));
  }

  Future onConferenceJoined(message) async{
    await FirebaseFirestore.instance.collection('groups').doc(grpsList[currentLiveIndex!].docName).update({
      'active': true,
      'finished': false
    });
    debugPrint("Joined Yaa Teacher مبروووووووووووووك $message");
  }
  void onConferenceTerminated(message)async {
    await FirebaseFirestore.instance.collection('groups').doc(grpsList[currentLiveIndex!].docName).update({
      'active': false,
      'finished': true
    });
    debugPrint("Finished Yaa Teacher مبرووووووووووووووك $message");
  }
}
