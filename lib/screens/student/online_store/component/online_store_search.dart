import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:private_courses/components/cannot_access_content.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/screens/common/drawer/components/custom_zoom_drawer.dart';
import 'package:private_courses/screens/student/course_details/view/course_details_view.dart';
import 'package:private_courses/screens/student/home/components/custom_filter/components/filtered_item.dart';
import 'package:private_courses/screens/student/online_store/controller/online_store_cubit.dart';
import 'package:private_courses/screens/student/product_details/view/product_details_view.dart';
import 'package:private_courses/shared/local/cache_helper.dart';

import '../../../../components/style/size.dart';
import '../../home/components/university_item.dart';
import '../../one_of_faculty/controller/one_of_faculty_cubit.dart';

class OnlineStoreSearch extends StatelessWidget {
  const OnlineStoreSearch({
    super.key,
    required this.cubit,
    required this.courseName,
  });

  final OnlineStoreCubit cubit;
  final String courseName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height(context) * 0.02),
      child: GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: width(context) * 0.005),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 11,
              mainAxisSpacing: 4,
              childAspectRatio: 1.665 / 2.4),
          physics: const BouncingScrollPhysics(),
          itemCount: cubit.storeSearchModel!.data!.length,
          itemBuilder: (context, index) => Padding(
                padding:
                    EdgeInsetsDirectional.only(bottom: height(context) * 0.01),
                child: GestureDetector(
                  onTap: () {
                    CacheHelper.getData(key: AppCached.token) !=null?
                    navigateTo(context, CustomZoomDrawer(
                          mainScreen: ProductDetailsScreen(
                              fromTeacherProfile: false,
                              id: cubit.storeSearchModel!.data![index].id,
                              valueChanged: (v) {
                                cubit.searchCourse(
                                    context: context, courseName: courseName);
                              }),
                          isTeacher: CacheHelper.getData(key: AppCached.role),
                        )):
                    showDialog(context: context, builder: (context) => CannotAccessContent(),);
                  },
                  child: FilteredItem(
                    onTap: () {
                      cubit.saveSearchCourse(
                          context: context,
                          id: cubit.storeSearchModel!.data![index].id,
                          index: index);
                    },
                    courseId: cubit.storeSearchModel!.data![index].id,
                    courseName: cubit.storeSearchModel!.data![index].name,
                    coursePhoto: cubit.storeSearchModel!.data![index].photo,
                    coursePrice: cubit.storeSearchModel!.data![index].price,
                    courseDetails: cubit.storeSearchModel!.data![index].details,
                    duration: cubit.storeSearchModel!.data![index].numHours,
                    isFavorite: cubit.storeSearchModel!.data![index].isFavorite,
                    isInstallment: cubit.storeSearchModel!.data![index].isInstallment,
                  ),
                ),
              )),
    );
  }
}
