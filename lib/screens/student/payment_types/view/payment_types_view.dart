import 'package:easy_localization/easy_localization.dart' as localize;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_button.dart';
import 'package:private_courses/components/custom_text.dart';
import 'package:private_courses/components/custom_toast.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/components/style/images.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/screens/common/drawer/components/custom_zoom_drawer.dart';
import 'package:private_courses/screens/student/form_checkout/view/form_checkout_view.dart';
import 'package:private_courses/screens/student/payment_cart/view/payment_cart_view.dart';
import 'package:private_courses/screens/student/payment_types/componants/payItem.dart';
import 'package:private_courses/screens/student/payment_types/controller/payment_cubit.dart';
import 'package:private_courses/screens/student/payment_types/controller/payment_states.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import 'package:tabby_flutter_inapp_sdk/tabby_flutter_inapp_sdk.dart';
import '../../../../components/custom_appBar.dart';
import '../../../../components/style/size.dart';
import '../../../../generated/locale_keys.g.dart';


class PaymentTypesScreen extends StatelessWidget {
  final int amount;
  final String paymentKey;
  final bool isInstallment;
  final bool isBankPayment;
  const PaymentTypesScreen({ required this.amount,required this.paymentKey,required this.isInstallment,required this.isBankPayment});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PayCartTypesCubit(),
      child: BlocBuilder<PayCartTypesCubit,PayCartTypesStates>(
        builder: (context, state) {
          final cubit = PayCartTypesCubit.get(context);
          return SafeArea(
              child: Scaffold(
                  body: Padding(padding: EdgeInsets.symmetric(horizontal: width(context) * 0.04),
                      child: Column(
                          children: [
                            CustomAppBar(
                                isNotify: false,
                                textAppBar: LocaleKeys.PaymentTypes.tr(),
                                isDrawer: true),
                            Expanded(
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                        text: LocaleKeys.PaymentSub.tr(),
                                        fontSize: AppFonts.t6,
                                        fontWeight: FontWeight.bold
                                    ),
                                    SizedBox(height: width(context)*0.05,),
                                    PaymentItem(
                                        onChanged: (ind){
                                          navigateTo(context, CustomZoomDrawer(mainScreen: PaymentCartScreen(
                                              paymentKey: paymentKey,
                                              cartPrice:amount ),
                                              isTeacher: CacheHelper.getData(key: AppCached.role)));
                                          cubit.changeRadio(0);
                                        },
                                        img: AppImages.visa,
                                        title: LocaleKeys.Visaa.tr(),
                                        val: 0,
                                        value: cubit.value),
                                    PaymentItem(
                                        onChanged: (ind){
                                          cubit.changeRadio(1);
                                          showSnackBar(context: context, text: LocaleKeys.NotActive.tr(), success: false);
                                        },
                                        img: AppImages.applePay,
                                        title: "Apple pay",
                                        val: 1,
                                        value: cubit.value),
                                    PaymentItem(
                                        onChanged: (ind){
                                          navigateTo(context, CustomZoomDrawer(mainScreen: PaymentCartScreen(
                                              paymentKey: paymentKey,
                                              cartPrice:amount ),
                                              isTeacher: CacheHelper.getData(key: AppCached.role)));
                                          cubit.changeRadio(2);
                                        },
                                        img: AppImages.mada,
                                        title: LocaleKeys.Mada.tr(),
                                        val: 2,
                                        value: cubit.value),
                                    PaymentItem(
                                        onChanged: (ind){
                                          navigateTo(context, CustomZoomDrawer(mainScreen: PaymentCartScreen(
                                              paymentKey: paymentKey,
                                              cartPrice:amount ),
                                              isTeacher: CacheHelper.getData(key: AppCached.role)));
                                          cubit.changeRadio(3);
                                        },
                                        img: AppImages.masterCard,
                                        title: LocaleKeys.MasterCard.tr(),
                                        val: 3,
                                        value: cubit.value),
                                    PaymentItem(
                                        onChanged: (ind){
                                          navigateTo(context, CustomZoomDrawer(mainScreen: PaymentCartScreen(
                                              paymentKey: paymentKey,
                                              cartPrice:amount ),
                                              isTeacher: CacheHelper.getData(key: AppCached.role)));
                                          cubit.changeRadio(4);
                                        },
                                        img: AppImages.stcPay,
                                        title: "STC pay",
                                        val: 4,
                                        value: cubit.value),
                                    isInstallment==true?
                                    PaymentItem(
                                        onChanged: (ind) {
                                          cubit.createSession(context);
                                          cubit.changeRadio(5);
                                        },
                                        img: AppImages.tabby,
                                        title: LocaleKeys.Tabby.tr(),
                                        val: 5,
                                        value: cubit.value):SizedBox.shrink(),
                                    SizedBox(height: width(context)*0.05,),
                                    if (cubit.session != null&&cubit.value==5) ...[
                                      Center(
                                        child: SizedBox(
                                          width: width(context)*0.5,
                                          height: height(context)*0.07,
                                          child: CustomButton(
                                            colored: true,
                                            onPressed: cubit.openInAppBrowser,
                                            text: LocaleKeys.ContinuePay.tr(),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: TabbyPresentationSnippet(
                                          price: cubit.mockPayload.amount,
                                          currency: cubit.mockPayload.currency,
                                          lang: CacheHelper.getData(key: AppCached.appLanguage)== 'ar' ? Lang.ar : Lang.en,
                                        ),
                                      ),
                                    ],
                                    isBankPayment==true?SizedBox(height: width(context)*0.05):SizedBox(height: width(context)*0.02),
                                    isBankPayment==true?
                                    CustomButton(
                                      colored: false,
                                      onPressed: (){
                                        navigateTo(context, FormCheckoutScreen(isCart: true));
                                      },
                                      text: LocaleKeys.AnotherPay.tr(),
                                    ):SizedBox.shrink(),
                                    isBankPayment==true?SizedBox(height: width(context)*0.02):SizedBox.shrink()
                                  ],
                                ),
                              ),
                            ),
                          ]))));
        },
      ),
    );
  }
}
