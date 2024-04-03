import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_button.dart';
import 'package:private_courses/components/custom_loading.dart';
import '../../../../components/custom_appBar.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/custom_toast.dart';
import '../../../../components/my_navigate.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../generated/locale_keys.g.dart';
import '../components/about_teacher.dart';
import '../controller/product_details_cubit.dart';
import '../controller/product_details_states.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int? id;
  final bool fromTeacherProfile;
  final ValueChanged<String?> valueChanged;

  const ProductDetailsScreen(
      {required this.id,
      required this.fromTeacherProfile,
      required this.valueChanged});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: widget.fromTeacherProfile == true ? 1 : 2, vsync: this);
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
        create: (context) => ProductDetailsCubit()..fetchCourseDetails(context: context, id: widget.id),
        child: BlocConsumer<ProductDetailsCubit, ProductDetailsStates>(
            listener: ((context, state) {
          if (state is AddToCartSuccessState) {
            showSnackBar(context: context, success: true, text: state.msg);
          } else if (state is AddToCartFailedState) {
            showSnackBar(context: context, success: false, text: state.msg);
          }
        }), builder: (context, state) {
          final cubit = ProductDetailsCubit.get(context);
          return WillPopScope(
            onWillPop: () async {
              widget.valueChanged.call("");
              return true;
            },
            child: SafeArea(
              child: Scaffold(
                  body: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width(context) * 0.04),
                      child: state is LoadingState
                          ? const CustomLoading(load: true)
                          : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              CustomAppBar(
                                isNotify: false,
                                textAppBar: LocaleKeys.ProductDetails.tr(),
                                onTapBack: () {
                                  widget.valueChanged.call('');
                                  navigatorPop(context);
                                },
                              ),
                              Expanded(child: SingleChildScrollView(
                               physics: BouncingScrollPhysics(),
                               child: Column(
                                 children: [
                                   Stack(children: [
                                     Container(
                                       width: width(context) * 0.9,
                                       height: height(context) * 0.22,
                                       decoration: BoxDecoration(
                                           borderRadius: BorderRadius.circular(10),
                                           image: DecorationImage(
                                             image: NetworkImage(cubit.courseDetailsModel!.data!.photo!),
                                           )),
                                     ),
                                     Positioned(
                                         top: width(context) * 0.012,
                                         left: width(context) * 0.012,
                                         child: GestureDetector(
                                           onTap: () {
                                             cubit.saveCourse(
                                                 context: context,
                                                 id: cubit.courseDetailsModel!.data!.id!);
                                           },
                                           child: cubit.courseDetailsModel!.data!
                                               .isFavorite!
                                               ? Image.asset(
                                             AppImages.mark,
                                             width: width(context) * 0.1,
                                           )
                                               : Image.asset(
                                             AppImages.unMark,
                                             width: width(context) * 0.1,
                                           ),
                                         )),
                                   ]),
                                   SizedBox(height: height(context) * 0.025),
                                   Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [
                                       SizedBox(
                                         width: width(context) * 0.4,
                                         child: CustomText(
                                             text: cubit.courseDetailsModel!.data!.name!,
                                             color: AppColors.navyBlue,
                                             fontSize: AppFonts.t5,
                                             fontWeight: FontWeight.bold),
                                       ),
                                       const Spacer(),
                                       Container(
                                         padding: EdgeInsets.symmetric(
                                             horizontal: width(context) * 0.035,
                                             vertical: height(context) * 0.004),
                                         decoration: BoxDecoration(
                                           color: AppColors.redOpcityColor,
                                           borderRadius: BorderRadius.circular(18),
                                         ),
                                         child: Center(
                                           child: CustomText(
                                               text:
                                               "${cubit.courseDetailsModel!.data!.price} ${LocaleKeys.SaudiRiyal.tr()}",
                                               color: AppColors.whiteColor,
                                               fontSize: AppFonts.t9),
                                         ),
                                       ),
                                     ],
                                   ),
                                   SizedBox(height: height(context)*0.005),
                                   Row(
                                     children: [
                                       cubit.courseDetailsModel!.data!.isInstallment==true?
                                       Image.asset(AppImages.tabbyIcon,width: width(context)*0.13,) : SizedBox.shrink(),
                                       Spacer(),
                                       state is AddToCartLoadingState
                                           ? const CustomLoading(load: false)
                                           : SizedBox(
                                         width: width(context)*0.33,
                                         height: height(context)*0.05,
                                         child: CustomButton(
                                           colored: true,
                                           fontSize: AppFonts.t10,
                                           onPressed: () {
                                             cubit.addToCart(
                                                 context: context,
                                                 id: cubit.courseDetailsModel!.data!.id);
                                           },
                                           text: LocaleKeys.AddToCart.tr(),
                                         ),
                                       ),
                                     ],
                                   ),
                                   SizedBox(height: height(context) * 0.026),
                                   SizedBox(
                                     height: height(context) * 0.06,
                                     child: TabBar(
                                         controller: tabController,
                                         indicatorColor: AppColors.navyBlue,
                                         indicatorSize: TabBarIndicatorSize.tab,
                                         unselectedLabelColor: AppColors.greyTextColor,
                                         unselectedLabelStyle:
                                         TextStyle(fontSize: AppFonts.t9),
                                         labelColor: AppColors.navyBlue,
                                         labelStyle: TextStyle(fontSize: AppFonts.t9),
                                         tabs: widget.fromTeacherProfile == true
                                             ? [
                                           Tab(
                                               text: LocaleKeys.AboutTheCourse
                                                   .tr()),
                                         ]
                                             : [
                                           Tab(
                                               text: LocaleKeys.AboutTheCourse
                                                   .tr()),
                                           Tab(
                                               text:
                                               LocaleKeys.AboutTeacher.tr()),
                                         ]),
                                   ),
                                   SizedBox(
                                     height: height(context)*0.35,
                                     child: TabBarView(
                                         controller: tabController,
                                         physics: const BouncingScrollPhysics(),
                                         children: widget.fromTeacherProfile == true
                                             ? [
                                           ListView(
                                             physics: const BouncingScrollPhysics(),
                                             padding: EdgeInsets.symmetric(horizontal: width(context)*0.01,vertical: height(context)*0.02),
                                             children: [
                                               CustomText(
                                                   text: cubit.courseDetailsModel!.data!.details!,
                                                   color: AppColors.greyBoldColor,
                                                   fontSize: AppFonts.t9)
                                             ],
                                           ),
                                         ]
                                             : [
                                           ListView(
                                             physics: const BouncingScrollPhysics(),
                                             padding: EdgeInsets.symmetric(horizontal: width(context)*0.01,vertical: height(context)*0.02),
                                             children: [
                                               CustomText(
                                                   text: cubit.courseDetailsModel!.data!.details!,
                                                   color: AppColors.greyBoldColor,
                                                   fontSize: AppFonts.t9)
                                             ],
                                           ),
                                           AboutTeacher(cubit: cubit),
                                         ]),
                                   ),
                                 ],
                               ),
                             )),
                            ]))),
            ),
          );
        }));
  }
}
