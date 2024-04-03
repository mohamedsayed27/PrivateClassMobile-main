import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_appBar.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/screens/common/btnNavBar/view/custom_btn_nav_bar_view.dart';
import 'package:private_courses/screens/teacher/home_teacher/components/live/view/create_live_view.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../common/drawer/components/custom_zoom_drawer.dart';
import '../../create_group/view/create_group_view.dart';
import '../components/dotted_container.dart';
import '../controller/home_teacher_cubit.dart';
import '../controller/home_teacher_states.dart';
import '../../../../core/local/app_cached.dart';
import '../../../../shared/local/cache_helper.dart';

class HomeTeacherScreen extends StatelessWidget {
  const HomeTeacherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => HomeTeacherCubit(),
        child: BlocBuilder<HomeTeacherCubit, HomeTeacherStates>(
            builder: (context, state) {
          final cubit = HomeTeacherCubit.get(context);
          return Scaffold(
              body: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width(context) * 0.04),
                  child: Column(children: [
                    CustomAppBar(isNotify: true),
                    Expanded(
                        child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(children: [
                        GestureDetector(
                          onTap: (){
                            navigateAndFinish(
                                context: context,
                                widget: CustomZoomDrawer(
                                    mainScreen: CustomBtnNavBarScreen(
                                        page: 3,
                                        isTeacher: CacheHelper.getData(key: AppCached.role)),
                                    isTeacher: CacheHelper.getData(key: AppCached.role)));
                          },
                          child: Row(
                            children: [
                              CircleAvatar(
                                  backgroundColor: AppColors.whiteColor,
                                  radius: 20,
                                  backgroundImage: NetworkImage(
                                      CacheHelper.getData(key: AppCached.image))),
                              SizedBox(width: width(context) * 0.03),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                      text:
                                          "${LocaleKeys.Welcome.tr()} ${CacheHelper.getData(key: AppCached.name)}",
                                      color: AppColors.navyBlue),
                                  CustomText(
                                      text: CacheHelper.getData(key: AppCached.subject)??"",
                                      color: AppColors.goldColor,
                                      fontSize: AppFonts.t8),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height(context) * 0.025,
                        ),
                        DottedContainer(
                          text: LocaleKeys.CreateLive.tr(),
                          img: AppImages.live,
                          backImg: AppImages.blueDotedContainer,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                                isScrollControlled: true,
                              isDismissible: true,
                              builder: (context) => CreateLiveView(),
                              backgroundColor: AppColors.whiteColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(height(context) * 0.05),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: height(context) * 0.02,
                        ),
                        DottedContainer(
                          text: LocaleKeys.CreateGroup.tr(),
                          img: AppImages.groupIcon,
                          backImg: AppImages.goldDotedContainer,
                          onTap: () {
                            navigateTo(
                                context,
                                CustomZoomDrawer(
                                  isTeacher: CacheHelper.getData(key: AppCached.role),
                                  mainScreen: const CreateGroupView(),
                                ));
                          },
                        )
                      ]),
                    )),
                  ])));
        }));
  }
}
