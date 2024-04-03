import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/my_navigate.dart';
import '../../../../components/custom_appBar.dart';
import '../../../../components/custom_loading.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../chat_details/view/chat_details_view.dart';
import '../components/chat_empty.dart';
import '../components/item_chat.dart';
import '../controller/chats_cubit.dart';
import '../controller/chats_states.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatsCubit()..getUsers(isBack: false),
      child: BlocBuilder<ChatsCubit, ChatsStates>(builder: (context, state) {
        final cubit = ChatsCubit.get(context);
        return SafeArea(
          child: Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: width(context) * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAppBar(isNotify: false,isDrawer: false,textAppBar: LocaleKeys.Chats.tr()),
                  // CustomText(
                  //     text: LocaleKeys.Chats.tr(),
                  //     color: AppColors.navyBlue,
                  //     fontSize: AppFonts.t6),
                  SizedBox(height: height(context) * 0.02),
                  FutureBuilder(
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CustomLoading(load: true),
                        );
                      } else {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                                'errrrrrrrror >>>>>>>>>>>>>>> ${snapshot.error}'),
                          );
                        } else {
                          return state is GetUsersLoading
                                ? const CustomLoading(load: true)
                                :cubit.users.isEmpty
                                  ? const Expanded(child: ChatEmpty())
                                  : Expanded(
                                      child: ListView.separated(
                                          physics: const BouncingScrollPhysics(),
                                          padding: EdgeInsetsDirectional.only(
                                              top: height(context) * 0.01),
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) => ItemChat(
                                                  onTapChatDetails: () {
                                                    navigateTo(context,
                                                        ChatDetailsScreen(
                                                            receiverImage: cubit.users[index].photoUrl.toString(),
                                                            receiverId: cubit.users[index].userId.toString(),
                                                            receiverName: cubit.users[index].name.toString(),
                                                            valueChanged: (value) async {await cubit.getUsers(isBack: true);
                                                            }));
                                                  },
                                                  image: cubit.users[index].photoUrl.toString(),
                                                  message: cubit.lastMsgList[index],
                                                  name: cubit.users[index].name.toString(),
                                                  numOfMessages: cubit.unReadList[index].toString(),
                                                  date: cubit.lastTimeList[index]),
                                          separatorBuilder: (context, index) => Padding(padding: EdgeInsetsDirectional.only(top: height(context) * 0.015, bottom: height(context) * 0.02), child: Image.asset(AppImages.lineWidth, height: height(context) * 0.01)),
                                          itemCount: cubit.users.length));
                        }
                      }
                    }, future: null,
                  ),
                  SizedBox(height: height(context) * 0.01)
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
