import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_button.dart';
import 'package:private_courses/components/custom_loading.dart';
import 'package:private_courses/components/custom_text.dart';
import 'package:private_courses/components/custom_textfield.dart';
import 'package:private_courses/components/custom_toast.dart';
import 'package:private_courses/components/style/colors.dart';
import 'package:private_courses/components/style/images.dart';
import 'package:private_courses/components/style/size.dart';
import 'package:private_courses/generated/locale_keys.g.dart';
import 'package:private_courses/screens/student/course_details/controller/course_details_cubit.dart';
import 'package:private_courses/screens/student/course_details/controller/course_details_states.dart';

class UnSubscribeDialog extends StatelessWidget {
  final int id ;
  const UnSubscribeDialog({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CourseDetailsCubit(),
      child: BlocConsumer<CourseDetailsCubit,CourseDetailsStates>(builder: (context,state){
        final cubit = CourseDetailsCubit.get(context);
        return Scaffold(
          backgroundColor: AppColors.grayBorderColor.withOpacity(0.01),
          body: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: width(context) * 0.05),
              physics: const BouncingScrollPhysics(),
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: width(context) * 0.04,
                    vertical: height(context) * 0.02),
                decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: height(context) * 0.02),
                      CustomText(
                          text: LocaleKeys.ReasonOf.tr(),
                          fontWeight: FontWeight.bold,
                          fontSize: AppFonts.t4,
                          color: AppColors.navyBlue,
                          textAlign: TextAlign.center),
                      SizedBox(height: height(context) * 0.03),
                      CustomTextFormField(
                        hint: LocaleKeys.UserName.tr(),
                        contentPadding: EdgeInsets.symmetric(horizontal: width(context)*0.03),
                        ctrl: cubit.userNameCtrl,
                      ),
                      SizedBox(height: height(context) * 0.02),
                      CustomTextFormField(
                        hint: LocaleKeys.PhoneNum.tr(),
                        contentPadding: EdgeInsets.symmetric(horizontal: width(context)*0.03),
                        ctrl: cubit.phoneCtrl,
                        type: TextInputType.number,
                      ),
                      SizedBox(height: height(context) * 0.02),
                      CustomTextFormField(
                        hint: LocaleKeys.AccNum.tr(),
                        contentPadding: EdgeInsets.symmetric(horizontal: width(context)*0.03),
                        ctrl: cubit.accNumberCtrl,
                        type: TextInputType.number,
                      ),
                      SizedBox(height: height(context) * 0.02),
                      CustomTextFormField(
                        hint: LocaleKeys.IbanNum.tr(),
                        contentPadding: EdgeInsets.symmetric(horizontal: width(context)*0.03),
                        ctrl: cubit.ibanCtrl,
                        type: TextInputType.number,
                      ),
                      SizedBox(height: height(context) * 0.02),
                      CustomTextFormField(
                        hint: LocaleKeys.Reason.tr(),
                        contentPadding: EdgeInsets.symmetric(horizontal: width(context)*0.03),
                        ctrl: cubit.reasonCtrl,
                      ),
                      SizedBox(height: height(context) * 0.02),
                     state is UnSubscribeCourseLoadingState ? CustomLoading(load: false): SizedBox(
                       width: width(context)*0.6,
                       child: CustomButton(
                            onPressed: ()async {
                              if(cubit.reasonCtrl.text.isEmpty){
                                showSnackBar(context: context, text: LocaleKeys.PleaseReason.tr(), success: false);
                              }else{
                                await cubit.unSubscribe(context: context, id: id);
                              }
                            },
                            colored: true,
                            text: LocaleKeys.Send.tr()),
                     ),
                      SizedBox(height: height(context) * 0.01)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ) ;
      }, listener: (context,state){}),
    );
  }
}
