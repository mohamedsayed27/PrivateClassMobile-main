import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/local/app_cached.dart';
import '../../../../core/local/global_config.dart';
import '../../../../shared/local/cache_helper.dart';
import '../../../../shared/remote/dio.dart';
import '../../../student/course_details/model/chat_user_model.dart';
import 'chat_details_states.dart';

class ChatDetailsCubit extends Cubit<ChatDetailsStates> {
  ChatDetailsCubit() : super(ChatDetailsInitialState());

  static ChatDetailsCubit get(context) => BlocProvider.of(context);

  /// Createeeeeeeeeeeeeeee ///

  Future<void> createUser({required UsersModel? receiver, required UsersModel? sender}) async {
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






  String? imagePath;
  File? file;

  final messageController = TextEditingController();

  Map<dynamic, dynamic>? imageResponse;

  Future<void> sendImage(
      {required BuildContext context,
      required String type,
      required String receiverId,
      required String receiverImage,
      required String senderImage}) async {
    debugPrint(" >>>>>>>>>>>>>> Send Image Loading <<<<<<<<<<<<<<<<<<<<<");
    emit(SendImageLoading());

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
      imageResponse = await myDio(
        appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
        dioHeaders: headers,
        url: AllAppApiConfig.baseUrl + AllAppApiConfig.sendImage,
        methodType: 'post',
        dioBody: formData,
        context: context,
      );

      if (imageResponse!['status'] == false) {
        debugPrint(">>>>>>>>>>>>>>> Send Image Find Error <<<<<<<<<<<");
        debugPrint(imageResponse.toString());
        emit(SendImageError());
      } else {
        debugPrint(
            ">>>>>>>>>>>>>>>>>>>>> Send Image Success <<<<<<<<<<<<<<<<<<<<<<<<");
        debugPrint(imageResponse!.toString());
        imagePath = imageResponse!["data"];
        debugPrint("${imagePath!} <<<<<<<<<<<<<<<< Image Path Is Here ");
        await sendMsg(
            receiverId: receiverId,
            senderId: CacheHelper.getData(key: AppCached.userId).toString(),
            dateTime: Timestamp.now(),
            context: context,
            type: type,
            receiverImage: receiverImage,
            senderImage: senderImage);
        file = null;
        imagePath = null;
        emit(SendImageSuccess());
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    debugPrint(
        ">>>>>>>>>>>>>>>>>>>>> Finishing Send Image Success <<<<<<<<<<<<<<<<<<<<<<<<");
  }

  void pickFromGallery(
      {required BuildContext context,
      required String receiverId,
      required String receiverImage,
      required String senderImage}) async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile == null) return;
    file = File(pickedFile.path);
    debugPrint(file!.path);
    emit(ChatPikedPhoto());
    await sendImage(
        context: context,
        type: "image",
        receiverId: receiverId,
        receiverImage: receiverImage,
        senderImage: senderImage);
  }

  void pickFromCamera(
      {required BuildContext context,
      required String receiverId,
      required String receiverImage,
      required String senderImage}) async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 80);
    if (pickedFile == null) return;
    file = File(pickedFile.path);
    debugPrint(file!.path);
    emit(ChatPikedPhoto());
    await sendImage(
        context: context,
        type: "image",
        receiverId: receiverId,
        receiverImage: receiverImage,
        senderImage: senderImage);
  }

  sendMsg(
      {required String? receiverId,
      required String? receiverImage,
      required String? senderImage,
      required String? senderId,
      required String? type,
      required Timestamp? dateTime,
      required BuildContext? context}) async {
    FocusScope.of(context!).unfocus();
    debugPrint("message firebase ");
    print(file ?? messageController.text);
    debugPrint(dateTime.toString());
    debugPrint(receiverId);
    debugPrint(senderId);
    debugPrint(type);
    FirebaseFirestore.instance
        .collection('users')
        .doc('userId_$receiverId')
        .collection('chats')
        .doc('receiver_id_$senderId')
        .collection('messages')
        .add({
      'message': imagePath ?? messageController.text,
      'updated_at': dateTime,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'sender_image': senderImage,
      'receiver_image': receiverImage,
      'type': type,
      'read': false
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc('userId_$senderId')
        .collection('chats')
        .doc('receiver_id_$receiverId')
        .collection('messages')
        .add({
      'message': imagePath ?? messageController.text,
      'updated_at': dateTime,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'sender_image': senderImage,
      'receiver_image': receiverImage,
      'type': type,
      'read': false
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc('userId_$senderId')
        .collection('chats')
        .doc('receiver_id_$receiverId')
        .update({
      'last_message': imagePath ?? messageController.text,
      'last_message_time': dateTime
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc('userId_$receiverId')
        .collection('chats')
        .doc('receiver_id_$senderId')
        .update({
      'last_message': imagePath ?? messageController.text,
      'last_message_time': dateTime
    });
    await sendNotfications(context: context, id: receiverId);
  }

  void getMessage({required String receiverId}) async {
    emit(ChatLoadingMsg());
    FirebaseFirestore.instance
        .collection('users')
        .doc('userId_${CacheHelper.getData(key: AppCached.userId)}')
        .collection('chats')
        .doc('receiver_id_$receiverId')
        .collection('messages')
        .orderBy('updated_at', descending: true)
        .snapshots();

    /// -******************************************** 3shan a3ml elread b false  **********************************************************-

    await FirebaseFirestore.instance
        .collection('users')
        .doc('userId_${CacheHelper.getData(key: AppCached.userId)}')
        .collection('chats')
        .doc('receiver_id_$receiverId')
        .collection('messages')
        .get()
        .then((message) async {
      debugPrint("Sssssssssssssssssssssssss >>>>>>>>>>>>>>>> ${message.docs}");
      message.docs.forEach((msg) async {
        debugPrint(msg.data()["read"].toString());
        if (msg.data()["read"] == false &&
            msg.data()["receiver_id"] ==
                CacheHelper.getData(key: AppCached.userId).toString()) {
          debugPrint("\************************************************/");

          await FirebaseFirestore.instance
              .collection('users')
              .doc('userId_${CacheHelper.getData(key: AppCached.userId)}')
              .collection('chats')
              .doc('receiver_id_$receiverId')
              .collection('messages')
              .doc(msg.id)
              .update({'read': true});
        }
      });
    });
    emit(ChatSuccessMsg());
  }

  /// -*-*-*-*-*-*-*-*-*-*-*-*-* send notification -*-*-*-*-*-*-*-*-*-*-*-*

  Map<dynamic, dynamic>? sendNotificationsResponse;
  Future<void> sendNotfications({required BuildContext context,required String?id}) async {
     String msgBody = messageController.text;
     messageController.clear();
     try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      sendNotificationsResponse = await myDio(
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          dioHeaders: headers,
          url: "${AllAppApiConfig.baseUrl}${AllAppApiConfig.sendChatNotifications}$id",
          methodType: 'post',
          context: context,
          dioBody: {'body' : msgBody.isEmpty? "صورة" :msgBody});
      debugPrint("${AllAppApiConfig.baseUrl}${AllAppApiConfig.sendChatNotifications}$id");
      debugPrint(sendNotificationsResponse.toString());
      if (sendNotificationsResponse!['status'] == false) {
        emit(ChatDetailsInitialState());
      } else {
        emit(ChatDetailsInitialState());
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
  }
}
