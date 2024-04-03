import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/screens/common/drawer/components/custom_zoom_drawer.dart';
import 'package:private_courses/screens/student/course_details/components/subscribe_sccess.dart';
import 'package:private_courses/screens/student/lecture_details_videos/view/lecture_details_view.dart';
import 'package:private_courses/screens/student/subscribe_course/view/subscribe_course_view.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/local/cache_helper.dart';
import '../../lecture_details_videos/components/not_pay.dart';
import '../controller/course_details_cubit.dart';
import '../controller/course_details_states.dart';

class AttachmentsTeacher extends StatelessWidget {
  const AttachmentsTeacher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CourseDetailsCubit, CourseDetailsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = CourseDetailsCubit.get(context);
          return Padding(
            padding: EdgeInsets.symmetric(vertical: height(context) * 0.02),
            child:
            cubit.courseDetailsModel!.data!.attachments!.isEmpty?
            Center(child: CustomText(text: LocaleKeys.NoAttach.tr())):
            ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => SizedBox(
                  width: width(context)*0.9,
                  child: cubit.courseDetailsModel!.data!.attachments![index].type=="image"?
                  InkWell(
                    onTap: ()async{
                      if (!await launchUrl(
                        Uri.parse(cubit.courseDetailsModel!.data!.attachments![index].file!),
                        mode: LaunchMode.externalApplication,
                      )) {
                        throw 'Could not launch ${cubit.courseDetailsModel!.data!.attachments![index].file!}';
                      }},
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                              color: AppColors.textFieldColor,
                              offset: Offset(0.5, 0.5),
                              spreadRadius: 0.5,
                              blurRadius: 0.5),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: height(context) * 0.01,
                          horizontal: width(context) * 0.015),
                      margin: EdgeInsets.symmetric(
                          vertical: height(context) * 0.01,
                          horizontal: width(context) * 0.015),
                      child: Column(
                        children: [
                          cubit.courseDetailsModel!.data!.attachments![index].name==null?
                          SizedBox.shrink():
                          CustomText(text: cubit.courseDetailsModel!.data!.attachments![index].name!),
                          SizedBox(height: height(context)*0.02,),
                          Image.network(cubit.courseDetailsModel!.data!.attachments![index].file!,height: height(context)*0.2,)
                        ],
                      ),
                    ),
                  ):
                  InkWell(
                    onTap: ()async{
                      if (!await launchUrl(
                        Uri.parse(cubit.courseDetailsModel!.data!.attachments![index].file!),
                        mode: LaunchMode.externalApplication,
                      )) {
                        throw 'Could not launch ${cubit.courseDetailsModel!.data!.attachments![index].file!}';
                      }},
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                              color: AppColors.textFieldColor,
                              offset: Offset(0.5, 0.5),
                              spreadRadius: 0.5,
                              blurRadius: 0.5),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: height(context) * 0.01,
                          horizontal: width(context) * 0.015),
                      margin: EdgeInsets.symmetric(
                          vertical: height(context) * 0.01,
                          horizontal: width(context) * 0.015),
                      child: cubit.courseDetailsModel!.data!.attachments![index].name==null?
                      SizedBox.shrink():
                      CustomText(text: cubit.courseDetailsModel!.data!.attachments![index].name!),
                    ),
                  ),
                ),
                separatorBuilder: (context, index) =>
                    SizedBox(height: height(context) * 0.02),
                itemCount: cubit.courseDetailsModel!.data!.attachments!.length),
          );
        });
  }
}