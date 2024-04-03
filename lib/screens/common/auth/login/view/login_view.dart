import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/auth_body.dart';
import 'package:private_courses/components/custom_loading.dart';
import 'package:private_courses/components/style/images.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/screens/common/auth/choose_type_a_login/choose_type.dart';
import 'package:private_courses/screens/common/btnNavBar/view/custom_btn_nav_bar_view.dart';
import 'package:private_courses/screens/common/drawer/components/custom_zoom_drawer.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import '../controller/login_states.dart';
import '../../../../../components/custom_button.dart';
import '../../../../../components/custom_text.dart';
import '../../../../../components/custom_textfield.dart';
import '../../../../../components/my_navigate.dart';
import '../../../../../components/style/colors.dart';
import '../../../../../components/style/size.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../forget_pass/view/forget_pass_view.dart';
import '../controller/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    return GestureDetector(
      onTap: () {
        currentFocus.unfocus();
      },
      child: BlocProvider(
        create: (context) => LoginCubit(),
        child: BlocBuilder<LoginCubit, LoginStates>(
          builder: (context, state) {
            final cubit = LoginCubit.get(context);
            return SafeArea(
              child: Scaffold(
                body: SingleChildScrollView(
                  child: AuthBody(
                      title: LocaleKeys.Login.tr(),
                      withBackArrow: false,
                      img: AppImages.authBackground,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width(context) * 0.05),
                        child: Form(
                          key: cubit.formKey,
                          child: Column(
                            children: [
                              CustomText(
                                  text: LocaleKeys.Login.tr(),
                                  color: AppColors.navyBlue,
                                  fontSize: AppFonts.t5,
                                  fontWeight: FontWeight.bold),
                              SizedBox(height: height(context) * 0.024),
                              CustomTextFormField(
                                  hint: LocaleKeys.EmailOrPhone.tr(),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width(context) * 0.034),
                                    child: Image.asset(AppImages.email,
                                        width: width(context) * 0.02),
                                  ),
                                  type: TextInputType.emailAddress,
                                  ctrl: cubit.emailController),
                              SizedBox(height: height(context) * 0.022),
                              CustomTextFormField(
                                  hint: LocaleKeys.Password.tr(),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width(context) * 0.034),
                                    child: Image.asset(
                                        context.locale.languageCode == "ar"
                                            ? AppImages.password
                                            : AppImages.leftKey,
                                        width: width(context) * 0.02),
                                  ),
                                  type: TextInputType.visiblePassword,
                                  ctrl: cubit.passController,
                                  isSecure: cubit.isSecure,
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      cubit.changeSecurePass();
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width(context) * 0.03),
                                      child: Image.asset(
                                          cubit.isSecure
                                              ? AppImages.hiddenEye
                                              : AppImages.eye,
                                          width: width(context) * 0.05),
                                    ),
                                  ),
                                  maxLines: 1),
                              SizedBox(height: height(context) * 0.008),
                              GestureDetector(
                                  onTap: () {
                                    navigateTo(context, ForgetPassScreen());
                                  },
                                  child: Align(
                                      alignment: AlignmentDirectional.topEnd,
                                      child: CustomText(
                                          text: LocaleKeys.ForgetPass.tr(),
                                          color: AppColors.goldColor))),
                              SizedBox(height: height(context) * 0.05),
                              state is LoginLoadingState
                                  ? const CustomLoading(load: false)
                                  : CustomButton(
                                      onPressed: () async {
                                        currentFocus.unfocus();
                                        await cubit.login(context: context);
                                      },
                                      text: LocaleKeys.Login.tr(),
                                      colored: true,
                                      fontWeight: FontWeight.bold),
                              SizedBox(height: height(context) * 0.03),
                              state is LoginGoogleLoadingState?
                              CupertinoActivityIndicator(color: AppColors.mainColor):Container(
                                margin: EdgeInsets.symmetric(horizontal: width(context)*0.03),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0, 1),
                                          color: Colors.grey.shade100,
                                          spreadRadius: 3,
                                          blurRadius: 3
                                      )
                                    ]
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.black, backgroundColor: Colors.white,shadowColor:Colors.white,
                                    ),
                                    onPressed: () async {
                                      await cubit.signWitGoogle(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children:  [
                                          SizedBox(width: width(context)*0.02),
                                          Image(
                                            image: AssetImage(AppImages.gmailIcon),
                                            height: height(context)*0.04,
                                            width: width(context)*0.06,
                                          ),
                                          SizedBox(width: width(context)*0.03),
                                          const Spacer(),
                                          Text(
                                            LocaleKeys.SignGoogle.tr(),
                                            style: TextStyle(
                                              fontSize: AppFonts.t15,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const Spacer(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // SizedBox(height: height(context) * 0.02),
                              // state is LoginFaceBookLoadingState?
                              // CupertinoActivityIndicator(color: AppColors.mainColor):Container(
                              //   margin: EdgeInsets.symmetric(horizontal: width(context)*0.03),
                              //   decoration: BoxDecoration(
                              //       boxShadow: [
                              //         BoxShadow(
                              //             offset: Offset(0, 1),
                              //             color: Colors.grey.shade100,
                              //             spreadRadius: 3,
                              //             blurRadius: 3
                              //         )
                              //       ]
                              //   ),
                              //   child: ClipRRect(
                              //     borderRadius: BorderRadius.circular(10),
                              //     child: ElevatedButton(
                              //       style: ElevatedButton.styleFrom(
                              //         foregroundColor: Colors.black, backgroundColor: Colors.white,shadowColor:Colors.white,
                              //       ),
                              //       onPressed: () {
                              //         cubit.signWitFaceBook(context: context);
                              //       },
                              //       child: Padding(
                              //         padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                              //         child: Row(
                              //           mainAxisAlignment: MainAxisAlignment.center,
                              //           children:  [
                              //             SizedBox(width: width(context)*0.02),
                              //             Image(
                              //               image: AssetImage(AppImages.facebookIcon),
                              //               height: height(context)*0.04,
                              //               width: width(context)*0.055,
                              //             ),
                              //             SizedBox(width: width(context)*0.03),
                              //             const Spacer(),
                              //             Text(
                              //               LocaleKeys.SignFb.tr(),
                              //               style: TextStyle(
                              //                 fontSize: AppFonts.t15,
                              //                 color: Colors.black54,
                              //                 fontWeight: FontWeight.w600,
                              //               ),
                              //             ),
                              //             const Spacer(),
                              //           ],
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              Platform.isIOS ? SizedBox.shrink():SizedBox(height: height(context) * 0.02),
                              Platform.isIOS ? Container(
                                margin: EdgeInsets.symmetric(horizontal: width(context)*0.03),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0, 1),
                                          color: Colors.grey.shade100,
                                          spreadRadius: 3,
                                          blurRadius: 3
                                      )
                                    ]
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.black, backgroundColor: Colors.white,shadowColor:Colors.white,
                                    ),
                                    onPressed: () async {},
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children:  [
                                          SizedBox(width: width(context)*0.02),
                                          Image(
                                            image: AssetImage(AppImages.appleICon),
                                            height: height(context)*0.04,
                                            width: width(context)*0.06,
                                          ),
                                          SizedBox(width: width(context)*0.03),
                                          const Spacer(),
                                          Text(
                                            LocaleKeys.SignApple.tr(),
                                            style: TextStyle(
                                              fontSize: AppFonts.t6,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const Spacer(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ):SizedBox.shrink(),
                              Platform.isIOS ? SizedBox(height: height(context) * 0.02) :SizedBox(height: height(context) * 0.01),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                      text: LocaleKeys.HaveNoAcc.tr(),
                                      color: AppColors.mainColor,
                                      fontSize: AppFonts.t15,
                                      fontWeight: FontWeight.bold),
                                  SizedBox(width: width(context) * 0.015),
                                  GestureDetector(
                                      onTap: () {
                                        navigateTo(context,
                                            const ChooseTypeALoginScreen());
                                      },
                                      child: CustomText(
                                          text: LocaleKeys.Loggin.tr(),
                                          color: AppColors.goldColor,
                                          fontSize: AppFonts.t15,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              SizedBox(height: height(context) * 0.01),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //     state is LoginGoogleLoadingState?
                              //     CupertinoActivityIndicator(color: AppColors.mainColor):
                              //     GestureDetector(
                              //       onTap: () async {
                              //         await cubit.signWitGoogle(context);
                              //       },
                              //       child: Image.asset(AppImages.gmailIcon, scale: 2),
                              //     ),
                              //     SizedBox(width: width(context)*0.07),
                              //     GestureDetector(
                              //       onTap: ()  {},
                              //       child: Image.asset(AppImages.twitterIcon, scale: 2),
                              //     ),
                              //     SizedBox(width: width(context)*0.07),
                              //     GestureDetector(
                              //       onTap: () {
                              //         cubit.signInWithFacebook();
                              //       },
                              //       child: Image.asset(AppImages.facebookIcon, scale: 2),
                              //     ),
                              //     Platform.isIOS?SizedBox(width: width(context)*0.07):const SizedBox.shrink(),
                              //     Platform.isIOS?GestureDetector(
                              //       onTap: ()  {},
                              //       child: Image.asset(AppImages.appleICon, scale: 2),
                              //     ):const SizedBox.shrink(),
                              //     SizedBox(width: width(context)*0.02),
                              //   ],
                              // ),
                              GestureDetector(
                                  onTap: () {
                                    CacheHelper.saveData(AppCached.role, "visitor");
                                    navigateTo(
                                        context,
                                        CustomZoomDrawer(
                                          mainScreen: CustomBtnNavBarScreen(
                                              page: 0,
                                            isTeacher: CacheHelper.getData(key: AppCached.role)),
                                          isTeacher: CacheHelper.getData(key: AppCached.role)));
                                  },
                                  child: CustomText(
                                      text: LocaleKeys.VisitorLogin.tr(),
                                      color: AppColors.greyTextColor,
                                      fontSize: AppFonts.t6,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: height(context) * 0.01),
                            ],
                          ),
                        ),
                      )),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
