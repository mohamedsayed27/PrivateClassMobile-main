import 'package:flutter/material.dart';
import 'package:private_courses/screens/teacher/edit_group/view/edit_groups_view.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/my_navigate.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../core/local/app_cached.dart';
import '../../../../shared/local/cache_helper.dart';
import '../../../common/drawer/components/custom_zoom_drawer.dart';

class GroupsItem extends StatelessWidget {
  GroupsItem({
    Key? key,
    required this.groupName,
    required this.groupDate,
    required this.groupDetails,
    required this.groupId,
    required this.from,
    required this.groupLink,
    required this.onTap,
    required this.canEdit,
    this.editTap,
  });
  final int groupId;
  final String groupName;
  final String groupDetails;
  final String groupDate;
  final String groupLink;
  final bool canEdit;
  final  void Function()? onTap;
  final  void Function()? editTap;
  final String from;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
                padding: EdgeInsetsDirectional.only(
                    top: width(context) * 0.032,
                    bottom: width(context) * 0.028,
                    start: width(context) * 0.04,
                    end: width(context) * 0.05),
                decoration: BoxDecoration(
                    color: AppColors.lightBlueColor.withOpacity(.04),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: groupName,
                      fontSize: AppFonts.t15,
                      color: AppColors.navyBlue,
                    ),
                    CustomText(
                      text: groupDetails,
                      color: AppColors.greyBoldColor,
                      fontSize: AppFonts.t10,
                    ),
                    SizedBox(height: height(context) * 0.01),
                    Row(
                      children: [
                        Image.asset(
                          AppImages.dateBirth,
                          width: width(context) * 0.065,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width(context) * 0.02),
                          child: CustomText(
                            text: groupDate,
                            color: AppColors.navyBlue,
                            fontSize: AppFonts.t9,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height(context) * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              AppImages.clock,
                              width: width(context) * 0.065,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width(context) * 0.02),
                              child: CustomText(
                                text: from,
                                color: AppColors.navyBlue,
                                fontSize: AppFonts.t9,
                              ),
                            ),
                          ],
                        ),
                        canEdit==true?
                        GestureDetector(
                          onTap: () {
                            navigateTo(
                                context,
                                CustomZoomDrawer(
                                    mainScreen: EditGroupsScreen(
                                      groupId: groupId,
                                    ),
                                    isTeacher: CacheHelper.getData(
                                      key: AppCached.role,
                                    )));
                          },
                          child: Image.asset(
                            AppImages.blueEditing,
                            width: width(context) * 0.09,
                          ),
                        ) :
                        SizedBox(),
                      ],
                    ),
                  ],
                )),
          ),
        ),
      ],
    );
  }
}
