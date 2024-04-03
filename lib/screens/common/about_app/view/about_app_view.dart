import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_loading.dart';
import 'package:private_courses/screens/common/about_app/controller/about_app_states.dart';
import '../../../../components/custom_appBar.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../generated/locale_keys.g.dart';
import '../components/about_appItem.dart';
import '../controller/about_app_cubit.dart';


class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
         create: (context)=>AboutAppCubit()..fetchAboutApp(context: context),
        child: BlocBuilder<AboutAppCubit, AboutAppStates>(
        builder: (context, state) {
         final cubit = AboutAppCubit.get(context);
         return SafeArea(
           child: Scaffold(
              body: Padding(padding: EdgeInsets.symmetric(horizontal: width(context) * 0.04),
                  child:

                  Column(
                      children: [
                        CustomAppBar(isNotify: false, textAppBar: LocaleKeys.AboutTheApp.tr(), isDrawer: false),
                        state is LoadingState?
                        const CustomLoading(load: true):Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                SizedBox(height: height(context) * 0.02),
                                Image.asset(AppImages.backSplash, scale: 4.6),
                                SizedBox(height: height(context) * 0.03),
                                AboutAppItem(title:LocaleKeys.OurVision.tr() ,desc: cubit.aboutAppModel!.data!.vision),
                                SizedBox(height: height(context) * 0.02),
                                AboutAppItem(title:LocaleKeys.OurMessage.tr() ,desc: cubit.aboutAppModel!.data!.msg),
                                SizedBox(height: height(context) * 0.02),
                                AboutAppItem(title:LocaleKeys.OurGoals.tr() ,desc: cubit.aboutAppModel!.data!.goal)
                              ],
                            ),
                          ),
                        ),
                      ]))));
    } ));
  }
}
