import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_button.dart';
import 'package:private_courses/components/custom_textfield.dart';
import 'package:private_courses/components/custom_toast.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/screens/common/drawer/components/custom_zoom_drawer.dart';
import 'package:private_courses/screens/student/course_details/components/attachments.dart';
import 'package:private_courses/screens/student/course_details/components/subscribe_sccess.dart';
import 'package:private_courses/screens/student/course_details/components/un_subscribe.dart';
import 'package:private_courses/screens/student/payCourse/view/payment_types_course_view.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import '../../../../components/custom_appBar.dart';
import '../../../../components/custom_loading.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../generated/locale_keys.g.dart';
import '../components/about_course.dart';
import '../components/about_the_lecturer.dart';
import '../components/course_content.dart';
import '../controller/course_details_cubit.dart';
import '../controller/course_details_states.dart';

class CourseDetailsScreen extends StatefulWidget {
  final bool fromTeacherProfile;
  final int courseId;
  final String courseName;
  final ValueChanged<String?> valueChanged;
  const CourseDetailsScreen({
    required this.fromTeacherProfile,
    required this.courseId,
    required this.valueChanged,
    required this.courseName});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(
        length: widget.fromTeacherProfile == true ? 2 : 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CourseDetailsCubit()..getCourseDetails(context: context, id: widget.courseId),
      child: BlocConsumer<CourseDetailsCubit, CourseDetailsStates>(
          listener: (context, state) {
            if (state is SubscribeCourseSuccessState) {
              showDialog(
                  context: context,
                  builder: (builder) =>
                      SubscribeSuccess(courseName: widget.courseName));
            } else if (state is SubscribeCourseErrorState) {
              showSnackBar(context: context, text: state.msg, success: false);
            }
          }, builder: (context, state) {
        final cubit = CourseDetailsCubit.get(context);
        return WillPopScope(
          onWillPop: ()async{
            widget.valueChanged.call('');
            return true;
          },
          child: Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: width(context) * 0.04),
              child: Column(
                children: [
                  CustomAppBar(
                      isNotify: false, textAppBar: LocaleKeys.CourseDetails.tr(),
                      onTapBack: (){
                        widget.valueChanged.call('');
                        navigatorPop(context);
                      }),
                  Expanded(
                    child: state is CourseDetailsLoadingState
                        ? const CustomLoading(load: true)
                        : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                SizedBox(
                                  height: height(context) * 0.22,
                                  width: double.infinity,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                        cubit.courseDetailsModel!.data!.photo!),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.only(
                                    top: height(context) * 0.008,
                                    bottom: height(context) * 0.008,
                                    start: width(context) * 0.01,
                                    end: width(context) * 0.01,
                                  ),
                                  child: GestureDetector(
                                      onTap: () {
                                        cubit.saveCourse(
                                            context: context,
                                            id: cubit.courseDetailsModel!
                                                .data!.id!);
                                      },
                                      child: Image.asset(
                                          cubit.courseDetailsModel!.data!
                                              .isFavorite!
                                              ? AppImages.mark
                                              : AppImages.unMark,
                                          scale: 2)),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: height(context) * 0.01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: width(context)*0.4,
                                child: CustomText(
                                    text: cubit.courseDetailsModel!.data!.name!,
                                    color: AppColors.navyBlue,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    fontSize: AppFonts.t6),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width(context) * 0.035,
                                    vertical: height(context) * 0.005),
                                decoration: BoxDecoration(
                                  color: AppColors.redOpcityColor,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Center(
                                  child: CustomText(
                                      text: cubit.checkCouponModel!=null?
                                      "${cubit.checkCouponModel!.data.total!} ${LocaleKeys.SaudiRiyal.tr()}":
                                      "${cubit.courseDetailsModel!.data!.price!} ${LocaleKeys.SaudiRiyal.tr()}",
                                      color: AppColors.whiteColor,
                                      fontSize: AppFonts.t9),
                                ),
                              ),
                            ],
                          ),
                          cubit.courseDetailsModel!.data!.isInstallment==true?
                          Image.asset(AppImages.tabbyIcon,width: width(context)*0.13,) : SizedBox.shrink(),
                          SizedBox(height: height(context) * 0.01),
                          cubit.courseDetailsModel!.data!.isSubscribed == false?
                          SizedBox(
                            height: height(context)*0.05,
                            child: Row(
                              children: [
                                Expanded(
                                    child: CustomTextFormField(
                                        hint: LocaleKeys.Coupon.tr(),
                                        ctrl: cubit.couponController,
                                        type: TextInputType.text,
                                        contentPadding:
                                        EdgeInsets.symmetric(
                                            horizontal: width(context) * 0.05,
                                            vertical: width(context) * 0.01))),
                                SizedBox(
                                    width: width(context) * 0.04),
                                state is CheckCouponLoadingState
                                    ? const CustomLoading(
                                    load: false)
                                    : GestureDetector(
                                    onTap: () {
                                      cubit
                                          .checkCoupon(
                                          context: context,
                                          coupon: cubit.couponController.text,
                                      id: cubit.courseDetailsModel!.data!.id!.toString()
                                      )
                                          .then((value) {
                                        cubit.couponController
                                            .clear();
                                      });
                                      // cubit.discount = cubit.checkCouponModel!.data.percent;
                                      // cubit.getCart(context: context, isLoading: false);
                                    },
                                    child: Container(
                                      padding: EdgeInsets
                                          .symmetric(
                                          horizontal: width(
                                              context) *
                                              0.09,
                                          vertical: width(
                                              context) *
                                              0.025),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius
                                              .circular(30),
                                          image:
                                          const DecorationImage(
                                              image:
                                              AssetImage(
                                                AppImages
                                                    .backSaves,
                                              ),
                                              fit: BoxFit
                                                  .fill)),
                                      child: CustomText(
                                          text: LocaleKeys.Apply
                                              .tr(),
                                          color: AppColors
                                              .whiteColor,
                                          fontWeight:
                                          FontWeight.bold),
                                    )),
                              ],
                            ),
                          ) : SizedBox.shrink(),
                          SizedBox(height: height(context) * 0.01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width : width(context)*0.5,
                                child: CustomText(
                                    text: cubit.courseDetailsModel!.data!.teacher!.name!,
                                    color: AppColors.goldColor,
                                    fontSize: AppFonts.t7),
                              ),
                              cubit.courseDetailsModel!.data!.isSubscribed == true && cubit.courseDetailsModel!.data!.canUnsubscribe==false
                                  ? SizedBox.shrink()
                                  : SizedBox(
                                width: width(context)*0.3,
                                height: height(context)*0.05,
                                child: CustomButton(
                                    colored: true,
                                    onPressed: () async {
                                      print(cubit.courseDetailsModel!.data!.paymentKey!);
                                      if(cubit.courseDetailsModel!.data!.isSubscribed == true && cubit.courseDetailsModel!.data!.canUnsubscribe==true){
                                        showDialog(context: context, builder: (context)=>UnSubscribeDialog(id: cubit.courseDetailsModel!.data!.id!));
                                      }else{
                                        debugPrint(double.parse(cubit.courseDetailsModel!.data!.price!).round().toString());
                                        debugPrint(cubit.courseDetailsModel!.data!.price!);
                                        CacheHelper.saveData(AppCached.amountCart,
                                            cubit.checkCouponModel==null?
                                            cubit.courseDetailsModel!.data!.price! :
                                        cubit.checkCouponModel!.data.total
                                        );
                                        navigateTo(
                                            context,
                                            CustomZoomDrawer(
                                                mainScreen: PaymentTypesCourseScreen(
                                                    isBankPayment: cubit.courseDetailsModel!.data!.isBankPayment!,
                                                    id: cubit.courseDetailsModel!.data!.id!,
                                                    courseName: cubit.courseDetailsModel!.data!.name!,
                                                    isInstallment: cubit.courseDetailsModel!.data!.isInstallment!,
                                                    paymentKey: cubit.courseDetailsModel!.data!.paymentKey!,
                                                    amount:
                                                    cubit.checkCouponModel!=null?
                                                    double.parse(cubit.checkCouponModel!.data.total!).round():
                                                    double.parse(cubit.courseDetailsModel!.data!.price!).round()),
                                                isTeacher: CacheHelper.getData(key: AppCached.role)));
                                      }
                                      // SubscribeCourseScreen(
                                      //     isCart: false,
                                      //     courseId: cubit
                                      //         .courseDetailsModel!
                                      //         .data!
                                      //         .id!,
                                      //     nameCourse: cubit
                                      //         .courseDetailsModel!
                                      //         .data!
                                      //         .name!),
                                      // navigateTo(context, CustomZoomDrawer(
                                      //     mainScreen:PaymentCourseScreen(
                                      //       paymentKey: cubit.courseDetailsModel!.data!.paymentKey!,
                                      //       coursePrice: double.parse(cubit.courseDetailsModel!.data!.price!).round(),
                                      //       courseName: cubit.courseDetailsModel!.data!.name!,
                                      //       id: cubit.courseDetailsModel!.data!.id!,
                                      //     ),
                                      //     isTeacher: CacheHelper.getData(key: AppCached.role)));
                                    },
                                    text:
                                    cubit.courseDetailsModel!.data!.isSubscribed == true && cubit.courseDetailsModel!.data!.canUnsubscribe==true?
                                    LocaleKeys.UnSubscribe.tr():
                                    LocaleKeys.SubscribeNow.tr(),
                                fontSize: AppFonts.t15,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: height(context) * 0.02),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Image.asset(AppImages.profiles,
                                        width: width(context) * 0.06),
                                    SizedBox(
                                        height: height(context) * 0.01),
                                    CustomText(
                                        text:
                                        "${cubit.courseDetailsModel!.data!.numSubscribe!} ${LocaleKeys.Subscriber.tr()}",
                                        color: AppColors.greyTextColor,
                                        fontSize: AppFonts.t11),
                                  ],
                                ),
                              ),
                              SizedBox(width: width(context) * 0.01),
                              Image.asset(AppImages.lineHeight,
                                  width: width(context) * 0.003,
                                  height: height(context) * 0.07),
                              SizedBox(width: width(context) * 0.01),
                              Expanded(
                                child: Column(
                                  children: [
                                    Image.asset(AppImages.videosCircle,
                                        width: width(context) * 0.059),
                                    SizedBox(
                                        height: height(context) * 0.01),
                                    CustomText(
                                        text:
                                        "${cubit.courseDetailsModel!.data!.numVideos!} ${LocaleKeys.Lecture.tr()}",
                                        color: AppColors.greyTextColor,
                                        fontSize: AppFonts.t11),
                                  ],
                                ),
                              ),
                              SizedBox(width: width(context) * 0.01),
                              Image.asset(AppImages.lineHeight,
                                  width: width(context) * 0.003,
                                  height: height(context) * 0.07),
                              SizedBox(width: width(context) * 0.01),
                              Expanded(
                                child: Column(
                                  children: [
                                    Image.asset(AppImages.clock,
                                        width: width(context) * 0.058),
                                    SizedBox(
                                        height: height(context) * 0.01),
                                    CustomText(
                                        text:
                                        "${cubit.courseDetailsModel!.data!.numHours!}",
                                        color: AppColors.greyTextColor,
                                        fontSize: AppFonts.t11),
                                  ],
                                ),
                              ),
                              // SizedBox(width: width(context) * 0.01),
                              // Image.asset(AppImages.lineHeight,
                              //     width: width(context) * 0.003,
                              //     height: height(context) * 0.07),
                              // SizedBox(width: width(context) * 0.01),
                              // Expanded(
                              //   child: Column(
                              //     children: [
                              //       Image.asset(AppImages.note,
                              //           width: width(context) * 0.06),
                              //       SizedBox(height: height(context) * 0.01),
                              //       CustomText(
                              //           text: "12 ${LocaleKeys.Duties.tr()}",
                              //           color: AppColors.greyTextColor,
                              //           fontSize: AppFonts.t11),
                              //     ],
                              //   ),
                              // ),
                              // SizedBox(width: width(context) * 0.01),
                              // Image.asset(AppImages.lineHeight,
                              //     width: width(context) * 0.003,
                              //     height: height(context) * 0.07),
                              // SizedBox(width: width(context) * 0.01),
                              // Expanded(
                              //   child: Column(
                              //     children: [
                              //       Image.asset(AppImages.award,
                              //           width: width(context) * 0.06),
                              //       SizedBox(height: height(context) * 0.01),
                              //       CustomText(
                              //           text: LocaleKeys.Certification.tr(),
                              //           color: AppColors.greyTextColor,
                              //           fontSize: AppFonts.t11),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                          SizedBox(height: height(context) * 0.006),
                          Image.asset(AppImages.lineWidth),
                          SizedBox(height: height(context) * 0.02),
                          SizedBox(
                            height: height(context) * 0.05,
                            child: TabBar(
                                controller: tabController,
                                indicatorColor: AppColors.navyBlue,
                                indicatorSize: TabBarIndicatorSize.tab,
                                isScrollable: true,
                                unselectedLabelColor:
                                AppColors.greyTextColor,
                                unselectedLabelStyle:
                                TextStyle(fontSize: AppFonts.t9),
                                labelColor: AppColors.navyBlue,
                                labelStyle:
                                TextStyle(fontSize: AppFonts.t9),
                                tabs: widget.fromTeacherProfile == true
                                    ? [
                                  Tab(
                                      text: LocaleKeys.AboutTheCourse
                                          .tr()),
                                  Tab(
                                      text: LocaleKeys.CourseContent
                                          .tr())
                                ]
                                    : [
                                  Tab(
                                      text: LocaleKeys.AboutTheCourse
                                          .tr()),
                                  Tab(
                                      text: LocaleKeys.CourseContent
                                          .tr()),
                                  Tab(
                                      text: LocaleKeys
                                          .AboutTheLecturer.tr()),
                                  Tab(
                                      text: LocaleKeys.Attaches.tr())
                                ]),
                          ),
                          SizedBox(
                            height: height(context) * 0.4,
                            child: TabBarView(
                                controller: tabController,
                                physics: const BouncingScrollPhysics(),
                                children: widget.fromTeacherProfile == true
                                    ? const [
                                  AboutCourse(),
                                  CourseContent()
                                ] : const [
                                  AboutCourse(),
                                  CourseContent(),
                                  AboutTheLecturer(),
                                  AttachmentsTeacher()
                                ]),
                          ),
                          SizedBox(height: height(context) * 0.02),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}