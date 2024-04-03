import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_loading.dart';
import '../../../../components/custom_appBar.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/custom_phone_field.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/custom_textfield.dart';
import '../../../../components/my_navigate.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../core/local/app_cached.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/local/cache_helper.dart';
import '../../profile/components/bottom_sheet.dart';
import '../components/dropDown_item.dart';
import '../controller/edit_profile_cubit.dart';
import '../controller/edit_profile_state.dart';

class EditProfileScreen extends StatelessWidget {
  final String isTeacher;
  const EditProfileScreen({Key? key, required this.isTeacher})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    return BlocProvider(
      create: (context) => EditProfileCubit()..getData(context: context),
      child: BlocBuilder<EditProfileCubit, EditProfileStates>(
        builder: (context, state) {
          final cubit = EditProfileCubit.get(context);
          return GestureDetector(
            onTap: () {
              currentFocus.unfocus();
            },
            child: Scaffold(
              body: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: width(context) * 0.04),
                child: Form(
                  key: cubit.formKey,
                  child: Column(
                    children: [
                      CustomAppBar(
                          isNotify: false,
                          textAppBar: LocaleKeys.EditProfile.tr()),
                      state is GetProfileLoadingState
                          ? const CustomLoading(load: true)
                          : Expanded(
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  children: [
                                    SizedBox(height: height(context) * 0.01),
                                    CircleAvatar(
                                      radius: 48,
                                      backgroundColor: AppColors.whiteColor,
                                      backgroundImage: cubit.file == null
                                          ? NetworkImage(CacheHelper.getData(key: AppCached.image))
                                          : FileImage(File(cubit.file!.path)) as ImageProvider,
                                    ),
                                    SizedBox(height: height(context) * 0.024),
                                    GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(25),
                                                  topRight:
                                                      Radius.circular(25)),
                                            ),
                                            context: context,
                                            builder: (BuildContext cont) {
                                              return CustomBottomSheet(
                                                onPressedCamera: () {
                                                  cubit.pickFromCamera(context: context);
                                                  navigatorPop(context);
                                                },
                                                onPressedGallery: () {
                                                  cubit.pickFromGallery(context: context);
                                                  navigatorPop(context);
                                                },
                                              );
                                            });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.camera_alt_outlined,
                                            color: AppColors.mainColor,
                                          ),
                                          CustomText(
                                              text:
                                                  ' ${LocaleKeys.ChangeImage.tr()}',
                                              color: AppColors.greyTextColor,
                                              fontSize: AppFonts.t7,
                                              decoration:
                                                  TextDecoration.underline),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: height(context) * 0.06),
                                    CustomTextFormField(
                                      hint: LocaleKeys.FullName.tr(),
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width(context) * 0.034),
                                        child: Image.asset(
                                          AppImages.fullName,
                                          width: width(context) * 0.02,
                                        ),
                                      ),
                                      type: TextInputType.name,
                                      ctrl: cubit.nameController,
                                    ),
                                    SizedBox(height: height(context) * 0.02),
                                    CustomPhoneField(
                                        hint: LocaleKeys.PhoneNum.tr(),
                                        ctrl: cubit.phoneController,
                                        phoneKey: cubit.phoneKey,
                                        onChangedCode: (phone) {
                                          cubit.getPhoneKey(phone.code);
                                        },
                                        onChangedPhone: (phone) {
                                          cubit.getPhone(phone.number);
                                        }),
                                    SizedBox(height: height(context) * 0.02),
                                    CustomTextFormField(
                                      hint: LocaleKeys.Email.tr(),
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width(context) * 0.034),
                                        child: Image.asset(
                                          AppImages.email,
                                          width: width(context) * 0.02,
                                        ),
                                      ),
                                      type: TextInputType.emailAddress,
                                      ctrl: cubit.emailController,
                                    ),
                                    SizedBox(height: height(context) * 0.02),
                                    isTeacher == "teacher"
                                        ? DropDownItem(
                                            hint: LocaleKeys.SelectSubjectName
                                                .tr(),
                                            items: List.generate(
                                                cubit.subjectsModel!.data!
                                                    .length,
                                                (index) => DropdownMenuItem<String>(
                                                    value: cubit.subjectsModel!
                                                        .data![index].id
                                                        .toString(),
                                                    child: CustomText(
                                                        text: cubit
                                                            .subjectsModel!
                                                            .data![index]
                                                            .name!,
                                                        fontSize: AppFonts.t7,
                                                        color: AppColors
                                                            .navyBlue))),
                                            onChanged: (value) {
                                              cubit.changeDropVal(value);
                                              debugPrint(value);
                                            },
                                            dropDownValue: cubit.dropValue)
                                        : DropDownItem(
                                            hint: LocaleKeys.SelectGrade.tr(),
                                            items: List.generate(
                                                cubit.stagesModel!.data.length, (index) => DropdownMenuItem<String>(value: cubit.stagesModel!.data[index].id.toString(), child: CustomText(text: cubit.stagesModel!.data[index].name, fontSize: AppFonts.t7, color: AppColors.navyBlue))),
                                            onChanged: (value) {
                                              cubit.changeDropValTwo(value);
                                            },
                                            dropDownValue: cubit.dropValueTwo),
                                    SizedBox(height: height(context) * 0.02),
                                    isTeacher == "teacher"
                                        ? CustomTextFormField(
                                            hint: LocaleKeys.About.tr(),
                                      hintStyle: TextStyle(color: AppColors.grayColor),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal:
                                                        width(context) * 0.07,
                                                    vertical:
                                                        width(context) * 0.01),
                                            type: TextInputType.text,
                                            ctrl: cubit.aboutYouController,
                                            maxLines: 3,
                                          )
                                        : const SizedBox.shrink(),
                                    SizedBox(height: height(context) * 0.04),
                                    state is UpDateLoadingState
                                        ? const CustomLoading(load: false)
                                        : CustomButton(
                                            colored: true,
                                            onPressed: () async {
                                              if(cubit.file != null){
                                                await cubit.upDateImage(context: context);
                                                await cubit.upDateProfile(context: context);
                                              }else{
                                              await cubit.upDateProfile(context: context);}
                                            },
                                            text: LocaleKeys.SaveEdit.tr(),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
