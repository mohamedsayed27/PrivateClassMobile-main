import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tawk/flutter_tawk.dart';
// import 'package:flutter_tawk/flutter_tawk.dart';
import 'package:private_courses/components/custom_appBar.dart';
import 'package:private_courses/components/custom_button.dart';
import 'package:private_courses/components/custom_loading.dart';
import 'package:private_courses/components/custom_textfield.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/components/style/colors.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/generated/locale_keys.g.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import '../controller/report_cubit.dart';
import '../controller/report_state.dart';

import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';

class ReportView extends StatelessWidget {
  final String twak ;

  const ReportView({super.key, required this.twak});
  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              color: AppColors.navyBlue,
              padding: EdgeInsetsDirectional.only(
                  bottom: height(context) * 0.03, top: height(context) * 0.02,start: width(context)*0.03),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                            navigatorPop(context);
                          },
                      child: Image.asset(
                          context.locale.languageCode == "ar"
                              ? AppImages.arrowAr
                              : AppImages.arrowEn,
                          scale: 2.9))
                ],
              ),
            ),
            Expanded(
              child: Tawk(
                directChatLink: twak,
                visitor: CacheHelper.getData(key: AppCached.name) != null || CacheHelper.getData(key: AppCached.email) != null ?TawkVisitor(
                  name: CacheHelper.getData(key: AppCached.name),
                  email: CacheHelper.getData(key: AppCached.email),
                ):TawkVisitor(),
                onLoad: () {
                  print('Hello ${CacheHelper.getData(key: AppCached.name)}!');
                },
                onLinkTap: (String url) {
                  print(url);
                },
                placeholder:  Center(
                  child: CustomLoading(load: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    //   GestureDetector(
    //   onTap: () {
    //     currentFocus.unfocus();
    //   },
    //   child: BlocProvider<ReportCubit>(
    //     create: (context) => ReportCubit(),
    //     child: BlocBuilder<ReportCubit, ReportState>(
    //       builder: (context, state) {
    //         var cubit = ReportCubit.get(context);
    //         return Scaffold(
    //           body: SafeArea(
    //             child: Padding(
    //               padding:
    //                   EdgeInsets.symmetric(horizontal: width(context) * 0.04),
    //               child: Column(
    //                 children: [
    //                   CustomAppBar(
    //                       isDrawer: false,
    //                       isNotify: false,
    //                       textAppBar: LocaleKeys.ReportAProblem.tr()),
    //                   Expanded(
    //                       child: SingleChildScrollView(
    //                           physics: const BouncingScrollPhysics(),
    //                           child: Column(children: [
    //                             Image.asset(
    //                               AppImages.supportImg,
    //                               scale: 4.4
    //                             ),
    //                             SizedBox(height: height(context) * 0.04),
    //                             CustomTextFormField(
    //                               ctrl: cubit.fullName, hintStyle: TextStyle(color: AppColors.grayColor),
    //                               prefixIcon: Padding(
    //                                 padding: EdgeInsets.symmetric(
    //                                     horizontal: width(context) * 0.034),
    //                                 child: Image.asset(
    //                                   AppImages.fullName,
    //                                   scale: 3.2
    //                                 )
    //                               ),
    //                               hint: LocaleKeys.FullName.tr(),
    //                               type: TextInputType.name
    //                             ),
    //                             SizedBox(height: height(context) * 0.02),
    //                             CustomTextFormField(
    //                               ctrl: cubit.email,
    //                                 hintStyle: TextStyle(color: AppColors.grayColor),
    //                               prefixIcon: Padding(
    //                                 padding: EdgeInsets.symmetric(
    //                                     horizontal: width(context) * 0.034),
    //                                 child: Image.asset(
    //                                   AppImages.email,
    //                                   scale: 3.2
    //                                 )
    //                               ),
    //                               hint: LocaleKeys.Email.tr(),
    //                               type: TextInputType.emailAddress
    //                             ),
    //                             SizedBox(height: height(context) * 0.02),
    //                             CustomTextFormField(
    //                                 hintStyle: TextStyle(color: AppColors.grayColor),
    //                                 contentPadding: EdgeInsets.symmetric(
    //                                   horizontal: width(context) * 0.040,
    //                                   vertical: width(context) * 0.040
    //                                 ),
    //                                 ctrl: cubit.problemDetails,
    //                                 hint: LocaleKeys.ProblemDetails.tr(),
    //                                 type: TextInputType.text,
    //                                 maxLines: 5),
    //                             SizedBox(height: height(context) * 0.05),
    //                             state is LoadingState
    //                                 ? const CustomLoading(load: false)
    //                                 : CustomButton(
    //                                     colored: true,
    //                                     onPressed: () {
    //                                       cubit.sendReport(context: context);
    //                                     },
    //                                     text: LocaleKeys.Send.tr(),
    //                                   ),
    //                             SizedBox(height: height(context)*0.02)
    //                           ]))),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         );
    //       },
    //     ),
    //   ),
    // );
  }
}
