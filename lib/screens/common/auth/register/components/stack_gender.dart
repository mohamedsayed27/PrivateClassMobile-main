import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../components/custom_text.dart';
import '../../../../../components/style/colors.dart';
import '../../../../../components/style/size.dart';
import '../../../../../core/local/app_cached.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../../shared/local/cache_helper.dart';
import '../controller/register_cubit.dart';
import '../controller/register_states.dart';

class StackGender extends StatelessWidget {
   const StackGender({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context,state){},
       builder: (context,state){
    final cubit = RegisterCubit.get(context);
      return  Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: height(context)*0.09,
          margin: EdgeInsets.fromLTRB(0, width(context)*0.056, 0, width(context)*0.056),
          padding: EdgeInsets.only(bottom: width(context)*0.028),
          decoration: BoxDecoration(
            border: Border.all(
                color: AppColors.textFieldBackColor, width: 1),
            borderRadius: BorderRadius.circular(34),
          ),
        ),
        Positioned(
          right: context.locale.languageCode=="ar"? width(context)*0.085:0.0,
          left:context.locale.languageCode=="ar"? 0.0:width(context)*0.085,
          top: width(context)*0.02,
          child: Container(
              color: AppColors.whiteColor,
              margin: EdgeInsetsDirectional.only(end: width(context)*0.68),
              child: CustomText(text:LocaleKeys.Gender.tr(),color: AppColors.grayColor,fontSize: AppFonts.t7)),
        ),
        Positioned(
          bottom: height(context)*0.04,
          right:context.locale.languageCode=="ar"?  width(context)*0.05:0.0,
          left: context.locale.languageCode=="ar"?  width(context)*0.0:0.05,
          child: Row(
            children: [
              Radio(
                activeColor: AppColors.mainColor,
                value: "male",
                groupValue: cubit.gender,
                onChanged: (val) async {
                  cubit.changeGender(val);
                },
              ),
              CustomText(
                text:LocaleKeys.Male.tr(),
                color: AppColors.grayColor,
                fontSize: AppFonts.t8,
              ),
              Radio(
                activeColor: AppColors.mainColor,
                value: "female",
                groupValue: cubit.gender,
                onChanged: (val) async {
                  cubit.changeGender(val);

                },
              ),
              CustomText(
                text: LocaleKeys.Female.tr(),
                color: AppColors.grayColor,
                fontSize: AppFonts.t7,
              ),

            ],
          ),
        ),

      ],
    );
    });

  }
}
