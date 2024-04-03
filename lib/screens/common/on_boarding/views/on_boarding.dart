import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_loading.dart';
import 'package:private_courses/components/style/images.dart';
import 'package:private_courses/generated/locale_keys.g.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/my_navigate.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/size.dart';
import '../../../../core/local/app_cached.dart';
import '../../../../shared/local/cache_helper.dart';
import '../../auth/choose_type_a_login/choose_type.dart';
import '../controllers/on_boarding_cubit.dart';
import '../controllers/on_boarding_states.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({Key? key}) : super(key: key);

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  PageController? _controller;
  @override
  void initState() {
    _controller=PageController(initialPage: 0);
    super.initState();
  }
  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:(context)=> OnBoardingCubit()..onBoardingDate(context: context),
      child: BlocBuilder<OnBoardingCubit, OnBoardingStates>(
        builder: (context, states){
         final  cubit = OnBoardingCubit.get(context);
          return SafeArea(
              child:Scaffold(
                body: states is OnBoardingLoadingState ?const CustomLoading(load: true):
                Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        physics: const BouncingScrollPhysics(),
                        controller: _controller,
                        onPageChanged: (int index){
                          cubit.changeIndex(index);
                        },
                        itemBuilder: (context,index){
                          return Padding(
                            padding:  EdgeInsets.only(top:height(context)*0.09,right:height(context)*0.015,
                                left: height(context)*0.015
                            ),
                            child: Column(
                              children: [
                                 Image.network(cubit.onBoardingModel!.data![index].image!,height: height(context)*.33,),
                                SizedBox(height: height(context)*0.02,),
                                CustomText(text: cubit.onBoardingModel!.data![index].title!, color: Colors.black,fontSize: AppFonts.t3,fontWeight: FontWeight.bold,),
                                SizedBox(height: height(context)*0.014,),
                                CustomText(text: cubit.onBoardingModel!.data![index].desc!,color: AppColors.greyTextColor,
                                    textAlign: TextAlign.center, fontSize: AppFonts.t4)
                              ],
                            ),
                          );
                        },itemCount: cubit.onBoardingModel!.data!.length,),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate( cubit.onBoardingModel!.data!.length, (index) {
                        return Container(
                          width: cubit.currentIndex==index? width(context)*0.11:width(context)*0.0223,
                          height: width(context)*0.0223,
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: cubit.currentIndex==index? AppColors.goldColor:AppColors.dotGrayColor,
                            borderRadius: BorderRadius.circular(20),

                          ),
                        );
                      }),
                    ),
                    SizedBox(height: height(context)*0.01,),
                    Stack(
                      children: [
                        SizedBox(
                          width: width(context),
                          height: height(context)*0.15,),
                        Positioned(
                            left: 0,
                            child: Image.asset(AppImages.shape, width: width(context)*0.81,)),
                       cubit.currentIndex==cubit.onBoardingModel!.data!.length -1?
                        Positioned(
                            top: width(context)*0.06,
                            right: width(context)*0.06,
                            left: width(context)*0.06,
                            child: CustomButton(text: LocaleKeys.Start.tr(),onPressed: (){
                              navigateAndFinish(context: context,widget: const ChooseTypeALoginScreen());
                            },colored: true,fontWeight: FontWeight.bold,)) :
                        Positioned(
                            top: width(context)*0.06,
                            right: width(context)*0.06,
                            child: GestureDetector(
                                onTap: (){
                                  _controller!.nextPage(duration: const Duration(milliseconds: 200),
                                      curve: Curves.linear);
                                },
                                child: Image.asset(AppImages.colorArrow, width: width(context)*0.15,)))

                      ],
                    ),


                  ],
                ),
              )
          );
        },
      )
    );


  }

}
