import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:private_courses/components/custom_appBar.dart';
import 'package:private_courses/components/custom_loading.dart';
import 'package:private_courses/components/custom_text.dart';
import 'package:private_courses/components/custom_textfield.dart';
import 'package:private_courses/components/custom_toast.dart';
import 'package:private_courses/components/style/colors.dart';
import 'package:private_courses/components/style/size.dart';
import 'package:private_courses/generated/locale_keys.g.dart';
import 'package:private_courses/screens/teacher/create_group/controller/create_group_cubit.dart';
import 'package:private_courses/screens/teacher/create_group/model/all_users_model.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/style/images.dart';
import '../controller/create_group_state.dart';

class CreateGroupView extends StatefulWidget {
  const CreateGroupView({Key? key}) : super(key: key);

  @override
  State<CreateGroupView> createState() => _CreateGroupViewState();
}

class _CreateGroupViewState extends State<CreateGroupView> {
  @override
  Widget build(BuildContext context) {
    FocusScopeNode focusScopeNode = FocusScope.of(context);
    return BlocProvider(
      create: (context) => CreateGroupCubit()..getAllUsers(context),
      child: BlocConsumer<CreateGroupCubit, CreateGroupState>(
        listener: ((context, state) {
          if (state is CreateGroupSuccessState) {
            showSnackBar(context: context, text: state.msg!, success: true);
            CreateGroupCubit.get(context).clearFields();
          } else if (state is CreateGroupErrorState) {
            showSnackBar(context: context, text: state.msg!, success: false);
          }
        }),
        builder: (context, state) {
          final cubit = CreateGroupCubit.get(context);
          return GestureDetector(
            onTap: () {
              focusScopeNode.unfocus();
            },
            child: Scaffold(
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: width(context) * 0.04),
                child: Column(
                  children: [
                    CustomAppBar(
                      isNotify: false,
                      textAppBar: LocaleKeys.CreateNewGroup.tr(),
                    ),
                    SizedBox(height: height(context) * 0.02),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Form(
                          key: cubit.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                  text: LocaleKeys.CreateGroup.tr(),
                                  color: AppColors.navyBlue,
                                  fontSize: AppFonts.t5),
                              SizedBox(height: height(context) * 0.04),
                              //************************** Group Name **********************************************/
                              CustomText(text: "${LocaleKeys.GroupName.tr()}:"),
                              SizedBox(height: height(context) * 0.02),
                              CustomTextFormField(
                                hint: "${LocaleKeys.GroupName.tr()}",
                                ctrl: cubit.groupNameCtrl,
                                type: TextInputType.text,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: width(context) * 0.040,
                                  vertical: width(context) * 0.040,
                                ),
                              ),
                              SizedBox(height: height(context) * 0.03),
                              //************************** Group Date **********************************************/
                              CustomText(text: "${LocaleKeys.GroupDate.tr()}:"),
                              SizedBox(height: height(context) * 0.02),
                              CustomTextFormField(
                                isOnlyRead: true,
                                ctrl: cubit.groupDateCtrl,
                                type: TextInputType.text,
                                hint: LocaleKeys.GroupCreateDate.tr(),
                                prefixIcon: Image.asset(
                                  AppImages.dateBirth,
                                  scale: 4.2,
                                ),
                                ontap: () async {
                                  await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse("4000-01-01"),
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme:
                                                const ColorScheme.light(
                                              primary: AppColors.mainColor,
                                              onPrimary: AppColors.whiteColor,
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
                              ),
                              SizedBox(height: height(context) * 0.03),
                              //************************** Group Time **********************************************/
                              CustomText(text: "${LocaleKeys.GroupTime.tr()}:"),
                              SizedBox(height: height(context) * 0.02),
                              CustomTextFormField(
                                isOnlyRead: true,
                                ctrl: cubit.fromCtrl,
                                type: TextInputType.text,
                                hint: LocaleKeys.GroupTime.tr(),
                                prefixIcon:
                                    Image.asset(AppImages.clock, scale: 2.1),
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
                                                              Colors.black,
                                                        ),
                                                        textButtonTheme:
                                                            TextButtonThemeData(
                                                                style: TextButton
                                                                    .styleFrom(
                                                          foregroundColor: AppColors
                                                              .mainColor, // button text color
                                                        ))),
                                                child: child!));
                                      }).then((value) {
                                    cubit.pickedTime(
                                        value: value!, context: context);
                                  });
                                },
                              ),
                              SizedBox(height: height(context) * 0.03),

                              ///************************** Choose Students **********************************************/

                              // CustomTextFormField(
                              //   isOnlyRead: true,
                              //   hint: "${LocaleKeys.ChooseStudents.tr()} :",
                              //   type: TextInputType.text,
                              //   contentPadding: EdgeInsets.symmetric(
                              //     horizontal: width(context) * 0.040,
                              //     vertical: width(context) * 0.040,
                              //   ),
                              //   ontap: () async {
                              //     await showModalBottomSheet(
                              //       shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.vertical(
                              //           top: Radius.circular(
                              //               height(context) * 0.05),
                              //         ),
                              //       ),
                              //       isScrollControlled:
                              //           true, // required for min/max child size
                              //       context: context,
                              //       builder: (ctx) {
                              //         return MultiSelectBottomSheet(
                              //           searchHint: LocaleKeys.SearchOf.tr(),
                              //           title: Padding(
                              //             padding: EdgeInsets.symmetric(
                              //                 horizontal:
                              //                     width(context) * 0.04),
                              //             child: CustomText(
                              //                 text: LocaleKeys.ChooseStudents
                              //                     .tr()),
                              //           ),
                              //           listType: MultiSelectListType.CHIP,
                              //           searchable: true,
                              //           items: cubit.allUsersModel == null
                              //               ? <MultiSelectItem<Users>>[]
                              //               : cubit.allUsersModel!.users
                              //                   .map((user) =>
                              //                       MultiSelectItem<Users>(
                              //                           user, user.name))
                              //                   .toList(),
                              //           initialValue: cubit.selectedUsers,
                              //           onConfirm: (values) {
                              //             cubit.selectUsers(values);
                              //             cubit.usersId =
                              //                 values.map((e) => e.id).toList();
                              //
                              //             debugPrint("${cubit.usersId}");
                              //           },
                              //           maxChildSize: 0.5,
                              //         );
                              //       },
                              //     );
                              //   },
                              // ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                      text:
                                          "${LocaleKeys.ChooseStudents.tr()}:"),
                                  SizedBox(
                                      width: width(context) * 0.35,
                                      child: CustomButton(
                                          colored: true,
                                          onPressed: () async {
                                            await showModalBottomSheet(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                    top: Radius.circular(
                                                        height(context) * 0.05),
                                                  ),
                                                ),
                                                isScrollControlled: true,
                                                context: context,
                                                builder: (ctx) {
                                                  return
                                                    StatefulBuilder(
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
                                                                          width:
                                                                              width(context) * 0.07,
                                                                          child: Checkbox(
                                                                              value: cubit.selectAll,
                                                                              onChanged: (val) {
                                                                                print(val);
                                                                                setState(() {
                                                                                  cubit.changeAll(context);
                                                                                });
                                                                              })),
                                                                      SizedBox(
                                                                          width:
                                                                              width(context) * 0.02),
                                                                      CustomText(
                                                                          text: LocaleKeys.SelectAll.tr(),
                                                                          fontSize: AppFonts.t8),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                      width: width(context) * 0.08),
                                                                  CustomText(
                                                                      text: LocaleKeys.ChooseStudents.tr()),
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
                                                                } else {
                                                                 setState((){
                                                                  cubit.selectUsers(val);
                                                                  print(cubit.selectedUsers.toString() + "valllllllllllll");
                                                                 });
                                                                }
                                                              });
                                                            },
                                                            items:  cubit.allUsersModel!.users.map((user) => MultiSelectItem<Users>(user, user.name)).toList(),
                                                            initialValue: cubit.selectedUsers,
                                                            separateSelectedItems: true ,

                                                            onConfirm: (values) {
                                                              if (cubit.selectAll == false) {
                                                                cubit.selectUsers(values);
                                                                cubit.usersId = values.map((e) => e.id).toList();
                                                              } else {
                                                                cubit.selectUsers(cubit.selectedUsers);
                                                              }
                                                            },
                                                            maxChildSize: 0.5,
                                                          ));
                                                });
                                          },
                                          fontSize: AppFonts.t6,
                                          text: LocaleKeys.AddAStudent.tr()))
                                ],
                              ),

                              SizedBox(height: height(context) * 0.02),
                              Container(
                                decoration: BoxDecoration(
                                    border: cubit.selectedUsers.isEmpty
                                        ? Border.all(
                                            color: Colors.white,
                                            width: 0.125,
                                          )
                                        : Border.all(
                                            color: Colors.grey.shade200,
                                            width: 1,
                                          ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(height(context) * 0.05),
                                    )),
                                child: cubit.selectedUsers.isNotEmpty
                                    ? MultiSelectChipDisplay(
                                        alignment: Alignment.topLeft,
                                        icon: Icon(Icons.cancel),
                                        items: cubit.selectedUsers.map((user) => MultiSelectItem<Users>(user, user.name)).toList(),
                                        onTap: (value) {
                                          if (cubit.selectAll == false) {
                                            cubit.removeSelected(value);
                                          } else {
                                           setState(() {
                                             cubit.selectAll = false;
                                             cubit.removeSelected(value);
                                           });
                                          }
                                        },
                                      )
                                    : const SizedBox(),
                              ),

                             /// ************************** Group Description **********************************************/
                              CustomText(text: "${LocaleKeys.GroupDetails.tr()}:"),
                              SizedBox(height: height(context) * 0.02),
                              CustomTextFormField(
                                ctrl: cubit.groupDiscriptioCtrl,
                                type: TextInputType.text,
                                maxLines: 5,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: width(context) * 0.040,
                                  vertical: width(context) * 0.040,
                                ),
                              ),
                              SizedBox(height: height(context) * 0.05),
                              //************************** Create Group Button **********************************************/
                              state is CreateGroupLoadingState
                                  ? CustomLoading(load: false)
                                  : CustomButton(
                                      colored: true,
                                      text: LocaleKeys.CreateNewGroup.tr(),
                                      onPressed: () {
                                        if (cubit.formKey.currentState!.validate()) {
                                          cubit.createGroup(context);
                                        }
                                        focusScopeNode.unfocus();
                                      }),
                              SizedBox(height: height(context) * 0.02),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
