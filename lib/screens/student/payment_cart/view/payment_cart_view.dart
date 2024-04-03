import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moyasar/moyasar.dart';
import 'package:private_courses/components/custom_appBar.dart';
import 'package:private_courses/components/custom_toast.dart';
import 'package:private_courses/components/style/size.dart';
import 'package:private_courses/generated/locale_keys.g.dart';
import 'package:private_courses/screens/student/subscribe_course/controller/subscribe_course_cubit.dart';
import 'package:private_courses/screens/student/subscribe_course/controller/subscribe_course_states.dart';

class PaymentCartScreen extends StatelessWidget {
  final int cartPrice;
  final String paymentKey;
  PaymentCartScreen({required this.cartPrice, required this.paymentKey});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:(context) => SubscribeCourseCubit(),
      child: BlocBuilder<SubscribeCourseCubit,SubscribeCourseStates>(
        builder: (context, state) {
          final cubit = SubscribeCourseCubit.get(context);
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width(context) * 0.04),
                child: Column(
                  children: [
                    CustomAppBar(
                        isNotify: false,
                        textAppBar: LocaleKeys.Pay.tr()
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: CreditCard(
                          locale: context.locale.languageCode == "ar" ? Localization.ar():Localization.en(),
                          config: PaymentConfig(
                            publishableApiKey: paymentKey,
                            amount: cartPrice*100,
                            description: context.locale.languageCode == "ar" ?  'أكاديمية دروس خصوصية':'Private Classes',
                            metadata: {'size': '250g'},
                            currency: 'SAR',
                          ),
                          onPaymentResult: (result) {
                            if (result is PaymentResponse) {
                              switch (result.status) {
                                case PaymentStatus.paid:
                                  cubit.paymentCart(context: context);
                                  break;
                                case PaymentStatus.failed:
                                  showSnackBar(context: context, text: LocaleKeys.OperationField.tr(), success: false);
                                  break;
                                case PaymentStatus.initiated:
                                  break;
                              }
                            }

                          },
                        ),
                      ),
                    )
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
