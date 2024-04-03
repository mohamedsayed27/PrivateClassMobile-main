import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:private_courses/components/custom_text.dart';
import 'package:private_courses/components/style/images.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/generated/locale_keys.g.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import '../../../../components/my_navigate.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/size.dart';
import '../register/components/custom_sel_container.dart';
import '../register/view/register_view.dart';

class ChooseTypeALoginScreen extends StatelessWidget {
  const ChooseTypeALoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
       child: Scaffold(
           body: Container(
             height: height(context),
            width: width(context),
            decoration:  const BoxDecoration(
            image: DecorationImage(image: AssetImage(AppImages.whiteBackGround),
            fit: BoxFit.fill)),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
              children: [
               Padding(
                padding:  EdgeInsets.symmetric(vertical: height(context)*0.06, horizontal: width(context)*0.08),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: LocaleKeys.TextRegisterAs.tr(),color: Colors.black, fontWeight: FontWeight.bold, fontSize: AppFonts.t5),
                  Row(
                    children: [
                      CustomText(text:LocaleKeys.Platform.tr(),color: Colors.black, fontWeight: FontWeight.bold, fontSize: AppFonts.t5),
                      CustomText(text: " ${LocaleKeys.Classes.tr()}",fontWeight: FontWeight.bold, fontSize: AppFonts.t5, color:AppColors.mainColor),
                      CustomText(text:" ${LocaleKeys.Private.tr()}",fontWeight: FontWeight.bold, fontSize: AppFonts.t5, color: AppColors.goldColor),
                    ],
                  ),
                  SizedBox(height: height(context)*0.08,),
                  Center(child: Image.asset(AppImages.backSplash, width: width(context)*0.5)),
                  SizedBox(height: height(context)*0.082,),
                  Center(child: CustomText(text: LocaleKeys.RegisterAs.tr(), fontWeight: FontWeight.bold, fontSize: AppFonts.t6,color: Colors.black)),
                  SizedBox(height: height(context)*0.022,),
                  Row(
                    children: [
                      CustomSelContainer(img: AppImages.student,background: AppImages.blueContainer,text:LocaleKeys.Student.tr() ,
                        onTap: (){
                        CacheHelper.saveData(AppCached.isTeacher, false);
                        CacheHelper.saveData(AppCached.isFirst,false);
                        CacheHelper.saveData(AppCached.role, "student");
                        navigateTo(context,const RegisterScreen());
                      },),
                     const Spacer(),
                      CustomSelContainer(img: AppImages.teacher,background: AppImages.goldContainer,text:LocaleKeys.Teacher.tr() ,
                        onTap: (){
                          CacheHelper.saveData(AppCached.isTeacher, true);
                          CacheHelper.saveData(AppCached.isFirst,false);
                          CacheHelper.saveData(AppCached.role, "teacher");
                          navigateTo(context, const RegisterScreen());
                      },),

                    ],
                  )




                ],
              ),
          ),

        ],
      ),
            ),)
    ));
  }
}
