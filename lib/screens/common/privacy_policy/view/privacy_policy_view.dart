import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:private_courses/components/custom_loading.dart';

import '../../../../components/custom_appBar.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../generated/locale_keys.g.dart';
import '../controller/privacy_policy_cubit.dart';
import '../controller/privacy_policy_states.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
        create: (context)=>PrivacyPolicyCubit()..fetchPrivacy(context: context),
        child: BlocBuilder<PrivacyPolicyCubit, PrivacyPolicyStates>(
        builder: (context, state) {
         final cubit = PrivacyPolicyCubit.get(context);
         return SafeArea(
          child: Scaffold(
              body: Padding(padding: EdgeInsets.symmetric(horizontal: width(context) * 0.04),
               child:

               Column(
                 children: [
                   CustomAppBar(isNotify: false, textAppBar: LocaleKeys.PrivacyPolicy.tr(), isDrawer: false),
                   state is LoadingState?
                   const CustomLoading(load: true):Expanded(
                     child: SingleChildScrollView(
                       physics: const BouncingScrollPhysics(),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: [
                           SizedBox(height: height(context) * 0.08),
                           Image.asset(AppImages.privacyImg,scale: 4.4,),
                           SizedBox(height: height(context) * 0.04),
                           Padding(
                             padding: EdgeInsetsDirectional.only(start: width(context)*0.03,
                             end: width(context)*0.03, top:width(context)*0.02 ),
                             child: HtmlWidget(cubit.privacyPolicyModel!.data!.privacyPolicy!,textStyle: TextStyle(color: AppColors.greyBoldColor,
                                 fontSize: AppFonts.t7),),
                           ),
                         ]),
                     ),
                   ),
                 ],
               ))));}));
  }
}
