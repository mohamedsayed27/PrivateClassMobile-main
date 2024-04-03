import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../components/auth_body.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../core/local/app_cached.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/local/cache_helper.dart';
import '../controller/lang_cubit.dart';
import '../controller/lang_states.dart';
class LanguageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
          create: (context) => LanguageCubit(),
           child: BlocBuilder<LanguageCubit, LanguageStates>(
           builder: (context, state) {
           final cubit = LanguageCubit.get(context);
            return   SafeArea(
               child: Scaffold(
                 body: AuthBody(
                   title: LocaleKeys.ChooseAppLanguage.tr(),withBackArrow: false,
                   margin: EdgeInsetsDirectional.only(top: height(context)*0.04),
                   child: SizedBox(
                     height: height(context)*0.5,
                     child: Stack(
                       children: [
                         Positioned(
                           right:  width(context)*0.068,
                           child: GestureDetector(
                             onTap: (){
                               cubit.selectARLanguage(context);
                             },
                             child: Container(
                               width: width(context)*0.4,
                               height: width(context)*0.4,
                               decoration:  BoxDecoration(
                                 image: DecorationImage(image: AssetImage(CacheHelper.getData(key: AppCached.appLanguage)=="ar"||CacheHelper.getData(key: AppCached.appLanguage)==null?
                                 AppImages.langContainer:AppImages.unSelLangContainer), fit: BoxFit.fill),
                               ),
                               child: Center(child: CustomText(text: 'اللغة العربية',
                                   fontWeight: FontWeight.bold,
                                   fontSize: AppFonts.t4, color: AppColors.whiteColor)),
                             ),
                           ),
                         ),
                         Positioned(
                           bottom: width(context)*0.15,
                           left:  width(context)*0.068,
                           child: GestureDetector(
                             onTap: (){
                               cubit.selectENLanguage(context);
                             },
                             child: Container(
                               width: width(context)*0.4,
                               height: width(context)*0.4,
                               decoration:  BoxDecoration(
                                 image: DecorationImage(image: AssetImage(CacheHelper.getData(key: AppCached.appLanguage)=="en"?AppImages.langContainer:AppImages.unSelLangContainer), fit: BoxFit.fill),
                               ),
                               child: Center(child: CustomText(text: 'English',
                                   fontWeight: FontWeight.bold,
                                   fontSize: AppFonts.t4, color: AppColors.whiteColor)),
                             ),
                           ),
                         ),
                       ],
                     ),
                   ),)

             ),
           );

           }));



  }
}