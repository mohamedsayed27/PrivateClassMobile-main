import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/cannot_access_content.dart';
import 'package:private_courses/components/custom_loading.dart';
import 'package:private_courses/components/empty_list.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/screens/common/btnNavBar/view/custom_btn_nav_bar_view.dart';
import 'package:private_courses/screens/common/drawer/components/custom_zoom_drawer.dart';
import 'package:private_courses/screens/student/product_details/view/product_details_view.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../components/custom_appBar.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/custom_toast.dart';
import '../../../../components/fade_animation.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../components/text_form_field_serch.dart';
import '../../../../generated/locale_keys.g.dart';
import '../component/build_dot.dart';
import '../component/online_store_search.dart';
import '../component/store_item.dart';
import '../controller/online_store_cubit.dart';
import '../controller/online_store_states.dart';

class OnlineStoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    return GestureDetector(
      onTap: () {
        currentFocus.unfocus();
      },
      child: BlocProvider(
          create: (context) => OnlineStoreCubit()..fetchStoreSlider(context: context),
          child: BlocConsumer<OnlineStoreCubit, OnlineStoreStates>(
              listener: (context, state) {
            if (state is AddToCartSuccessState) {
              showSnackBar(context: context, success: true, text: state.msg);
            } else if (state is AddToCartFailedState) {
              showSnackBar(context: context, success: false, text: state.msg);
            }
          }, builder: (context, state) {
            final cubit = OnlineStoreCubit.get(context);
            return SafeArea(
              child: Scaffold(
                  body: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: width(context) * 0.04),
                      child: Column(
                        children: [
                          CustomAppBar(
                            isNotify: true,
                            isDrawer: true,
                            textAppBar: LocaleKeys.OnlineStore.tr(),
                          ),
                          CustomTextFormFieldSearch(
                            ctrl: cubit.searchCtrl,
                            hintText: LocaleKeys.SearchOf.tr(),
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                cubit.searchCourse(context: context, courseName: value);
                                cubit.isSearch = true;
                              } else {
                                cubit.isSearch = false;
                                cubit.fetchStoreSlider(context: context);
                              }
                            },
                          ),
                          SizedBox(height: height(context)*0.01),
                          state is LoadingState?
                            CustomLoading(load: true):
                          cubit.isSearch == true ? cubit.storeSearchModel!.data!.isEmpty
                                  ? const Expanded(child: EmptyList())
                                  : Expanded(
                                      child: OnlineStoreSearch(
                                          cubit: cubit,
                                          courseName: cubit.searchCtrl.text))
                              : Expanded(
                                  child: SmartRefresher(
                                    physics: const BouncingScrollPhysics(),
                                    controller: cubit.refreshController,
                                    enablePullUp: true,
                                    enablePullDown: false,
                                    onLoading: () async {
                                      print("reeeeeeeeeeeeeeeeeeeeeeee");
                                      final result = await cubit.fetchMoreCat(
                                          context: context);
                                      if (result!) {
                                        cubit.refreshController.loadComplete();
                                      } else {
                                        cubit.refreshController.loadFailed();
                                      }
                                    },
                                    child: SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      child: state is LoadingState
                                          ? const CustomLoading(load: true)
                                          : Column(children: [
                                              SizedBox(height: height(context) * 0.05),
                                              if(CacheHelper.getData(key: AppCached.token)!=null)
                                              FadeAnimation(
                                                1.2,
                                                1,
                                                CarouselSlider(
                                                  options: CarouselOptions(
                                                    initialPage: cubit.numSlider,
                                                    onPageChanged: (index, reason) {
                                                      cubit.changeSlider(index);
                                                    },
                                                    autoPlay: true,
                                                    viewportFraction: 1,
                                                    height:
                                                        height(context) * 0.179,
                                                  ),
                                                  items: List.generate(
                                                    cubit.storeSliderModel!.data!.length,
                                                    (index) => Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: width(context) * 0.01),
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          cubit.storeSliderModel!.data![index].type=="link"?
                                                          !await launchUrl(
                                                            Uri.parse(cubit.storeSliderModel!.data![index].link!),
                                                            mode: LaunchMode.externalApplication,
                                                          ):
                                                          navigateTo(context, CustomZoomDrawer(
                                                              mainScreen: ProductDetailsScreen(
                                                                id: cubit.storeSliderModel!.data![index].course_id!,
                                                                fromTeacherProfile: false,
                                                                valueChanged:
                                                                    (v) {
                                                                  cubit.fetchStoreSlider(context: context);
                                                                },
                                                              ),
                                                              isTeacher: CacheHelper.getData(key: AppCached.role)));
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(10),
                                                              color: Colors.black),
                                                          child: Image.network(
                                                            cubit.storeSliderModel!.data![index].photo!,
                                                            fit: BoxFit.fill,
                                                            width: width(context) * 0.9,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                  height: height(context) * 0.018),
                                              if(CacheHelper.getData(key: AppCached.token)!=null)
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: List.generate(cubit.storeSliderModel!.data!.length, (index) {
                                                  return buildDot(index, cubit, context);
                                                }),
                                              ),
                                              SizedBox(height: height(context) * 0.02),
                                              Align(
                                                alignment: AlignmentDirectional.topStart,
                                                child: CustomText(text: LocaleKeys.TheCategories.tr(),
                                                    color: AppColors.blackColor,
                                                    fontSize: AppFonts.t5),
                                              ),
                                              SizedBox(height: height(context) * 0.01),
                                              SizedBox(
                                                height: height(context) * 0.052,
                                                child: ListView.builder(
                                                    physics: const BouncingScrollPhysics(),
                                                    scrollDirection: Axis.horizontal,
                                                    itemBuilder: (context, index) {
                                                      return InkWell(
                                                        borderRadius: BorderRadius.circular(25),
                                                        onTap: () {
                                                          cubit.changeColor(index);
                                                          cubit.changeCurrentPage(index);
                                                          cubit.fetchCouersesById(context: context);
                                                          print(cubit.categories[index].id);
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsetsDirectional.only(
                                                            top: width(context) * 0.016,
                                                            bottom: width(context) * 0.016,
                                                            start: width(context) * 0.01,
                                                            end: width(context) * 0.05,
                                                          ),
                                                          margin: EdgeInsetsDirectional.only(end: width(context) *0.016),
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
                                                          child: Row(
                                                            children: [
                                                              Image.asset(cubit.allCategoriesImages[index]),
                                                              SizedBox(width: width(context) *0.019),
                                                              CustomText(
                                                                text: cubit.categories[index].name!,
                                                                color: cubit.currentIndex == index
                                                                    ? AppColors.whiteColor
                                                                    : AppColors.navyBlue,
                                                                fontSize: AppFonts.t9,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    itemCount: 3),
                                              ),
                                              SizedBox(height: height(context) * 0.038),
                                              GridView.builder(
                                                physics: const NeverScrollableScrollPhysics(),
                                                padding: EdgeInsets.symmetric(horizontal: width(context) * 0.005),
                                                shrinkWrap: true,
                                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 2,
                                                        crossAxisSpacing: 11,
                                                        mainAxisSpacing: 9,
                                                        childAspectRatio: 1.9 / 2.9),
                                                itemCount: cubit.catStage.length,
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      CacheHelper.getData(key: AppCached.token) !=null?
                                                      navigateTo(context, CustomZoomDrawer(
                                                              mainScreen: ProductDetailsScreen(
                                                                id: cubit.catStage[index].id,
                                                                fromTeacherProfile: false,
                                                                valueChanged:
                                                                    (v) {
                                                                  cubit.fetchStoreSlider(context: context);
                                                                },
                                                              ),
                                                              isTeacher: CacheHelper.getData(key: AppCached.role))):
                                                      showDialog(context: context, builder: (context) => CannotAccessContent(),);
                                                      // navigateTo(context,  ProductDetailsScreen(id: cubit.catStage[index].id,));
                                                    },
                                                    child: StoreItem(
                                                      cubit: cubit,
                                                      index: index
                                                    ),
                                                  );
                                                },
                                              ),
                                              SizedBox(
                                                  height:
                                                      height(context) * 0.02)
                                            ]),
                                    ),
                                  ),
                                ),
                        ],
                      ))),
            );
          })),
    );
  }
}
