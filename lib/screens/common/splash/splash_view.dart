import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/screens/common/auth/login/view/login_view.dart';
import 'package:private_courses/screens/common/btnNavBar/view/custom_btn_nav_bar_view.dart';
import 'package:private_courses/screens/common/on_boarding/views/on_boarding.dart';
import 'package:private_courses/screens/common/splash/splash_cubit.dart';
import 'package:private_courses/screens/common/splash/splash_states.dart';
import '../../../components/fade_animation.dart';
import '../../../components/my_navigate.dart';
import '../../../components/style/colors.dart';
import '../../../components/style/images.dart';
import '../../../components/style/size.dart';
import '../../../core/local/app_cached.dart';
import '../../../shared/local/cache_helper.dart';
import '../drawer/components/custom_zoom_drawer.dart';
import '../language/view/lang_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 5)).then((value) => navigateAndFinish(
      context: context,
      widget: CacheHelper.getData(key: AppCached.appLanguage) == null
          ? LanguageScreen()
          : CacheHelper.getData(key: AppCached.isFirst) == null
          ? const OnBoardingView()
          : CacheHelper.getData(key: AppCached.token) == null
          ? const LoginScreen()
          : CustomZoomDrawer(
          mainScreen: CustomBtnNavBarScreen(
              page: 0,
              isTeacher: CacheHelper.getData(
                  key: AppCached.role)),
          isTeacher: CacheHelper.getData(
              key: AppCached.role)),
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..getPayKey(context: context),
      child: BlocBuilder<SplashCubit,SplashStates>(
        builder: (BuildContext context, state) { 
          return SafeArea(
            child: Scaffold(
              body: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImages.splashBG),
                    fit: BoxFit.fill,
                  ),
                ),
                child: FadeAnimation(
                  1,
                  2,
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(AppImages.logo, width: 0.44 * width(context)),
                        SizedBox(
                          height: 0.05 * height(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },),
    );
  }
}