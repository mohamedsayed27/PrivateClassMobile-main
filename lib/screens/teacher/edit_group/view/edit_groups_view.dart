import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_loading.dart';
import 'package:private_courses/components/custom_text.dart';
import 'package:private_courses/components/custom_toast.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:private_courses/screens/teacher/create_group/model/all_users_model.dart';
import '../../../../components/custom_appBar.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/custom_textfield.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../generated/locale_keys.g.dart';
import '../controller/edit_groups_cubit.dart';
import '../controller/edit_groups_state.dart';

class EditGroupsScreen extends StatelessWidget {
  final int groupId;

  EditGroupsScreen({required this.groupId});

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    return BlocProvider(
        create: (context) => EditGroupsCubit()..getGroup(context, groupId),
        child: BlocConsumer<EditGroupsCubit, EditGroupsStates>(
            listener: ((context, state) {
          if (state is EditGroupSuccessState) {
            showSnackBar(context: context, text: state.msg!, success: true);
          } else if (state is EditGroupErrorState) {
            showSnackBar(context: context, text: state.msg!, success: false);
          }
        }), builder: (context, state) {
          final cubit = EditGroupsCubit.get(context);
          return SafeArea(
              child: GestureDetector(
                  onTap: () {
                    currentFocus.unfocus();
                  },
                  child: Scaffold(
                      body: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width(context) * 0.04),
                          child: Form(
                              key: cubit.formKey,
                              child: Column(children: [
                                CustomAppBar(
                                  isNotify: false,
                                  textAppBar: LocaleKeys.EditGroup.tr(),
                                ),
                                SizedBox(height: height(context) * 0.02),
                                state is GetGroupLoadingState
                                    ? CustomLoading(load: true)
                                    : Expanded(
                                        child: SingleChildScrollView(
                                            physics: BouncingScrollPhysics(),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CustomText(
                                                      text: LocaleKeys.EditGroup
                                                          .tr(),
                                                      color: AppColors.navyBlue,
                                                      fontSize: AppFonts.t5),
                                                  SizedBox(
                                                      height: height(context) *
                                                          0.04),
                                                  //************************** Group Name **********************************************/
                                                  CustomText(
                                                      text:
                                                          "${LocaleKeys.GroupName.tr()}:"),
                                                  SizedBox(
                                                      height: height(context) *
                                                          0.02),
                                                  CustomTextFormField(
                                                    ctrl: cubit.nameController,
                                                    type: TextInputType.text,
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                      horizontal:
                                                          width(context) *
                                                              0.040,
                                                      vertical: width(context) *
                                                          0.040,
                                                    ),
                                                    onValidate: (value) {
                                                      if (value!.isEmpty) {
                                                        return LocaleKeys
                                                            .ErrorText.tr();
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                  SizedBox(
                                                      height: height(context) *
                                                          0.03),
                                                  //************************** Group Date **********************************************/
                                                  CustomText(
                                                      text:
                                                          "${LocaleKeys.GroupDate.tr()}:"),
                                                  SizedBox(
                                                      height: height(context) *
                                                          0.02),
                                                  CustomTextFormField(
                                                    isOnlyRead: true,
                                                    ctrl: cubit
                                                        .dateInputController,
                                                    type: TextInputType.text,
                                                    hint: LocaleKeys
                                                        .GroupCreateDate.tr(),
                                                    prefixIcon: Image.asset(
                                                      AppImages.dateBirth,
                                                      scale: 4.2,
                                                    ),
                                                    onValidate: (value) {
                                                      if (value!.isEmpty) {
                                                        return LocaleKeys
                                                            .ErrorText.tr();
                                                      }
                                                      return null;
                                                    },
                                                    ontap: () async {
                                                      await showDatePicker(
                                                          context: context,
                                                          initialDate:
                                                              DateTime.now(),
                                                          firstDate:
                                                              DateTime.now(),
                                                          lastDate:
                                                              DateTime.parse(
                                                                  "4000-01-01"),
                                                          builder:
                                                              (context, child) {
                                                            return Theme(
                                                              data: Theme.of(
                                                                      context)
                                                                  .copyWith(
                                                                colorScheme:
                                                                    const ColorScheme
                                                                        .light(
                                                                  primary: AppColors
                                                                      .mainColor,
                                                                  onPrimary:
                                                                      AppColors
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
                                                                  ),
                                                                ),
                                                              ),
                                                              child: child!,
                                                            );
                                                          }).then((value) {
                                                        cubit.pickedDate(
                                                            value: value,
                                                            context: context);
                                                      });
                                                    },
                                                  ),
                                                  SizedBox(
                                                      height: height(context) *
                                                          0.03),
                                                  //************************** Group Time **********************************************/
                                                  CustomText(
                                                      text:
                                                          "${LocaleKeys.GroupTime.tr()}:"),
                                                  SizedBox(
                                                      height: height(context) *
                                                          0.02),
                                                  SizedBox(
                                                    width:
                                                        width(context) * 0.44,
                                                    child: CustomTextFormField(
                                                      isOnlyRead: true,
                                                      ctrl:
                                                          cubit.fromController,
                                                      type: TextInputType.text,
                                                      hint:
                                                          LocaleKeys.From.tr(),
                                                      prefixIcon: Image.asset(
                                                        AppImages.clock,
                                                        scale: 2.1,
                                                      ),
                                                      onValidate: (value) {
                                                        if (value!.isEmpty) {
                                                          return LocaleKeys
                                                              .ErrorText.tr();
                                                        }
                                                        return null;
                                                      },
                                                      ontap: () async {
                                                        await showTimePicker(
                                                            context: context,
                                                            initialTime:
                                                                TimeOfDay.now(),
                                                            builder: (context,
                                                                child) {
                                                              return MediaQuery(
                                                                  data: MediaQuery.of(
                                                                          context)
                                                                      .copyWith(
                                                                          alwaysUse24HourFormat:
                                                                              true),
                                                                  child: Theme(
                                                                      data: Theme.of(context).copyWith(
                                                                          colorScheme: const ColorScheme.light(
                                                                            primary:
                                                                                AppColors.mainColor,
                                                                            onPrimary:
                                                                                AppColors.whiteColor,
                                                                            onSurface:
                                                                                Colors.black,
                                                                          ),
                                                                          textButtonTheme: TextButtonThemeData(
                                                                              style: TextButton.styleFrom(
                                                                            foregroundColor:
                                                                                AppColors.mainColor, // button text color
                                                                          ))),
                                                                      child: child!));
                                                            }).then((value) {
                                                          cubit.pickedTime(
                                                              value: value!,
                                                              context: context);
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: height(context) *
                                                          0.02),
                                                  //************************** Choose Students **********************************************/
                                                  // CustomTextFormField(
                                                  //   isOnlyRead: true,
                                                  //   hint:
                                                  //   "${LocaleKeys.ChooseStudents.tr()} ",
                                                  //   hintStyle: TextStyle(
                                                  //     color:
                                                  //     AppColors.blackColor,
                                                  //     fontWeight:
                                                  //     FontWeight.bold,
                                                  //   ),
                                                  //   contentPadding:
                                                  //   EdgeInsets.symmetric(
                                                  //     horizontal:
                                                  //     width(context) *
                                                  //         0.040,
                                                  //     vertical: width(context) *
                                                  //         0.040,
                                                  //   ),
                                                  //   ontap: () async {
                                                  //     await showModalBottomSheet(
                                                  //       shape:
                                                  //       RoundedRectangleBorder(
                                                  //         borderRadius:
                                                  //         BorderRadius
                                                  //             .vertical(
                                                  //           top: Radius.circular(
                                                  //               height(context) *
                                                  //                   0.05),
                                                  //         ),
                                                  //       ),
                                                  //       isScrollControlled:
                                                  //       true,
                                                  //       context: context,
                                                  //       builder: (ctx) {
                                                  //         return MultiSelectBottomSheet(
                                                  //           searchHint:
                                                  //           LocaleKeys
                                                  //               .SearchOf
                                                  //               .tr(),
                                                  //           title: Padding(
                                                  //             padding: EdgeInsets
                                                  //                 .symmetric(
                                                  //                 horizontal:
                                                  //                 width(context) *
                                                  //                     0.04),
                                                  //             child: CustomText(
                                                  //                 text: LocaleKeys
                                                  //                     .ChooseStudents
                                                  //                     .tr()),
                                                  //           ),
                                                  //           listType:
                                                  //           MultiSelectListType
                                                  //               .CHIP,
                                                  //           searchable: true,
                                                  //           selectedColor:
                                                  //           Colors.blue,
                                                  //           selectedItemsTextStyle:
                                                  //           TextStyle(
                                                  //               color: Colors
                                                  //                   .black),
                                                  //           items: List.generate(
                                                  //               cubit
                                                  //                   .allUsersModel!
                                                  //                   .users
                                                  //                   .length,
                                                  //                   (index) => MultiSelectItem<Users>(
                                                  //                   cubit.allUsersModel!
                                                  //                       .users[
                                                  //                   index],
                                                  //                   cubit
                                                  //                       .allUsersModel!
                                                  //                       .users[
                                                  //                   index]
                                                  //                       .name)),
                                                  //           initialValue: cubit
                                                  //               .mySelectedUsers,
                                                  //           onConfirm:
                                                  //               (values) {
                                                  //             // print(values);
                                                  //             // cubit.mySelectedUsers = values;
                                                  //             // cubit.usersId = values.map((user) => user.id).toList();
                                                  //             // debugPrint("${cubit.usersId}");
                                                  //             cubit.onConfirm(
                                                  //                 values);
                                                  //           },
                                                  //           maxChildSize: 0.5,
                                                  //         );
                                                  //       },
                                                  //     );
                                                  //   },
                                                  // ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      CustomText(
                                                          text:
                                                              "${LocaleKeys.ChooseStudents.tr()}:"),
                                                      SizedBox(
                                                          width:
                                                              width(context) *
                                                                  0.35,
                                                          child: CustomButton(
                                                              colored: true,
                                                              onPressed:
                                                                  () async {
                                                                await showModalBottomSheet(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .vertical(
                                                                        top: Radius.circular(height(context) *
                                                                            0.05),
                                                                      ),
                                                                    ),
                                                                    isScrollControlled:
                                                                        true,
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (ctx) {
                                                                      return StatefulBuilder(
                                                                          builder: (context, setState) =>
                                                                              MultiSelectBottomSheet(
                                                                                searchHint: LocaleKeys.SearchOf.tr(),
                                                                                title: Padding(
                                                                                  padding: EdgeInsets.symmetric(horizontal: width(context) * 0.04),
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Row(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        children: [
                                                                                          SizedBox(
                                                                                              width: width(context) * 0.07,
                                                                                              child: Checkbox(
                                                                                                  value: cubit.selectAll,
                                                                                                  onChanged: (val) {
                                                                                                    print(val);
                                                                                                    setState(() {
                                                                                                      cubit.changeAll(context);
                                                                                                    });
                                                                                                  })),
                                                                                          SizedBox(width: width(context) * 0.02),
                                                                                          CustomText(text: LocaleKeys.SelectAll.tr(), fontSize: AppFonts.t8),
                                                                                        ],
                                                                                      ),
                                                                                      SizedBox(width: width(context) * 0.08),
                                                                                      CustomText(text: LocaleKeys.ChooseStudents.tr()),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                listType: MultiSelectListType.CHIP,
                                                                                searchable: true,
                                                                                onSelectionChanged: (val) {setState(() {
                                                                                  if (cubit.selectAll == true) {
                                                                                    setState((){
                                                                                      cubit.selectAll = false;
                                                                                      cubit.selectUsers(val);
                                                                                    });
                                                                                  }
                                                                                });},
                                                                                items: List.generate(cubit.allUsersModel!.users.length, (index) => MultiSelectItem<Users>(cubit.allUsersModel!.users[index], cubit.allUsersModel!.users[index].name)),
                                                                                initialValue: cubit.mySelectedUsers,
                                                                                onConfirm: (values) {
                                                                                  values.forEach((element) {
                                                                                    setState((){
                                                                                      cubit.usersss.add(element.id);
                                                                                    });
                                                                                  });
                                                                                  var distinctIds = cubit.usersss.toSet().toList();
                                                                                  if(listEquals(distinctIds, cubit.usersId)){
                                                                                    print("موجود قبل كده");
                                                                                  }else{
                                                                                    if (cubit.selectAll == false) {
                                                                                        cubit.selectUsers(values);
                                                                                        cubit.usersId = values.map((e) => e.id).toList();
                                                                                      } else {
                                                                                        cubit.selectUsers(values);
                                                                                      }

                                                                                  }
                                                                                },
                                                                                // separateSelectedItems: false,

                                                                                maxChildSize: 0.5,
                                                                              ));
                                                                    });
                                                              },
                                                              fontSize: AppFonts.t6,
                                                              text: LocaleKeys.AddAStudent.tr()))
                                                    ]
                                                  ),
                                                  SizedBox(
                                                      height: height(context) * 0.02),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors
                                                            .grey.shade200,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(
                                                            height(context) *
                                                                0.05),
                                                      ),
                                                    ),
                                                    child:
                                                        MultiSelectChipDisplay(
                                                      alignment: Alignment.topLeft,
                                                      icon: Icon(Icons.cancel),
                                                      items: cubit.mySelectedUsers.map((user) => MultiSelectItem(user, user.name)).toList(),
                                                      onTap: (value) {
                                                        print(value);
                                                        cubit.removeSelected(value);
                                                        print(cubit.mySelectedUsers);
                                                        print(cubit.usersId);
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: height(context) *
                                                          0.03),
                                                  //************************** Group Description **********************************************/
                                                  CustomText(
                                                      text:
                                                          "${LocaleKeys.GroupDetails.tr()}:"),
                                                  SizedBox(
                                                      height: height(context) *
                                                          0.02),
                                                  CustomTextFormField(
                                                    ctrl:
                                                        cubit.detailController,
                                                    type: TextInputType.text,
                                                    maxLines: 5,
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                      horizontal:
                                                          width(context) *
                                                              0.040,
                                                      vertical: width(context) *
                                                          0.040,
                                                    ),
                                                    onValidate: (value) {
                                                      if (value!.isEmpty) {
                                                        return LocaleKeys
                                                            .ErrorText.tr();
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                  SizedBox(
                                                      height: height(context) *
                                                          0.05),
                                                  //************************** Create Group Button **********************************************/
                                                  state is EditGroupLoadingState
                                                      ? CustomLoading(
                                                          load: false)
                                                      : CustomButton(
                                                          colored: true,
                                                          text: LocaleKeys
                                                              .EditGroup.tr(),
                                                          onPressed: () {
                                                            if (cubit.formKey
                                                                .currentState!
                                                                .validate()) {
                                                              cubit.updateGroup(
                                                                  context,
                                                                  groupId);
                                                              debugPrint(
                                                                  "$groupId");
                                                            }
                                                          }),
                                                  SizedBox(
                                                      height: height(context) *
                                                          0.02)
                                                ])))
                              ]))))));
        }));
  }
}
