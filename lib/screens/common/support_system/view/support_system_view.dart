import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:private_courses/components/custom_loading.dart';
import 'package:private_courses/components/custom_text.dart';
import 'package:private_courses/components/my_navigate.dart';
import '../../../../components/custom_appBar.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../report_problem/view/report_view.dart';
import '../controller/support_sys_cubit.dart';
import '../controller/support_sys_states.dart';

class SupportSystemScreen extends StatelessWidget {
  const SupportSystemScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SupportSystemCubit()..fetchSupportSystem(context: context),
        child: BlocBuilder<SupportSystemCubit, SupportSystemStates>(
            builder: (context, state) {
          final cubit = SupportSystemCubit.get(context);
          return SafeArea(
              child: Scaffold(
                  body: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: width(context) * 0.04),
                      child:
                      Column(
                        children: [
                          CustomAppBar(
                              isNotify: false,
                              textAppBar: LocaleKeys.TechnicalSupport.tr(),
                              // onTapBack: (){
                              //   navigateAndFinish(
                              //       context: context,
                              //       widget: CustomZoomDrawer(
                              //           mainScreen: CustomBtnNavBarScreen(
                              //               page: 0,
                              //               isTeacher: CacheHelper.getData(
                              //                   key: AppCached.role)),
                              //           isTeacher: CacheHelper.getData(
                              //               key: AppCached.role)));
                              // },
                              isDrawer: false),
                          state is LoadingState ?
                          const CustomLoading(load: true):Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: height(context) * 0.06),
                                    Image.asset(
                                      AppImages.supportImg,
                                      scale: 4.4
                                    ),
                                    SizedBox(height: height(context) * 0.04),
                                    CustomText(
                                        text: LocaleKeys.HowHelp.tr(),
                                        fontSize: AppFonts.t5,
                                        color: AppColors.blackColor,
                                        fontWeight: FontWeight.bold),
                                    Padding(
                                      padding: EdgeInsetsDirectional.only(
                                          start: width(context) * 0.02,
                                          end: width(context) * 0.02,
                                          top: width(context) * 0.02),
                                      child:
                                      HtmlWidget(cubit.supportSystemModel!.data!.customerService!,
                                        textStyle: TextStyle(
                                            color: AppColors.greyBoldColor,
                                            fontSize: AppFonts.t7
                                            ))
                                    ),
                                    SizedBox(height: height(context) * 0.03),
                                    CustomButton(
                                      text: LocaleKeys.ReportAProblem.tr(),
                                      colored: true,
                                      onPressed: () {
                                        navigateTo(context,ReportView(twak: cubit.supportSystemModel!.data!.tawk!));
                                      }
                                    ),
                                    SizedBox(height: height(context) * 0.04),
                                  ]),
                            ),
                          ),
                        ],
                      ))));
        }));
  }
}
