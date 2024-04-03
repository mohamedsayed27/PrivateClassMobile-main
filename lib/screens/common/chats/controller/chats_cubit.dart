import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/local/app_cached.dart';
import '../../../../shared/local/cache_helper.dart';
import '../../../student/course_details/model/chat_user_model.dart';
import 'chats_states.dart';

class ChatsCubit extends Cubit<ChatsStates> {
  ChatsCubit() : super(ChatsInitialState());

  static ChatsCubit get(context) => BlocProvider.of(context);



  List<ReceiverModel> users = [];
  List<String> lastMsgList = [];
  List<String> lastTimeList = [];
  int unRead = 0;
  List<int> unReadList = [];
  String? lastTime;
  String? lastDate;
  Future<void> getUsers({required bool isBack}) async {
    isBack==false? emit(GetUsersLoading()):null;
    print("000000");


     // final QuerySnapshot qSnap = await FirebaseFirestore.instance.collection('users').doc('userId_${CacheHelper.getData(key: AppCached.userId)}').
    // collection('chats').get();
    // final int documentss = qSnap.docs.length;
    // print( documentss.toString() + "   length documentss");
    await FirebaseFirestore.instance.collection('users').doc('userId_${CacheHelper.getData(key: AppCached.userId)}').
    collection('chats').get().then((value) async {
      isBack==false? emit(GetUsersLoading()):null;
      print("1111111111111111");
      users.clear();
      lastTimeList.clear();
      lastMsgList.clear();
      unReadList.clear();
      for(int i =0 ; i< value.docs.length ; i++) {
        isBack==false? emit(GetUsersLoading()):null;
        final QuerySnapshot testLength = await FirebaseFirestore.instance.collection('users').doc('userId_${CacheHelper.getData(key: AppCached.userId)}').
        collection('chats').doc("receiver_id_${value.docs[i]["userId"]}").collection("messages").get();
        print(testLength.docs.length.toString() + " messages length");
        if(testLength.docs.length>1){
          print("*-*-*-*-*--*-*-*-*-*-*-*-*-* hadedy y gamddddddddddddddddddddddddddddddddddd *-*-*-*-*--*-*-*-*-*-*-*-*-*");
          await FirebaseFirestore.instance.collection('users').doc('userId_${CacheHelper.getData(key: AppCached.userId)}').collection('chats').doc("receiver_id_${value.docs[i]["userId"]}")
              .collection("messages").get().then((message) async {

            unRead = 0;
            message.docs.forEach((msg)  {
              // print(msg.data()[""])
              if (msg.data()["read"] == false &&
                  msg.data()["receiver_id"] == CacheHelper.getData(key: AppCached.userId).toString()) {
                unRead++;
              }
            });
            unReadList.add(unRead);
            debugPrint("UnRead List >>>>>>>>>> $unReadList");
          });
          lastMsgList.add(value.docs[i].data()["last_message"]);
          DateTime? timm = value.docs[i].data()["last_message_time"].toDate();
          lastTime = DateFormat('hh:mm a').format(timm!);
          lastTimeList.add(DateFormat('hh:mm a').format(timm));
          lastDate = DateFormat.yMd().format(timm);
          users.add(ReceiverModel.fromJson(value.docs[i].data()));
          // emit(GetUsersSuccess());
          isBack==false? emit(GetUsersSuccess()):null;

        }else{
          print("emshi yla 8or");
        }
      };

      emit(GetUsersSuccess());
    } );

  }
}
