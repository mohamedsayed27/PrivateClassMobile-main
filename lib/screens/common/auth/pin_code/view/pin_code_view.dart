import 'package:easy_localization/easy_localization.dart' as localization;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:private_courses/components/custom_loading.dart';
import 'package:private_courses/screens/common/auth/pin_code/controller/pin_code_cubit.dart';
import 'package:private_courses/screens/common/auth/pin_code/controller/pin_code_states.dart';
import '../../../../../components/auth_body.dart';
import '../../../../../components/custom_button.dart';
import '../../../../../components/custom_text.dart';
import '../../../../../components/style/colors.dart';
import '../../../../../components/style/images.dart';
import '../../../../../components/style/size.dart';
import '../../../../../generated/locale_keys.g.dart';

class PinCodeScreen extends StatelessWidget {
  final bool isPass;

  const PinCodeScreen({Key? key, required this.isPass}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    return GestureDetector(
      onTap: (){
        currentFocus.unfocus();
      },
      child: BlocProvider(
        create: (context) => PinCodeCubit(),
        child: BlocBuilder<PinCodeCubit, PinCodeStates>(builder: (context, state) {
          final cubit = PinCodeCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: AuthBody(
                  title: LocaleKeys.VerificationCode.tr(),
                  subTitle: LocaleKeys.PleaseEnterCode.tr(),
                  margin: EdgeInsetsDirectional.only(top: height(context)*0.05),
                  widgetSizedBox: SizedBox(
                      height: height(context) * 0.015),
                  withBackArrow: true,
                  img: AppImages.authBackground,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width(context) * 0.05),
                    child: Column(
                      children: [
                        SizedBox(
                          height: height(context) * 0.08),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: width(context) * 0.045),
                            child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: PinCodeTextField(
                                    appContext: context,
                                    controller: cubit.pinCtrl,
                                    pastedTextStyle: const TextStyle(
                                      color: AppColors.mainColor,
                                    ),
                                    textStyle: const TextStyle(color: AppColors.mainColor),
                                    length: 4,
                                    obscureText: false,
                                    obscuringCharacter: '*',
                                    animationType: AnimationType.fade,
                                    pinTheme: PinTheme(
                                        shape: PinCodeFieldShape.circle,
                                        fieldHeight: height(context) * 0.08,
                                        fieldWidth: width(context) * 0.16,
                                        inactiveColor:
                                            AppColors.navyBlue.withOpacity(.03),
                                        selectedFillColor:
                                            AppColors.navyBlue.withOpacity(.03),
                                        activeColor: AppColors.mainColor,
                                        activeFillColor:
                                            AppColors.navyBlue.withOpacity(.03),
                                        inactiveFillColor:
                                            AppColors.navyBlue.withOpacity(.03),
                                        selectedColor:
                                            AppColors.navyBlue.withOpacity(.03)),
                                    cursorColor: AppColors.mainColor,
                                    animationDuration:
                                        const Duration(milliseconds: 300),
                                    enableActiveFill: true,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      debugPrint(value);
                                    }))),
                        SizedBox(height: height(context) * 0.04),
                        GestureDetector(
                            onTap: () async {
                              await cubit.resendCode(context: context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                    text: '${LocaleKeys.SendAgain.tr()} ',
                                    color: AppColors.goldColor,
                                    fontSize: AppFonts.t7),
                                Image.asset(AppImages.refresh,
                                    width: width(context) * 0.06)
                              ],
                            )),
                        SizedBox(height: height(context) * 0.05),
                        state is ActiveAccLoadingState
                            ? const CustomLoading(load: false)
                            : CustomButton(
                                onPressed: () async {
                                  isPass == true
                                      ? await cubit.activeCode(context: context)
                                      : await cubit.activeAccount(context: context);
                                },
                                text: LocaleKeys.Send.tr(),
                                colored: true,
                                fontWeight: FontWeight.bold),
                        SizedBox(height: height(context) * 0.01),
                      ],
                    ),
                  )),
            ),
          );
        }),
      ),
    );
  }
}
