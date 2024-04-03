import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_loading.dart';
import 'package:private_courses/components/style/colors.dart';
import '../../../../../components/auth_body.dart';
import '../../../../../components/custom_button.dart';
import '../../../../../components/custom_textfield.dart';
import '../../../../../components/style/images.dart';
import '../../../../../components/style/size.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../controller/forget_pass_cubit.dart';
import '../controller/forget_pass_states.dart';

class ForgetPassScreen extends StatelessWidget {
  ForgetPassScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    return GestureDetector(
      onTap: (){
        currentFocus.unfocus();
      },
      child: BlocProvider(
          create: (context) => ForgetPasswordCubit(),
          child: BlocBuilder<ForgetPasswordCubit, ForgetPasswordStates>(
              builder: (context, state) {
            final cubit = ForgetPasswordCubit.get(context);
            return SafeArea(
              child: Scaffold(
                body: AuthBody(
                    title: LocaleKeys.ForgetPassword.tr(),
                    subTitle: LocaleKeys.PleaseEnterEmail.tr(),
                    margin: EdgeInsetsDirectional.only(top: height(context)*0.135),
                    widgetSizedBox: SizedBox(height: height(context)*0.015),
                    withBackArrow: true,
                    img: AppImages.authBackground,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width(context) * 0.055),
                      child: Form(
                        key: cubit.formKey,
                        child: Column(
                          children: [
                            SizedBox(height: height(context) * 0.04),
                            CustomTextFormField(
                                hint: LocaleKeys.Email.tr(),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width(context) * 0.03),
                                  child: Image.asset(
                                    AppImages.email,
                                    width: width(context) * 0.02,
                                  ),
                                ),
                                type: TextInputType.emailAddress,
                                ctrl: cubit.emailController),
                            SizedBox(height: height(context) * 0.07),
                            state is ForgetPasswordLoadingState
                                ? const CustomLoading(load: false)
                                : CustomButton(
                                    onPressed: () async {
                                      await cubit.forgetPass(context: context);
                                    },
                                    text: LocaleKeys.Send.tr(),
                                    colored: true,
                                    fontWeight: FontWeight.bold),
                            SizedBox(height: height(context) * 0.01)
                          ],
                        ),
                      ),
                    )),
              ),
            );
          })),
    );
  }
}
