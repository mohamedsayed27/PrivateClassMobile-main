import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:private_courses/components/cannot_access_content.dart';
import 'package:private_courses/components/custom_text.dart';
import 'package:private_courses/components/style/colors.dart';
import 'package:private_courses/components/style/images.dart';
import 'package:private_courses/components/style/size.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/generated/locale_keys.g.dart';
import 'package:private_courses/screens/common/btnNavBar/controller/custom_btn_nav_bar_cubit.dart';
import 'package:private_courses/screens/common/btnNavBar/controller/custom_btn_nav_bar_states.dart';
import 'package:private_courses/shared/local/cache_helper.dart';

class CustomBtnNavBarScreen extends StatelessWidget {
  final String isTeacher;
  final int page;
 const CustomBtnNavBarScreen({super.key, required this.isTeacher, required this.page});


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CustomBtnNavBarCubit()..getPage(page),
      child: BlocBuilder<CustomBtnNavBarCubit, CustomBtnNavBarStates>(
          builder: (context, state) {
        final cubit = CustomBtnNavBarCubit.get(context);
        return KeyboardDismissOnTap(
            child: KeyboardVisibilityBuilder(builder: (context, visible) {
          return SafeArea(
            bottom: false,
            child: Scaffold(
              body: isTeacher == "teacher"
                  ? cubit.btnWidget2[cubit.currentIndex!]
                  : cubit.btnWidget1[cubit.currentIndex!],
              bottomNavigationBar: visible
                  ? null
                  : Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade200,
                            spreadRadius: 3,
                            blurRadius: 5)
                      ]),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(13),
                            topLeft: Radius.circular(13)),
                        child: isTeacher == "teacher"
                            ? BottomNavigationBar(
                                items: [
                                  BottomNavigationBarItem(
                                      label: LocaleKeys.Home.tr(),
                                      icon: cubit.currentIndex == 0
                                          ? Image.asset(AppImages.homeActive,
                                              scale: 2.7)
                                          : Image.asset(AppImages.homeUnSelect,
                                              scale: 2.7)),
                                  BottomNavigationBarItem(
                                      label: LocaleKeys.MyCourses.tr(),
                                      icon: cubit.currentIndex == 1
                                          ? Image.asset(AppImages.bookSelect,
                                              scale: 2.7)
                                          : Image.asset(AppImages.bookUnSelect,
                                              scale: 2.7)),
                                  BottomNavigationBarItem(
                                      label: LocaleKeys.ContactUs.tr(),
                                      icon: cubit.currentIndex == 2
                                          ? Image.asset(AppImages.contactSelected,
                                          scale: 2.7)
                                          : Image.asset(AppImages.contactUnSelected,
                                          scale: 2.7)),
                                  BottomNavigationBarItem(
                                      label: LocaleKeys.Profile.tr(),
                                      icon: cubit.currentIndex == 3
                                          ? Image.asset(
                                              AppImages.profileSelected,
                                              scale: 2.7)
                                          : Image.asset(
                                              AppImages.profileUnSelected,
                                              scale: 2.7))
                                ],
                                type: BottomNavigationBarType.fixed,
                                onTap: (int index) {
                                  if (CacheHelper.getData(key: AppCached.token) != null) {
                                    cubit.changePage(context: context, page: index);
                                  } else {print("no tokennn");
                                    if (index != 0) {
                                      print("no tokennn");
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            CannotAccessContent(),
                                      );
                                    }
                                  }
                                  ;
                                },
                                currentIndex: cubit.currentIndex!,
                                selectedItemColor: AppColors.navyBlue,
                                unselectedItemColor: Colors.grey,
                                elevation: 10,
                                backgroundColor: Colors.white,
                              )
                            : BottomNavigationBar(
                                items: [
                                  BottomNavigationBarItem(
                                      label: LocaleKeys.Home.tr(),
                                      icon: cubit.currentIndex == 0
                                          ? Image.asset(AppImages.homeActive,
                                              scale: 2.7)
                                          : Image.asset(AppImages.homeUnSelect,
                                              scale: 2.7)),
                                  BottomNavigationBarItem(
                                      label: LocaleKeys.MyCourses.tr(),
                                      icon: cubit.currentIndex == 1
                                          ? Image.asset(AppImages.bookSelect,
                                              scale: 2.7)
                                          : Image.asset(AppImages.bookUnSelect,
                                              scale: 2.7)),
                                  BottomNavigationBarItem(
                                      label: LocaleKeys.Store.tr(),
                                      icon: cubit.currentIndex == 2
                                          ? Image.asset(
                                          AppImages.shopSelect,
                                          scale: 2.7)
                                          : Image.asset(
                                          AppImages.shopUnSelect,
                                          scale: 2.7)),
                                  BottomNavigationBarItem(
                                      label: LocaleKeys.ShoppingCart.tr(),
                                      icon: cubit.currentIndex == 3
                                          ? Stack(
                                        alignment: AlignmentDirectional.topStart,
                                        children: [
                                          Image.asset(AppImages.cartSelect, scale: 2.7),
                                          CacheHelper.getData(key: AppCached.cartCount)!=0 &&CacheHelper.getData(key: AppCached.token)!=null?
                                          Positioned(
                                            top: -5.3,
                                            right: -0.2,
                                            child: Container(
                                                padding: EdgeInsets.all(width(context)*0.012),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: AppColors.mainColor
                                                ),
                                                child: CustomText(
                                                    text:CacheHelper.getData(key: AppCached.cartCount).toString(),
                                                    color: Colors.white,
                                                    fontSize: 7)),
                                          ): SizedBox.shrink()
                                        ],
                                      )
                                          : Stack(
                                        alignment: AlignmentDirectional.topStart,
                                        children: [
                                          Image.asset(AppImages.cartUnSelect,
                                              scale: 2.7),
                                          CacheHelper.getData(key: AppCached.cartCount)!=0 &&CacheHelper.getData(key: AppCached.token)!=null?
                                          Positioned(
                                            top: -5.3,
                                            right: -0.2,
                                            child: Container(
                                                padding: EdgeInsets.all(width(context)*0.012),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: AppColors.greyTextColor
                                                ),
                                                child: CustomText(
                                                    text:CacheHelper.getData(key: AppCached.cartCount).toString(),
                                                    color: Colors.white,
                                                    fontSize: 7)),
                                          ): SizedBox.shrink()
                                        ],
                                      )),
                                  BottomNavigationBarItem(
                                      label: LocaleKeys.ContactUs.tr(),
                                      icon: cubit.currentIndex == 4
                                          ? Image.asset(AppImages.contactSelected,
                                              scale: 2.7)
                                          : Image.asset(AppImages.contactUnSelected,
                                              scale: 2.7)),


                                ],
                                type: BottomNavigationBarType.fixed,
                                onTap: (int index) {
                                  if (CacheHelper.getData(key: AppCached.token) != null) {
                                    cubit.changePage(context: context, page: index);
                                  } else {
                                    print("no tokennn");
                                    if (index != 0) {print("no tokennn");
                                      showDialog(
                                        context: context,
                                        builder: (context) => CannotAccessContent(),
                                      );
                                    }
                                  };
                                },
                                currentIndex: cubit.currentIndex!,
                                selectedItemColor: AppColors.navyBlue,
                                unselectedItemColor: Colors.grey,
                                elevation: 10,
                                backgroundColor: Colors.white,
                              ),
                      ),
                    ),
            ),
          );
        }));
      }),
    );
  }
}
