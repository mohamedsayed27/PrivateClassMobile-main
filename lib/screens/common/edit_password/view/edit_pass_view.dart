import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_loading.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import '../../../../components/custom_appBar.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/custom_textfield.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../generated/locale_keys.g.dart';
import '../controller/edit_pass_cubit.dart';
import '../controller/edit_pass_state.dart';

class EditPasswordScreen extends StatelessWidget {
  const EditPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    return GestureDetector(
      onTap: () {
        currentFocus.unfocus();
      },
      child: BlocProvider(
        create: (context) => EditPassCubit(),
        child: BlocBuilder<EditPassCubit, EditPassStates>(
          builder: (context, state) {
            final cubit = EditPassCubit.get(context);
            return SafeArea(
              child: Scaffold(
                body: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width(context) * 0.04),
                  child: Column(
                    children: [
                      CustomAppBar(
                          isNotify: false,
                          textAppBar: LocaleKeys.EditPass.tr()),
                      Expanded(
                        child: Form(
                          key: cubit.formKey,
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                SizedBox(height: height(context) * 0.024),
                                CircleAvatar(
                                    radius: 50,
                                    backgroundColor: AppColors.whiteColor,
                                    backgroundImage: NetworkImage(
                                        CacheHelper.getData(
                                            key: AppCached.image))),
                                SizedBox(height: height(context) * 0.1),
                                CustomTextFormField(
                                    hint: LocaleKeys.OldPassword.tr(),
                                    prefixIcon: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width(context) * 0.034),
                                        child: Image.asset(
                                            context.locale.languageCode == "ar"
                                                ? AppImages.password
                                                : AppImages.leftKey,
                                            width: width(context) * 0.02)),
                                    type: TextInputType.visiblePassword,
                                    ctrl: cubit.oldPassController,
                                    isSecure: cubit.isSecure,
                                    hintStyle: TextStyle(color: AppColors.grayColor),
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
                                                width: width(context) * 0.05))),
                                    maxLines: 1),
                                SizedBox(height: height(context) * 0.02),
                                CustomTextFormField(
                                    hint: LocaleKeys.NewPassword.tr(),
                                    prefixIcon: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width(context) * 0.034),
                                        child: Image.asset(
                                            context.locale.languageCode == "ar"
                                                ? AppImages.password
                                                : AppImages.leftKey,
                                            width: width(context) * 0.02)),
                                    type: TextInputType.visiblePassword,
                                    ctrl: cubit.newPassController,
                                    isSecure: cubit.isSecure2,
                                    hintStyle: TextStyle(color: AppColors.grayColor),
                                    suffixIcon: GestureDetector(
                                        onTap: () {
                                          cubit.changeSecurePass2();
                                        },
                                        child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    width(context) * 0.03),
                                            child: Image.asset(
                                                cubit.isSecure2
                                                    ? AppImages.hiddenEye
                                                    : AppImages.eye,
                                                width: width(context) * 0.05))),
                                    maxLines: 1),
                                SizedBox(height: height(context) * 0.02),
                                CustomTextFormField(
                                    hint: LocaleKeys.ConfirmNewPass.tr(),
                                    prefixIcon: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width(context) * 0.034),
                                        child: Image.asset(
                                            context.locale.languageCode == "ar"
                                                ? AppImages.password
                                                : AppImages.leftKey,
                                            width: width(context) * 0.02)),
                                    type: TextInputType.visiblePassword,
                                    ctrl: cubit.confirmNewPassController,
                                    hintStyle: TextStyle(color: AppColors.grayColor),
                                    isSecure: cubit.isSecure3,
                                    suffixIcon: GestureDetector(
                                        onTap: () {
                                          cubit.changeSecurePass3();
                                        },
                                        child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    width(context) * 0.03),
                                            child: Image.asset(
                                                cubit.isSecure3
                                                    ? AppImages.hiddenEye
                                                    : AppImages.eye,
                                                width: width(context) * 0.05))),
                                    maxLines: 1),
                                SizedBox(height: height(context) * 0.17),
                                state is UpdatePassLoadingState
                                    ? const CustomLoading(load: false)
                                    : CustomButton(
                                        colored: true,
                                        onPressed: () async {
                                          await cubit.updatePass(context: context);
                                        },
                                        text: LocaleKeys.SaveEdit.tr()),
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
      ),
    );
  }
}
