import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_loading.dart';
import 'package:private_courses/components/custom_text.dart';
import 'package:private_courses/components/style/colors.dart';
import '../../../../../components/auth_body.dart';
import '../../../../../components/custom_button.dart';
import '../../../../../components/custom_textfield.dart';
import '../../../../../components/style/images.dart';
import '../../../../../components/style/size.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../controller/change_pass_cubit.dart';
import '../controller/change_pass_states.dart';

class ChangePassScreen extends StatelessWidget {
  final String token ;
  const ChangePassScreen({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    return GestureDetector(
      onTap: (){
        currentFocus.unfocus();
      },
      child: BlocProvider(
        create: (context) => ChangePassCubit(),
        child: BlocBuilder<ChangePassCubit, ChangePassword>(
          builder: (context, state) {
            final cubit = ChangePassCubit.get(context);
            return SafeArea(
              child: Scaffold(
                body: AuthBody(
                    withBackArrow: true,
                    img: AppImages.authBackground,
                    margin: EdgeInsetsDirectional.only(top: height(context)*0.14),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width(context) * 0.055,vertical: height(context)*0.03),
                      child: Form(
                        key: cubit.formKey,
                        child: Column(
                          children: [
                            CustomText(
                                text: LocaleKeys.MakeNewPass.tr(),
                                color: AppColors.navyBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: AppFonts.t5),
                            SizedBox(height: height(context) * 0.04),
                            CustomTextFormField(
                                hint: LocaleKeys.MakeNewPass.tr(),
                                hintStyle: TextStyle(color: AppColors.grayColor),
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
                                isSecure: cubit.isSecure1,
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    cubit.changeSecurePass1();
                                  },
                                  child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width(context) * 0.03),
                                      child: Image.asset(
                                          cubit.isSecure1
                                              ? AppImages.hiddenEye
                                              : AppImages.eye,
                                          width: width(context) * 0.05)),
                                ),
                                maxLines: 1),
                            SizedBox(height: height(context) * 0.02),
                            CustomTextFormField(
                                hint: LocaleKeys.ReWritePass.tr(),
                                hintStyle: TextStyle(color: AppColors.grayColor),
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
                                ctrl: cubit.confirmNewPassController,
                                isSecure: cubit.isSecure2,
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    cubit.changeSecurePass2();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width(context) * 0.03),
                                    child: Image.asset(
                                        cubit.isSecure2
                                            ? AppImages.hiddenEye
                                            : AppImages.eye,
                                        width: width(context) * 0.05),
                                  ),
                                ),
                                maxLines: 1),
                            SizedBox(height: height(context) * 0.06),
                            state is ChangePassLoadingState
                                ? const CustomLoading(load: false)
                                : CustomButton(
                                    onPressed: () async {
                                      await cubit.changePass(context: context,token: token);
                                    },
                                    text: LocaleKeys.Save.tr(),
                                    colored: true,
                                    fontWeight: FontWeight.bold),
                            SizedBox(height: height(context) * 0.01)
                          ],
                        ),
                      ),
                    )),
              ),
            );
          },
        ),
      ),
    );
  }
}
