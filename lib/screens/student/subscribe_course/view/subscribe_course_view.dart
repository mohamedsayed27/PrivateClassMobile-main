import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_button.dart';
import 'package:private_courses/components/custom_loading.dart';
import 'package:private_courses/components/custom_text.dart';
import 'package:private_courses/components/custom_toast.dart';
import 'package:private_courses/screens/student/subscribe_course/components/item_pay.dart';
import '../../../../components/custom_appBar.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../generated/locale_keys.g.dart';
import '../controller/subscribe_course_cubit.dart';
import '../controller/subscribe_course_states.dart';

class SubscribeCourseScreen extends StatelessWidget {
  final int? courseId;
  final String? nameCourse ;
  final bool isCart ;
  const SubscribeCourseScreen({super.key,  this.courseId,  this.nameCourse, required this.isCart});


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubscribeCourseCubit(),
      child: BlocBuilder<SubscribeCourseCubit, SubscribeCourseStates>(
          builder: (context, state) {
        final cubit = SubscribeCourseCubit.get(context);
        return Scaffold(
            body: Padding(
          padding: EdgeInsets.symmetric(horizontal: width(context) * 0.04),
          child: Column(children: [
            CustomAppBar(
                isNotify: false, textAppBar: isCart== false ?LocaleKeys.SubscribeCourse.tr():LocaleKeys.Pay.tr()),
            Expanded(
                child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(children: [
                      SizedBox(height: height(context)*0.04),
                      CustomText(text: LocaleKeys.ChoosePayment.tr(),fontSize: AppFonts.t5),
                      SizedBox(height: height(context)*0.04),
                      PayItem(groupValue: cubit.selectedVal, image: AppImages.visaMaster, onTap: (){
                        cubit.changeRadio(cubit.x, "card");
                      },value: cubit.x,onChanged:(value){cubit.changeRadio(value, "card");} ,
                          label: LocaleKeys.Visa.tr()),
                      PayItem(groupValue: cubit.selectedVal, image: AppImages.keyNet, onTap: (){
                        cubit.changeRadio(cubit.y, "kw.knet");
                      },value: cubit.y,onChanged:(value){cubit.changeRadio(value, "kw.knet");} ,label: LocaleKeys.KeyNet.tr()),
                      PayItem(groupValue: cubit.selectedVal, image: AppImages.mada, onTap: (){
                        cubit.changeRadio(cubit.z, "sa.mada");
                      },value: cubit.z,onChanged:(value){cubit.changeRadio(value, "sa.mada");} ,label: LocaleKeys.Mada.tr()),
                      SizedBox(height: height(context)*0.15),
                      isCart == false ? state is SubscribeNowLoadingState ? CustomLoading(load: false): CustomButton(colored: true, onPressed: ()async{
                        if(cubit.type ==null){
                          showSnackBar(context: context, text: LocaleKeys.ChoosePayment.tr(), success: false);
                        }else{
                        await cubit.subscribe(context: context, courseId:courseId!,courseName: nameCourse!,isCart: isCart);}
                      },text: LocaleKeys.SubscribeNow.tr()):state is PayNowLoadingState ? CustomLoading(load: false):CustomButton(colored: true, onPressed: ()async{
                        if(cubit.type==null){
                          showSnackBar(context: context, text: LocaleKeys.ChoosePayment.tr(), success: false);
                        }else{
                        await cubit.payment(context: context,isCart: isCart);
                        }
                      },text: LocaleKeys.PayNow.tr()),
                      SizedBox(height: height(context)*0.02)
                    ])))
          ]),
        ));
      }),
    );
  }
}
