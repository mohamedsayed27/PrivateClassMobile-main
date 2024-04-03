import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_button.dart';
import 'package:private_courses/components/custom_loading.dart';
import 'package:private_courses/components/custom_text.dart';
import 'package:private_courses/components/custom_textfield.dart';
import 'package:private_courses/components/style/colors.dart';
import 'package:private_courses/generated/locale_keys.g.dart';
import 'package:private_courses/screens/teacher/home_teacher/components/live/controller/live_cubit.dart';

import '../../../../../../components/style/images.dart';
import '../../../../../../components/style/size.dart';
import '../controller/live_states.dart';

class CreateLiveView extends StatelessWidget {
  CreateLiveView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => LiveCubit(),
        child: BlocBuilder<LiveCubit, LiveStates>(
          builder: (context, state) {
            final cubit = LiveCubit.get(context);
            return Padding(
              padding: EdgeInsetsDirectional.only(
                  top: height(context) * 0.05,
                  start: width(context) * 0.05,
                  end: width(context) * 0.05,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SizedBox(
                height: height(context) * 0.8,
                child: SingleChildScrollView(
                    physics:  BouncingScrollPhysics(),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: CustomText(
                                text: LocaleKeys.NewLive.tr(),
                                color: AppColors.navyBlue),
                          ),
                          SizedBox(height: height(context) * 0.05),
                          Form(
                            key: cubit.formKey,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                      text: "${LocaleKeys.LectureName.tr()} :"),
                                  SizedBox(height: height(context) * 0.02),
                                  CustomTextFormField(
                                      hint: "${LocaleKeys.LectureName.tr()}",
                                      ctrl: cubit.lectureNameCtrl,
                                      type: TextInputType.text,
                                      onValidate: (val) {
                                        if (val!.isEmpty) {
                                          return LocaleKeys.ErrorText.tr();
                                        }
                                        return null;
                                      },
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: width(context) * 0.04,
                                          vertical: width(context) * 0.04)),
                                  SizedBox(height: height(context) * 0.02),
                                  CustomText(
                                      text: "${LocaleKeys.LiveDate.tr()} :"),
                                  SizedBox(height: height(context) * 0.02),
                                  CustomTextFormField(
                                      ctrl: cubit.liveDateCtrl,
                                      isOnlyRead: true,
                                      onValidate: (val) {
                                        if (val!.isEmpty) {
                                          return LocaleKeys.ErrorText.tr();
                                        }
                                        return null;
                                      },
                                      hint: LocaleKeys.LiveDate.tr(),
                                      prefixIcon: Image.asset(
                                          AppImages.dateBirth,
                                          scale: 4.2),
                                      ontap: ()  {
                                         showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime.parse("4000-01-01"),
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
                                      }),
                                  SizedBox(height: height(context) * 0.02),
                                  CustomText(
                                      text: "${LocaleKeys.LiveTime.tr()} :"),
                                  SizedBox(height: height(context) * 0.02),
                                  CustomTextFormField(
                                      ctrl: cubit.liveTimeCtrl,
                                      onValidate: (val) {
                                        if (val!.isEmpty) {
                                          return LocaleKeys.ErrorText.tr();
                                        }
                                        return null;
                                      },
                                      isOnlyRead: true,
                                      hint: LocaleKeys.LiveTime.tr(),
                                      prefixIcon: Image.asset(AppImages.clock,
                                          scale: 2.1),
                                      ontap: () async {
                                        await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                            builder: (context, child) {
                                              return MediaQuery(
                                                  data: MediaQuery.of(context)
                                                      .copyWith(
                                                          alwaysUse24HourFormat:
                                                              true),
                                                  child: Theme(
                                                      data: Theme.of(context)
                                                          .copyWith(
                                                              colorScheme:
                                                                  const ColorScheme
                                                                      .light(
                                                                primary: AppColors
                                                                    .mainColor,
                                                                onPrimary: AppColors
                                                                    .whiteColor,
                                                                onSurface:
                                                                    Colors
                                                                        .black,
                                                              ),
                                                              textButtonTheme:
                                                                  TextButtonThemeData(
                                                                      style: TextButton
                                                                          .styleFrom(
                                                                foregroundColor:
                                                                    AppColors
                                                                        .mainColor, // button text color
                                                              ))),
                                                      child: child!));
                                            }).then((value) {
                                          cubit.pickedTime(
                                              value: value!, context: context);
                                        });
                                      }),
                                  SizedBox(height: height(context) * 0.02),
                                  CustomText(
                                      text: "${LocaleKeys.LiveDetails.tr()} :"),
                                  SizedBox(height: height(context) * 0.02),
                                  CustomTextFormField(
                                      hint: "${LocaleKeys.LiveDetails.tr()}",
                                      maxLines: 4,
                                      ctrl: cubit.detailsCtrl,
                                      type: TextInputType.text,
                                      onValidate: (val) {
                                        if (val!.isEmpty) {
                                          return LocaleKeys.ErrorText.tr();
                                        }
                                        return null;
                                      },
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: width(context) * 0.04,
                                          vertical: width(context) * 0.04)),
                                  SizedBox(height: height(context) * 0.03),
                                  state is CreateLiveLoading
                                      ? CustomLoading(load: false)
                                      : CustomButton(
                                          colored: true,
                                          onPressed: ()  {
                                             cubit.createLive(context);
                                          },
                                          text: LocaleKeys.Create.tr()),
                                ]),
                          ),
                          SizedBox(height: height(context) * 0.02),
                        ])),
              ),
            );
          },
        ));
  }
}
