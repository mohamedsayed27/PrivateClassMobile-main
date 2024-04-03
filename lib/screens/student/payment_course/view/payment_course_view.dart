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

class PaymentCourseScreen extends StatelessWidget {
  final int id;
  final int coursePrice;
  final String courseName ;
  final String paymentKey ;
  PaymentCourseScreen({required this.id , required this.coursePrice, required this.courseName, required this.paymentKey});

  // );

  // final paymentConfig = PaymentConfig(
  //   publishableApiKey: 'pk_test_RV3Q4ZKLdA22ZNVkCR72WBDxb3oYnj9D14h6czGA',
  //   amount: 25758, // SAR 257.58
  //   description: 'Blue Coffee Beans',
  //   metadata: {'size': '250g'},
  //   currency: 'SAR',

  // void onPaymentResult(result) {
  //   print("-------------------------------------------------------00");
  //   if (result is PaymentResponse) {
  //     switch (result.status) {
  //       case PaymentStatus.paid:
  //         print("Successsssssssssssssss");
  //         // handle success.
  //         break;
  //       case PaymentStatus.failed:
  //         print("fieeeeeeeeeeeeeeeeeeeeeld");
  //
  //         // handle failure.
  //         break;
  //       case PaymentStatus.initiated:
  //         print("INIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIT");
  //         // TODO: Handle this case.
  //         break;
  //     }
  //   }
  //   print("-------------------------------------------------------01 " + result.toString());
  //
  // }

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
                        textAppBar: LocaleKeys.SubscribeCourse.tr()
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: CreditCard(
                          locale: context.locale.languageCode =="ar"?Localization.ar():Localization.en(),
                          config: PaymentConfig(
                            publishableApiKey: paymentKey,
                            amount: coursePrice*100, // SAR 257.58
                            description: context.locale.languageCode =="ar"? 'أكاديمية دروس خصوصية':'Private Classes',
                            metadata: {'size': '250g'},
                            currency: 'SAR',
                          ),
                          onPaymentResult: (result) {
                            if (result is PaymentResponse) {
                              switch (result.status) {
                                case PaymentStatus.paid:
                                  cubit.subscribeCourse(context: context, id: id,courseName: courseName);
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
