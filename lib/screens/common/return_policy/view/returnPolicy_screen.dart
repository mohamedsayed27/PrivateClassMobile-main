
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:private_courses/components/custom_appBar.dart';
import 'package:private_courses/components/custom_loading.dart';
import 'package:private_courses/components/style/colors.dart';
import 'package:private_courses/components/style/images.dart';
import 'package:private_courses/components/style/size.dart';
import 'package:private_courses/generated/locale_keys.g.dart';
import 'package:private_courses/screens/common/privacy_policy/controller/privacy_policy_cubit.dart';
import 'package:private_courses/screens/common/return_policy/controller/return_policy_cubit.dart';
import 'package:private_courses/screens/common/return_policy/controller/return_policy_states.dart';

class ReturnPolicyScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
        create: (context)=>ReturnPolicyCubit()..fetchReturnPolicy(context: context),
        child: BlocBuilder<ReturnPolicyCubit, ReturnPolicyStates>(
        builder: (context, state) {
         final cubit = ReturnPolicyCubit.get(context);
         return SafeArea(
          child: Scaffold(
              body: Padding(padding: EdgeInsets.symmetric(horizontal: width(context) * 0.04),
               child: Column(
                 children: [
                   CustomAppBar(isNotify: false, textAppBar: LocaleKeys.ResturnPolicy.tr(), isDrawer: false),
                   state is LoadingState?
                   const CustomLoading(load: true):Expanded(
                     child: SingleChildScrollView(
                       physics: const BouncingScrollPhysics(),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: [
                           SizedBox(height: height(context) * 0.08),
                           Image.asset(AppImages.returnPolicySC,scale: 4.4,),
                           SizedBox(height: height(context) * 0.04),
                           Padding(
                             padding: EdgeInsetsDirectional.only(start: width(context)*0.03,
                             end: width(context)*0.03, top:width(context)*0.02 ),
                             child: HtmlWidget(cubit.returnPolicyModel!.data!.returnPolicy!,textStyle: TextStyle(color: AppColors.greyBoldColor,
                                 fontSize: AppFonts.t7),),
                           ),
                         ]),
                     ),
                   ),
                 ],
               ))));}));
  }
}
