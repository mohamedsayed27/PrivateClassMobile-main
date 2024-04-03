import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_loading.dart';
import 'package:private_courses/components/custom_toast.dart';
import 'package:private_courses/components/empty_list.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/screens/common/btnNavBar/view/custom_btn_nav_bar_view.dart';
import 'package:private_courses/screens/common/drawer/components/custom_zoom_drawer.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import '../../../../components/custom_appBar.dart';
import '../../../../components/style/size.dart';
import '../../../../generated/locale_keys.g.dart';
import '../components/groups_item.dart';
import '../controller/groups_cubit.dart';
import '../controller/groups_state.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => GroupsCubit()..getGroups(context),
        child:
            BlocConsumer<GroupsCubit, GroupsStates>(listener: (context, state) {
          if (state is GetGroupsError) {
            showSnackBar(context: context, text: state.msg!, success: false);
          }
        }, builder: (context, state) {
          final cubit = GroupsCubit.get(context);
          return WillPopScope(
            onWillPop: ()async{
              navigateAndFinish(context: context, widget: CustomZoomDrawer(mainScreen: CustomBtnNavBarScreen(page: 0,isTeacher: CacheHelper.getData(key: AppCached.role)), isTeacher: CacheHelper.getData(key: AppCached.role)));
              return true ;
            },
            child: SafeArea(
                child: Scaffold(
                    body: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: width(context) * 0.04),
                        child: Column(children: [
                          CustomAppBar(
                            isNotify: false,
                            textAppBar: LocaleKeys.Groups.tr(),
                            onTapBack: (){
                              navigateAndFinish(context: context, widget: CustomZoomDrawer(mainScreen: CustomBtnNavBarScreen(page: 0,isTeacher: CacheHelper.getData(key: AppCached.role)), isTeacher: CacheHelper.getData(key: AppCached.role)));},
                            isDrawer: false
                          ),
                          SizedBox(height: height(context) * 0.01),
                          state is GetGroupsLoading
                              ? CustomLoading(load: true)
                              : cubit.grpsList.isEmpty
                                  ? const Expanded(child: const EmptyList())
                                  : Expanded(
                                      child: ListView.separated(
                                          physics: const BouncingScrollPhysics(),
                                          itemCount: cubit.grpsList.length,
                                          itemBuilder: (context, index) =>
                                              GroupsItem(
                                                onTap: () {
                                                  cubit.onClick(
                                                      context: context,
                                                      index: index,
                                                      slug: cubit
                                                          .grpsList[index].slug!);
                                                },
                                                groupDate:
                                                    cubit.grpsList[index].date,
                                                groupName: cubit
                                                    .grpsList[index].groupName!,
                                                groupDetails:
                                                    cubit.grpsList[index].details,
                                                groupId: int.parse(cubit
                                                    .grpsList[index].groupId
                                                    .toString()),
                                                groupLink:
                                                    cubit.grpsList[index].link,
                                                from: cubit.grpsList[index].time,
                                                canEdit:
                                                    !cubit.grpsList[index].finish,
                                              ),
                                          separatorBuilder: (BuildContext context,
                                                  int index) =>
                                              SizedBox(
                                                  height:
                                                      height(context) * 0.01)))
                        ])))),
          );
        }));
  }
}
