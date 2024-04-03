import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_appBar.dart';
import 'package:private_courses/components/custom_button.dart';
import 'package:private_courses/components/custom_loading.dart';
import 'package:private_courses/components/custom_text.dart';
import 'package:private_courses/components/custom_textfield.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/components/style/colors.dart';
import 'package:private_courses/components/style/images.dart';
import 'package:private_courses/components/style/size.dart';
import 'package:private_courses/screens/common/profile/components/bottom_sheet.dart';
import 'package:private_courses/screens/student/form_checkout/controller/form_checkout_cubit.dart';
import 'package:private_courses/screens/student/form_checkout/controller/form_checkout_states.dart';
import 'package:private_courses/screens/student/home/components/custom_filter/components/custom_dropdown.dart';
import '../../../../generated/locale_keys.g.dart';

class FormCheckoutScreen extends StatelessWidget {
  final int? courseId;

  final bool isCart;

  const FormCheckoutScreen({super.key, this.courseId, required this.isCart});

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    return GestureDetector(
      onTap: () {
        currentFocus.unfocus();
      },
      child: BlocProvider(
        create: (context) => FormCheckoutCubit()..getBanks(context: context),
        child: BlocBuilder<FormCheckoutCubit, FormCheckoutStates>(
            builder: (context, state) {
          final cubit = FormCheckoutCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: width(context) * 0.04),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomAppBar(
                          isNotify: false,
                          textAppBar: LocaleKeys.BankTransfer.tr()),
                      SizedBox(height: height(context) * 0.02),
                      state is GetBanksLoadingState
                          ? Expanded(child: CustomLoading(load: false))
                          : Expanded(
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                        text: LocaleKeys.InputBank.tr(),
                                        fontSize: AppFonts.t6,
                                        overflow: TextOverflow.ellipsis),
                                    SizedBox(height: height(context) * 0.02),
                                    CustomDropDown(
                                        hintText: LocaleKeys.SelectBank.tr(),
                                        radius: 34,
                                        colorBorder:
                                            AppColors.textFieldBackColor,
                                        items: List.generate(
                                            cubit.banksModel!.data!.length,
                                            (index) => DropdownMenuItem<String>(
                                                value: cubit.banksModel!.data![index].id.toString(),
                                                child: CustomText(
                                                    text: cubit.banksModel!.data![index].name!,
                                                    fontSize: AppFonts.t7,
                                                    color: AppColors.navyBlue))),
                                        onChanged: (value) {
                                          cubit.changeDropDown(context,value);
                                        },
                                        dropDownValue: cubit.dropDownValue),
                                    if(cubit.bankIban!=null && cubit.accNumber!=null)
                                    ...[SizedBox(height: height(context) * 0.02),
                                      CustomTextFormField(
                                        hintStyle:
                                        TextStyle(color: AppColors.grayColor),
                                        hint: "${LocaleKeys.AccNum.tr()}${cubit.accNumber}",
                                        contentPadding: EdgeInsets.symmetric(horizontal: width(context) * 0.04),
                                        isEnabled: false,
                                      ),
                                      SizedBox(height: height(context) * 0.02),
                                      CustomTextFormField(
                                        hintStyle:
                                        TextStyle(color: AppColors.grayColor),
                                        hint: "${LocaleKeys.IbanNum.tr()}${cubit.bankIban}",
                                        contentPadding: EdgeInsets.symmetric(horizontal: width(context) * 0.04),
                                        isEnabled: false,
                                      ),
                                    ],
                                    SizedBox(height: height(context) * 0.02),
                                    CustomTextFormField(
                                      hintStyle:
                                          TextStyle(color: AppColors.grayColor),
                                      hint: LocaleKeys.Amount.tr(),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: width(context) * 0.04),
                                      type: TextInputType.number,
                                      ctrl: cubit.amountCtrl,
                                    ),
                                    SizedBox(height: height(context) * 0.02),
                                    CustomTextFormField(
                                      hintStyle:
                                          TextStyle(color: AppColors.grayColor),
                                      isOnlyRead: true,
                                      hint: LocaleKeys.DateFatora.tr(),
                                      ctrl: cubit.dateCtrl,
                                      ontap: () {
                                        showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse("4000-01-01"),
                                            builder: (context, child) {
                                              return Theme(
                                                data:
                                                    Theme.of(context).copyWith(
                                                  colorScheme:
                                                      const ColorScheme.light(
                                                    primary:
                                                        AppColors.mainColor,
                                                    onPrimary:
                                                        AppColors.whiteColor,
                                                    onSurface: Colors.black,
                                                  ),
                                                  textButtonTheme:
                                                      TextButtonThemeData(
                                                    style: TextButton.styleFrom(
                                                      foregroundColor: AppColors
                                                          .mainColor, // button text color
                                                    ),
                                                  ),
                                                ),
                                                child: child!,
                                              );
                                            }).then((value) {
                                          cubit.pickedDate(
                                              value: value, context: context);
                                        });
                                      },
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: width(context) * 0.04),
                                      suffixIcon: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width(context) * 0.03),
                                        child: Image.asset(
                                            AppImages.calenderFatora,
                                            width: width(context) * 0.05),
                                      ),
                                    ),
                                    SizedBox(height: height(context) * 0.02),
                                    CustomTextFormField(
                                        hintStyle: TextStyle(
                                            color: AppColors.grayColor),
                                        hint: LocaleKeys.NameFatora.tr(),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: width(context) * 0.04),
                                        type: TextInputType.name,
                                        ctrl: cubit.adapterNameCtrl),
                                    SizedBox(height: height(context) * 0.02),
                                    CustomTextFormField(
                                        hintStyle: TextStyle(
                                            color: AppColors.grayColor),
                                        hint: LocaleKeys.ImageFatora.tr(),
                                        isOnlyRead: true,
                                        ontap: () {
                                          showModalBottomSheet(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(25),
                                                    topRight:
                                                        Radius.circular(25)),
                                              ),
                                              context: context,
                                              builder: (context) {
                                                return CustomBottomSheet(
                                                  onPressedCamera: () {
                                                    cubit.pickFromCamera(
                                                        context: context);
                                                    navigatorPop(context);
                                                  },
                                                  onPressedGallery: () {
                                                    cubit.pickFromGallery(
                                                        context: context);
                                                    navigatorPop(context);
                                                  },
                                                );
                                              });
                                        },
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: width(context) * 0.04),
                                        suffixIcon: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  width(context) * 0.03),
                                          child: Image.asset(
                                              AppImages.galleryFatora,
                                              width: width(context) * 0.05),
                                        ),
                                        ctrl: cubit.linkPhotoCtrl),
                                    cubit.file != null
                                        ? SizedBox(
                                            height: height(context) * 0.02)
                                        : SizedBox(
                                            height: height(context) * 0.03),
                                    cubit.file != null
                                        ? Center(
                                            child: Container(
                                              height: height(context) * 0.3,
                                              width: width(context) * 0.3,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  image: DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: FileImage(File(
                                                          cubit.file!.path)))),
                                            ),
                                          )
                                        : SizedBox.shrink(),
                                    cubit.file != null
                                        ? SizedBox(
                                            height: height(context) * 0.03)
                                        : SizedBox.shrink(),
                                    state is FormLoadingState
                                        ? CustomLoading(load: false)
                                        : Center(
                                            child: CustomButton(
                                                colored: true,
                                                onPressed: () {
                                                  isCart == false
                                                      ? cubit.formBank(context: context, courseId: courseId!)
                                                      : cubit.formBankCart(context: context);
                                                },
                                                text: LocaleKeys.Send.tr())),
                                  ],
                                ),
                              ),
                            ),
                    ]),
              ),
            ),
          );
        }),
      ),
    );
  }
}
