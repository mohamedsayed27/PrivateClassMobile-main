import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_appBar.dart';
import 'package:private_courses/components/custom_text.dart';
import 'package:private_courses/components/empty_list.dart';
import 'package:private_courses/components/loadin_shimmer_home.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/components/style/size.dart';
import 'package:private_courses/generated/locale_keys.g.dart';
import 'package:private_courses/screens/common/profile/view/profile_screen.dart';
import 'package:private_courses/screens/student/all_secondary/components/secondary_view.dart';
import 'package:private_courses/screens/student/course_details/view/course_details_view.dart';
import 'package:private_courses/screens/student/home/components/custom_filter/view/custom_filter_view.dart';
import 'package:private_courses/screens/student/home/components/homeitem.dart';
import 'package:private_courses/screens/student/home/components/live_item.dart';
import 'package:private_courses/screens/student/home/components/search_widget.dart';
import 'package:private_courses/screens/student/home/components/uniList.dart';
import '../../../../components/custom_loading.dart';
import '../../../../components/custom_toast.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/text_form_field_serch.dart';
import '../../../../core/local/app_cached.dart';
import '../../../../shared/local/cache_helper.dart';
import '../../../common/drawer/components/custom_zoom_drawer.dart';
import '../components/course_item.dart';
import '../components/watch_all/view/watch_all_view.dart';
import '../controller/home_cubit.dart';
import '../controller/home_states.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    return GestureDetector(
      onTap: () {
        currentFocus.unfocus();
      },
      child: BlocProvider<HomeCubit>(
        create: (context) => HomeCubit()..getCurrentCourse(context),
        child: BlocConsumer<HomeCubit, HomeStates>(
          listener: (context, state) {
            if (state is HomeFailedState) {
              showSnackBar(context: context, text: state.error, success: false);
            }
          },
          builder: (context, state) {
            final cubit = HomeCubit.get(context);
            return Scaffold(
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: width(context) * 0.04),
                child: Column(
                  children: [
                    CustomAppBar(isNotify: true),
                    CacheHelper.getData(key: AppCached.token) == null
                        ? const SizedBox.shrink()
                        : GestureDetector(
                           onTap: (){
                             navigateTo(context,  ProfileScreen(isDrawer: true,isTeacher: CacheHelper.getData(key: AppCached.role)));
                             },
                          child: Row(
                              children: [
                                CircleAvatar(
                                    radius: 18,
                                    backgroundColor: AppColors.whiteColor,
                                    backgroundImage: NetworkImage(
                                        CacheHelper.getData(
                                            key: AppCached.image))),
                                SizedBox(width: width(context) * 0.02),
                                CustomText(
                                    text: LocaleKeys.Hello.tr(),
                                    color: AppColors.navyBlue),
                                SizedBox(width: width(context) * 0.012),
                                SizedBox(
                                  width: width(context)*0.6,
                                  child: CustomText(
                                      text: CacheHelper.getData(key: AppCached.name),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      color: AppColors.navyBlue),
                                )
                              ],
                            ),
                        ),
                    SizedBox(height: height(context) * 0.03),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFormFieldSearch(
                            ctrl: cubit.searchCtrl,
                            hintText: LocaleKeys.SearchOf.tr(),
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                cubit.isSearch = true;
                                cubit.searchCourse(context: context, courseName: value);
                              } else {
                                cubit.isSearch = false;
                                cubit.getCurrentCourse(context);
                              }
                            },
                          ),
                        ),
                        SizedBox(width: width(context) * 0.02),
                        GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (_) => CustomFilter(),
                                  backgroundColor: AppColors.whiteColor,
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(
                                              height(context) * 0.05))));
                            },
                            child: Image.asset(AppImages.filter, scale: 3)),
                      ],
                    ),
                    SizedBox(height: height(context) * 0.02),
                    cubit.isSearch == true
                    ? state is SearchCourseLoadingState
                        ? CustomLoading(load: false):
                          cubit.searchModel!.data == null ? Expanded(child: EmptyList()): Expanded(
                          child: SearchWidget(
                                        searchModel: cubit.searchModel,
                                        courseName: cubit.searchCtrl.text,
                                        cubit: cubit))
                          : state is HomeLoadingState
                          ? LoadingShimmer()
                          : Expanded(
                                    child: SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CacheHelper.getData(key: AppCached.token)!=null ?
                                          cubit.currentCourseModel!.data!.isEmpty
                                          ? const SizedBox.shrink()
                                          : SizedBox(
                                                  height: height(context) * 0.16,
                                                  child: ListView.separated(
                                                    scrollDirection: Axis.horizontal,
                                                    padding: EdgeInsets.all(width(context) * 0.01),
                                                    physics: const BouncingScrollPhysics(),
                                                    itemCount: cubit.currentCourseModel!.data!.length,
                                                    separatorBuilder: (context, index) =>
                                                        SizedBox(width: width(context) * 0.025),
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        ((context, index) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          navigateTo(
                                                              context,
                                                              CustomZoomDrawer(
                                                                  mainScreen: CourseDetailsScreen(fromTeacherProfile: false,
                                                                          courseId: cubit.currentCourseModel!.data![index].id,
                                                                          courseName: cubit.currentCourseModel!.data![index].name,
                                                                          valueChanged: (v) {
                                                                            cubit.getCurrentCourse(context);
                                                                          }),
                                                                  isTeacher: CacheHelper.getData(key: AppCached.role)));
                                                        },
                                                        child: CourseItem(
                                                          courseId: cubit.currentCourseModel!.data![index].id,
                                                          percent: cubit.currentCourseModel!.data![index].progress,
                                                          courseName: cubit.currentCourseModel!.data![index].name,
                                                          leftCourses: "${cubit.currentCourseModel!.data![index].countVideos.toString()} ${LocaleKeys.LessonsLeft.tr()}",
                                                          courseImage: cubit.currentCourseModel!.data![index].photo,
                                                        ),
                                                      );
                                                    }),
                                                  ),
                                                ) : SizedBox.shrink(),
                                          SizedBox(
                                              height: height(context) * 0.03),
                                          CacheHelper.getData(key: AppCached.token)!=null ?
                                          Row(
                                            children: [
                                              Image.asset(AppImages.live, scale: 4.5),
                                              SizedBox(
                                                  width: width(context) * 0.015),
                                              CustomText(
                                                  text: LocaleKeys.Live.tr()),
                                              const Spacer(),
                                              cubit.currentLives.isEmpty
                                                  ? SizedBox.shrink()
                                                  : GestureDetector(
                                                      onTap: () {
                                                        navigateTo(context, CustomZoomDrawer(
                                                              isTeacher: CacheHelper.getData(key: AppCached.role),
                                                              mainScreen: WatchAllView(cubit: cubit),
                                                            ));
                                                      },
                                                      child: CustomText(
                                                          text: LocaleKeys.ViewAll.tr(),
                                                          color: AppColors.goldColor,
                                                          fontSize: AppFonts.t8),
                                                    )
                                            ],
                                          ) : SizedBox.shrink(),
                                          SizedBox(height: height(context) * 0.015),
                                          CacheHelper.getData(key: AppCached.token)!=null ?
                                          cubit.currentLives.isEmpty
                                          ? Align(
                                                  alignment: AlignmentDirectional.center,
                                                  child: SizedBox(
                                                      height: height(context) * 0.25,
                                                      child: Column(
                                                        children: [
                                                          SizedBox(height: height(context) * 0.02),
                                                          Image.asset(
                                                              AppImages.notLives,
                                                              scale: 5),
                                                          CustomText(
                                                              text: LocaleKeys.NotLives.tr(),
                                                              color: AppColors.navyBlue,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: AppFonts.t6),
                                                        ],
                                                      )),
                                                )
                                          : SizedBox(
                                                  height: height(context) * 0.26,
                                                  child: ListView.separated(
                                                      scrollDirection: Axis.horizontal,
                                                      physics: const BouncingScrollPhysics(),
                                                      padding: EdgeInsets.symmetric(vertical: height(context) * 0.01,
                                                          horizontal: width(context) * 0.01),
                                                      shrinkWrap: true,
                                                      itemBuilder:
                                                          (context, index) => LiveItem(
                                                                  cross: CrossAxisAlignment.start,
                                                                  teacherName: cubit.currentLives[index].teacherName!,
                                                                  onTap: () {
                                                                    if (cubit.currentLives[index].active == true &&
                                                                        cubit.currentLives[index].finish == false) {
                                                                      cubit.joinMeeting(roomText: cubit.currentLives[index].slug!, context: context);
                                                                    } else if (cubit.currentLives[index].active == false &&
                                                                        cubit.currentLives[index].finish == false) {
                                                                      showSnackBar(
                                                                          context: context,
                                                                          text: LocaleKeys.NotLives.tr(),
                                                                          success: true);
                                                                    } else if (cubit.currentLives[index].active == false &&
                                                                        cubit.currentLives[index].finish == true) {
                                                                      showSnackBar(
                                                                          context: context,
                                                                          text: LocaleKeys.BroadcastCompleted.tr(),
                                                                          success: true);
                                                                    }
                                                                  },
                                                                  teacherPhoto: cubit.currentLives[index].teacherPhoto!,
                                                                  lectureName: cubit.currentLives[index].liveName!,
                                                                  liveDate: cubit.currentLives[index].date,
                                                                  liveTime: cubit.currentLives[index].time),
                                                      separatorBuilder: (context, index) => SizedBox(width: width(context) * 0.025),
                                                      itemCount: cubit.currentLives.length > 5 ? 5 : cubit.currentLives.length),
                                                ) : SizedBox.shrink(),
                                          SizedBox(
                                            height: height(context) * 0.052,
                                            child: ListView(
                                              physics: const BouncingScrollPhysics(),
                                              scrollDirection: Axis.horizontal,
                                              children: List.generate(
                                                  cubit.names.length,
                                                      (index) => HomeItem(
                                                      decoration: cubit.currentIndex == index
                                                          ? BoxDecoration(
                                                        image: const DecorationImage(
                                                            image: AssetImage(AppImages.backSaves),
                                                            fit: BoxFit.fill),
                                                        borderRadius: BorderRadius.circular(25),
                                                      )
                                                          : BoxDecoration(
                                                        border: Border.all(color: AppColors.navyBlue),
                                                        borderRadius: BorderRadius.circular(25),
                                                      ),
                                                      img: cubit.allCategoriesImages[index],
                                                      label: cubit.names[index],
                                                      color: cubit.currentIndex == index ? AppColors.whiteColor : AppColors.navyBlue,
                                                      onTap: () {
                                                        cubit.changeBottom(index,context);
                                                      })

                                              ),
                                            ),
                                          ),
                                          SizedBox(height: height(context)*0.03,),
                                          cubit.currentIndex==0?
                                          state is GetAllSecondaryLoadingState?
                                          CustomLoading(load: false):
                                          UniList(
                                            cubit: cubit,
                                            universityId: 1,
                                          ):
                                              state is GetAllSecondaryLoadingState?
                                          CustomLoading(load: false):
                                          SecondaryView(cubit: cubit, secondaryId: 2)
                                        ],
                                      ),
                                    ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

