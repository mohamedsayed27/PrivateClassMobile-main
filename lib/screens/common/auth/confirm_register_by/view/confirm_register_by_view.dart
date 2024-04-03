import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../components/auth_body.dart';
import '../../../../../components/custom_text.dart';
import '../../../../../components/style/colors.dart';
import '../../../../../components/style/images.dart';
import '../../../../../components/style/size.dart';
import '../../../../../core/local/app_cached.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../../shared/local/cache_helper.dart';
import '../components/confirm_register_container.dart';
import '../controller/confirm_register_by_cubit.dart';
import '../controller/confirm_register_by_states.dart';

class ConfirmRegisterByScreen extends StatelessWidget {
  const ConfirmRegisterByScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConfirmRegisterByCubit(),
      child: BlocBuilder<ConfirmRegisterByCubit, ConfirmRegisterByStates>(
          builder: (context, state) {
            final cubit = ConfirmRegisterByCubit.get(context);
            return SafeArea(
              child: Scaffold(
                body: AuthBody(
                  withBackArrow: true,
                  img: AppImages.authBackground,
                  heigh: height(context) * 0.085,
                  margin: EdgeInsetsDirectional.only(top: height(context)*0.05),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width(context) * 0.052),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: height(context) * 0.03),
                        CustomText(
                            text: LocaleKeys.ChooseOne.tr(),
                            color: AppColors.mainColor,
                            textAlign: TextAlign.center,
                            fontSize: AppFonts.t5,
                            fontWeight: FontWeight.w500),
                        SizedBox(height: height(context) * 0.04),
                        ConfirmRegisterContainer(
                          subTitle: LocaleKeys.EnterPhone.tr(),
                          title: LocaleKeys.ByPhone.tr(),
                          img: AppImages.confirmPhone,
                          onTap: () {
                            CacheHelper.saveData(AppCached.codeType, "phone");
                            cubit.sendCode(context: context, type: CacheHelper.getData(key: AppCached.codeType));
                            debugPrint(CacheHelper.getData(key: AppCached.codeType)+"<<<<<<<<<>>>>>>phoneeeee");
                          },
                        ),
                        SizedBox(height: height(context) * 0.02),
                        ConfirmRegisterContainer(
                          subTitle: LocaleKeys.EnterEmail.tr(),
                          title: LocaleKeys.ByEmail.tr(),
                          img: AppImages.confirmEmail,
                          onTap: () {
                            CacheHelper.saveData(AppCached.codeType, "email");
                            cubit.sendCode(context: context, type: CacheHelper.getData(key: AppCached.codeType));
                            debugPrint(CacheHelper.getData(key: AppCached.codeType)+"<<<<<<<<<>>>>>>emailllllllll");
                          },
                        ),
                        SizedBox(height: height(context) * 0.015)
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
