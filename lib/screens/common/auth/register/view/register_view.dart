import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_loading.dart';
import 'package:private_courses/generated/locale_keys.g.dart';
import '../../../../../components/custom_button.dart';
import '../../../../../components/custom_phone_field.dart';
import '../../../../../components/custom_text.dart';
import '../../../../../components/custom_textfield.dart';
import '../../../../../components/my_navigate.dart';
import '../../../../../components/style/colors.dart';
import '../../../../../components/style/images.dart';
import '../../../../../components/style/size.dart';
import '../../../../../core/local/app_cached.dart';
import '../../../../../shared/local/cache_helper.dart';
import '../../login/view/login_view.dart';
import '../components/dropDown_item.dart';
import '../components/stack_gender.dart';
import '../controller/register_cubit.dart';
import '../controller/register_states.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    return GestureDetector(
       onTap: (){
         currentFocus.unfocus();
       },
      child: BlocProvider(
          create: (context) => RegisterCubit()..getData(context: context),
          child: BlocBuilder<RegisterCubit, RegisterStates>(
              builder: (context, state) {
            final cubit = RegisterCubit.get(context);
            return SafeArea(
              child: Scaffold(
                body: SingleChildScrollView(
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppImages.authBackground),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Form(
                      key: cubit.formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width(context) * 0.05,
                                    vertical: height(context) * 0.02),
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Image.asset(
                                        context.locale.languageCode == "ar"
                                            ? AppImages.leftArrow
                                            : AppImages.leftArrowEn,
                                        width: width(context) * 0.09))),
                            SizedBox(
                              height: height(context) * 0.058,
                            ),
                            Center(
                                child: Image.asset(
                              AppImages.logo,
                              width: width(context) * 0.27,
                            )),
                            SizedBox(
                              height: height(context) * 0.05,
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: width(context),
                                decoration: const BoxDecoration(
                                    color: AppColors.whiteColor,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(40),
                                        topLeft: Radius.circular(40))),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: height(context) * 0.02,
                                    right: width(context) * 0.05,
                                    left: width(context) * 0.05,
                                  ),
                                  child: Column(
                                    children: [
                                      CustomText(
                                          text: LocaleKeys.NewAcc.tr(),
                                          fontWeight: FontWeight.bold,
                                          fontSize: AppFonts.t5,
                                          color: AppColors.navyBlue),
                                      SizedBox(height: height(context) * 0.03),
                                      CustomTextFormField(
                                          hint: LocaleKeys.FullName.tr(),
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    width(context) * 0.034),
                                            child: Image.asset(
                                              AppImages.fullName,
                                              width: width(context) * 0.02,
                                            ),
                                          ),
                                          type: TextInputType.text,
                                          ctrl: cubit.nameController),
                                      SizedBox(height: height(context) * 0.015),
                                      CustomPhoneField(
                                          hint: LocaleKeys.PhoneNum.tr(),
                                          onChangedCode: (phone) {
                                            cubit.getPhoneKey(phone.code);
                                          },
                                          onChangedPhone: (phone) {
                                            cubit.getPhone(phone.number);
                                          }),
                                      SizedBox(
                                        height: height(context) * 0.015,
                                      ),
                                      CustomTextFormField(
                                          hint: LocaleKeys.Email.tr(),
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    width(context) * 0.034),
                                            child: Image.asset(AppImages.email,
                                                width: width(context) * 0.02),
                                          ),
                                          type: TextInputType.emailAddress,
                                          ctrl: cubit.emailController),
                                      SizedBox(
                                        height: height(context) * 0.015,
                                      ),
                                      CustomTextFormField(
                                          hint: LocaleKeys.Password.tr(),
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    width(context) * 0.034),
                                            child: Image.asset(
                                                context.locale.languageCode ==
                                                        "ar"
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
                                                  horizontal:
                                                      width(context) * 0.03),
                                              child: Image.asset(
                                                  cubit.isSecure
                                                      ? AppImages.hiddenEye
                                                      : AppImages.eye,
                                                  width: width(context) * 0.05),
                                            ),
                                          ),
                                          maxLines: 1),
                                      SizedBox(
                                        height: height(context) * 0.015,
                                      ),
                                      state is GetDataLoadingState
                                          ? const CustomLoading(load: false)
                                          : CacheHelper.getData(key: AppCached.isTeacher) == true
                                              ? DropDownItem(
                                                  hint: LocaleKeys
                                                      .SelectSubjectName.tr(),
                                                  items: List.generate(
                                                      cubit.subjectsModel!.data!
                                                          .length,
                                                      (index) => DropdownMenuItem<String>(
                                                          value: cubit
                                                              .subjectsModel!
                                                              .data![index]
                                                              .id
                                                              .toString(),
                                                          child: CustomText(
                                                              text: cubit
                                                                  .subjectsModel!
                                                                  .data![index]
                                                                  .name!,
                                                              fontSize: AppFonts.t7,
                                                              color: AppColors.navyBlue))),
                                                  onChanged: (value) {
                                                    cubit.changeDropVal(value);
                                                  },
                                                  dropDownValue: cubit.dropValue)
                                              : DropDownItem(
                                                  hint: LocaleKeys.SelectGrade.tr(),
                                                  items: List.generate(cubit.stagesModel!.data!.length, (index) => DropdownMenuItem<String>(value: cubit.stagesModel!.data![index].id.toString(), child: CustomText(text: cubit.stagesModel!.data![index].name!, fontSize: AppFonts.t7, color: AppColors.navyBlue))),
                                                  onChanged: (value) {
                                                    cubit.changeDropVal2(value);
                                                  },
                                                  dropDownValue: cubit.dropValue2),
                                      const StackGender(),
                                      state is RegisterLoadingState
                                          ? const CustomLoading(load: false)
                                          : CustomButton(
                                              onPressed: ()async {
                                                currentFocus.unfocus();
                                                await cubit.register(context: context);
                                              },
                                              text: LocaleKeys.NewAcc.tr(),
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
                                      //       onPressed: (){
                                      //        cubit.signWitFaceBook(context: context);
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
                                      Platform.isIOS ?SizedBox(height: height(context) * 0.02) :SizedBox(height: height(context) * 0.01),
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
                                      //
                                      //     SizedBox(width: width(context)*0.07),
                                      //     GestureDetector(
                                      //       onTap: ()  {},
                                      //       child: Image.asset(AppImages.twitterIcon, scale: 2),
                                      //     ),
                                      //     SizedBox(width: width(context)*0.07),
                                      //     GestureDetector(
                                      //         onTap: () {
                                      //           //cubit.signInWithFacebook();
                                      //         },
                                      //         child: Image.asset(AppImages.facebookIcon, scale: 2)),
                                      //     Platform.isIOS?SizedBox(width: width(context)*0.07):const SizedBox.shrink(),
                                      //     Platform.isIOS?GestureDetector(
                                      //       onTap: ()  {},
                                      //       child: Image.asset(AppImages.appleICon, scale: 2),
                                      //     ):const SizedBox.shrink(),
                                      //     SizedBox(width: width(context)*0.02),
                                      //   ],
                                      // ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: height(context) * 0.03),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CustomText(
                                                text: LocaleKeys.HaveAcc.tr(),
                                                color: AppColors.mainColor,
                                                fontSize: AppFonts.t6,
                                                fontWeight: FontWeight.bold),
                                            SizedBox(
                                                width: width(context) * 0.015),
                                            GestureDetector(
                                                onTap: () {
                                                  navigateTo(context,
                                                      const LoginScreen());
                                                },
                                                child: CustomText(
                                                    text:
                                                        LocaleKeys.LoginNow.tr(),
                                                    color: AppColors.goldColor,
                                                    fontSize: AppFonts.t6,
                                                    fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
            );
          })),
    );
  }
}
