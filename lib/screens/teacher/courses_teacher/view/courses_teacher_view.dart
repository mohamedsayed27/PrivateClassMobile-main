import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/screens/common/btnNavBar/view/custom_btn_nav_bar_view.dart';
import 'package:private_courses/screens/common/drawer/components/custom_zoom_drawer.dart';
import '../../../../components/custom_appBar.dart';
import '../../../../components/custom_loading.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/empty_list.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/size.dart';
import '../../../../core/local/app_cached.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/local/cache_helper.dart';
import '../components/teacher_course_item.dart';
import '../controller/courses_teacher_cubit.dart';
import '../controller/courses_teacher_states.dart';

class CoursesTeacherScreen extends StatelessWidget {
  const CoursesTeacherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            CoursesTeacherCubit()..getAllCourserTeacher(context),
        child: BlocBuilder<CoursesTeacherCubit, CoursesTeacherStates>(
            builder: (context, state) {
          final cubit = CoursesTeacherCubit.get(context);
          return Scaffold(
              body: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width(context) * 0.04),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomAppBar(isNotify: true),
                        GestureDetector(
                          onTap: (){
                            navigateAndFinish(
                                context: context,
                                widget: CustomZoomDrawer(
                                    mainScreen: CustomBtnNavBarScreen(
                                        page: 3,
                                        isTeacher: CacheHelper.getData(key: AppCached.role)),
                                    isTeacher: CacheHelper.getData(key: AppCached.role)));
                          },
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(CacheHelper.getData(key: AppCached.image)),
                              ),
                              SizedBox(width: width(context) * 0.03),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                      text: "${LocaleKeys.Welcome.tr()} ${CacheHelper.getData(key: AppCached.name)}",
                                      color: AppColors.navyBlue),
                                  CustomText(
                                      text: CacheHelper.getData(key: AppCached.subject)??"",
                                      color: AppColors.goldColor,
                                      fontSize: AppFonts.t8),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: height(context) * 0.025),
                        state is CoursesTeacherLoadingState
                            ? const CustomLoading(load: true)
                            : cubit.getCourserTeacherModel!.data!.isEmpty
                                ? const Expanded(child: const EmptyList())
                                : Expanded(
                                    child: GridView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width(context) * 0.005,
                                          vertical: width(context) * 0.03),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 11,
                                              mainAxisSpacing: 12,
                                              childAspectRatio: 1.84 / 2.45),
                                      itemCount: cubit.getCourserTeacherModel!.data!.length,
                                      itemBuilder: (context, index) {
                                        return TeacherCourseItem(
                                          img: cubit.getCourserTeacherModel!
                                              .data![index].photo!,
                                          name: cubit.getCourserTeacherModel!
                                              .data![index].name!,
                                          details: cubit.getCourserTeacherModel!
                                              .data![index].details!,
                                          duration: cubit
                                              .getCourserTeacherModel!
                                              .data![index]
                                              .duration!,
                                          price: cubit.getCourserTeacherModel!
                                              .data![index].price!,
                                        );
                                      },
                                    ),
                                  ),
                      ])));
        }));
  }
}
