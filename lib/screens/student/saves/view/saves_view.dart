import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_loading.dart';
import 'package:private_courses/components/empty_list.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/screens/common/btnNavBar/view/custom_btn_nav_bar_view.dart';
import 'package:private_courses/screens/common/drawer/components/custom_zoom_drawer.dart';
import 'package:private_courses/screens/student/saves/controller/saves_cubit.dart';
import 'package:private_courses/screens/student/saves/controller/saves_states.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import '../../../../components/custom_appBar.dart';
import '../../../../components/style/size.dart';
import '../../../../generated/locale_keys.g.dart';
import '../components/courses_save_item.dart';


class SavesScreen extends StatelessWidget {
  const SavesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SavesCubit()..fetchSaves(context: context),
        child: BlocBuilder<SavesCubit, SavesStates>(builder: (context, state) {
          final cubit = SavesCubit.get(context);
          return SafeArea(
              child: Scaffold(
                  body: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width(context) * 0.04),
                      child: Column(children: [
                        CustomAppBar(
                          isNotify: false,
                          isDrawer: false,
                          textAppBar: LocaleKeys.Saves.tr(),
                          onTapBack: () {
                            navigateAndFinish(
                                widget: CustomZoomDrawer(
                                    mainScreen: CustomBtnNavBarScreen(
                                        page: 0,
                                        isTeacher: CacheHelper.getData(
                                            key: AppCached.role)),
                                    isTeacher: CacheHelper.getData(
                                        key: AppCached.role)),
                                context: context);
                          },
                        ),
                        SizedBox(height: height(context) * 0.01),
                        state is LoadingState
                            ? const CustomLoading(load: true)
                            : cubit.savesModel!.data!.isEmpty
                                ? const Expanded(child: EmptyList())
                                : // Padding(
                                //  padding: EdgeInsetsDirectional.only(
                                //     top: 0.01 * height(context),
                                //    bottom: 0.05 * height(context),
                                //    start: 0.01 * width(context),
                                //   ),
                                //     child: Row(
                                //     children: List.generate(
                                //       cubit.names.length,
                                //       (index) => Expanded(
                                //         child: InkWell(
                                //           borderRadius: BorderRadius.circular(25),
                                //           onTap: () {
                                //             cubit.changeColor(index);
                                //           },
                                //           child: Container(
                                //            padding: EdgeInsetsDirectional.only(top: width(context)*0.016,
                                //            bottom: width(context)*0.016, ),
                                //            margin: EdgeInsetsDirectional.only(
                                //              end: width(context)*0.016
                                //            ),
                                //            decoration:
                                //            cubit.currentIndex==index
                                //             ?
                                //            BoxDecoration(
                                //               image: const DecorationImage(
                                //                 image: AssetImage(AppImages.backSaves),
                                //                 fit: BoxFit.fill
                                //               ),
                                //              borderRadius:
                                //                   BorderRadius.circular(25),
                                //             ):
                                //            BoxDecoration(
                                //              border: Border.all(color: AppColors.navyBlue),
                                //              borderRadius:
                                //              BorderRadius.circular(25),
                                //            ),
                                //             child: Center(
                                //               child: CustomText(
                                //                 text: cubit.names[index],
                                //                 color: cubit.currentIndex == index
                                //                     ? AppColors.whiteColor
                                //                     : AppColors.navyBlue,
                                //                fontSize: AppFonts.t6,
                                //               ),
                                //             ),
                                //          ),
                                //         ),
                                //      ),
                                //     ),
                                //   ),
                                // ),
                                //cubit.currentIndex==0?
                                Expanded(
                                    child: GridView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              mainAxisSpacing: 4,
                                              crossAxisSpacing: 11,
                                              childAspectRatio: 1.72 / 2.4),
                                      itemBuilder: (context, index) {
                                        return CoursesSaveItem(
                                            index: index, cubit: cubit);
                                      },
                                      itemCount: cubit.savesModel!.data!.length,
                                    ),
                                  )
                      ]))));
        }));
  }
}
