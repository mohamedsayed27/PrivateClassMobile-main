import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/screens/common/chat_details/controller/chat_details_cubit.dart';
import 'package:private_courses/screens/common/chat_details/controller/chat_details_states.dart';
import '../../../../components/custom_loading.dart';
import '../../../../components/style/size.dart';
import '../../../../core/local/app_cached.dart';
import '../../../../shared/local/cache_helper.dart';
import 'message.dart';

class Chats extends StatelessWidget {
  final String receiverId;

  const Chats({Key? key, required this.receiverId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatDetailsCubit, ChatDetailsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return FutureBuilder(builder: (context, snapshot) {
            return state is ChatLoadingMsg
                ? const CustomLoading(load: true)
                : StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc('userId_${CacheHelper.getData(key: AppCached.userId)}')
                        .collection('chats')
                        .doc('receiver_id_$receiverId')
                        .collection('messages')
                        .orderBy('updated_at', descending: true)
                        .snapshots(),
                    builder: (ctx, snapshot) {
                      if (!snapshot.hasData || snapshot.connectionState == ConnectionState.none) {
                        return const CustomLoading(load: true);
                      } else {
                        if (snapshot.hasError) {
                          return Center(
                              child: Text(
                                  'errrrrrrrror >>>>>>>>>>>>> ${snapshot.error}'));
                        } else {
                          final docs = snapshot.data!.docs;

                          return state is ChatLoadingMsg
                              ? const CustomLoading(load: true)
                              : ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width(context) * 0.01),
                                  itemCount: snapshot.data!.docs.length,
                                  shrinkWrap: true,
                                  reverse: true,
                                  itemBuilder: (context, index) {
                                    return MessageChat(
                                        isMe: CacheHelper.getData(
                                                        key: AppCached.userId)
                                                    .toString() ==
                                                docs[index]['sender_id']
                                            ? true
                                            : false,
                                        msg: docs[index]['message'],
                                        time: docs[index]['updated_at'],
                                        msgType: docs[index]['type'],
                                        image: docs[index]['receiver_id'] !=
                                                docs[index]['sender_id']
                                            ? docs[index]['sender_image']
                                            : docs[index]['receiver_image']);
                                  },
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                          height: height(context) * 0.005));
                        }
                      }
                    });
          }, future: null,);
        });
  }
}
