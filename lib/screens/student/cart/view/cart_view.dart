import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_loading.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/screens/common/drawer/components/custom_zoom_drawer.dart';
import 'package:private_courses/screens/student/cart/components/no_product.dart';
import 'package:private_courses/screens/student/payment_types/view/payment_types_view.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import '../../../../components/custom_appBar.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/custom_textfield.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../generated/locale_keys.g.dart';
import '../components/cart_item.dart';
import '../components/custom_cart_row.dart';
import '../controller/cart_cubit.dart';
import '../controller/cart_states.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
        CartCubit()..getCart(context: context, isLoading: true),
        child: BlocBuilder<CartCubit, CartStates>(builder: (context, state) {
          final cubit = CartCubit.get(context);
          return SafeArea(
            child: Scaffold(
                body: Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: width(context) * 0.04),
                    child: Column(children: [
                      CustomAppBar(
                        isNotify: true,
                        textAppBar: LocaleKeys.ShoppingCart.tr()),
                      state is GetCartLoadingState
                          ? const CustomLoading(load: true)
                          : cubit.cartModel!.data == null
                          ? const NoProduct()
                          : Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              SizedBox(height: height(context) * 0.015),
                              ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) =>
                                      CartItem(
                                        onTapFav: () async {
                                          await cubit.saveCart(
                                              context: context,
                                              index: index,
                                              id: cubit
                                                  .cartModel!
                                                  .data!
                                                  .items![index]
                                                  .id!);
                                        },
                                        courseName: cubit.cartModel!
                                            .data!.items![index].name!,
                                        courseImage: cubit.cartModel!
                                            .data!.items![index].photo!,
                                        courseDetails: cubit
                                            .cartModel!
                                            .data!
                                            .items![index]
                                            .details!,
                                        coursePrice: cubit.cartModel!
                                            .data!.items![index].price!,
                                        isFavorite: cubit
                                            .cartModel!
                                            .data!
                                            .items![index]
                                            .isFavorite!,
                                        onTapDelete: () {
                                          cubit.deleteItem(
                                              context: context,
                                              itemId: cubit
                                                  .cartModel!
                                                  .data!
                                                  .items![index]
                                                  .cartId);
                                        },
                                      ),
                                  separatorBuilder:
                                      (context, index) => SizedBox(
                                      height: height(context) *
                                          0.008),
                                  itemCount: cubit
                                      .cartModel!.data!.items!.length),
                              SizedBox(
                                  height: height(context) * 0.015),
                              Align(
                                  alignment:
                                  AlignmentDirectional.topStart,
                                  child: CustomText(
                                      text: LocaleKeys.OrderSummary
                                          .tr(),
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                  height: height(context) * 0.01),
                              CustomCartRow(
                                  text1: LocaleKeys.NumberOfPurchases
                                      .tr(),
                                  text2: cubit
                                      .cartModel!.data!.numOfPurchases
                                      .toString()),
                              CustomCartRow(
                                  text1: LocaleKeys
                                      .TotalBeforeDiscount.tr(),
                                  text2:
                                  "${cubit.cartModel!.data!.totalSub} ${LocaleKeys.Rs.tr()}"),
                              CustomCartRow(
                                  text1: LocaleKeys.Discount.tr(),
                                  text2: cubit.checkCouponModel ==
                                      null
                                      ? "0"
                                      : "${cubit.checkCouponModel?.data.percent} %"),
                              SizedBox(
                                  height: height(context) * 0.01),
                              Row(
                                children: [
                                  Expanded(
                                      child: CustomTextFormField(
                                          hint:
                                          LocaleKeys.Coupon.tr(),
                                          ctrl:
                                          cubit.couponController,
                                          type: TextInputType.text,
                                          contentPadding:
                                          EdgeInsets.symmetric(
                                              horizontal:
                                              width(context) *
                                                  0.05,
                                              vertical:
                                              width(context) *
                                                  0.01))),
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
                                            coupon: cubit
                                                .couponController
                                                .text)
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
                              SizedBox(
                                  height: height(context) * 0.02),
                              CustomCartRow(
                                text1: LocaleKeys.Total.tr(),
                                text2: cubit.checkCouponModel == null
                                    ? "${cubit.cartModel!.data!.totalSub} ${LocaleKeys.Rs.tr()}"
                                    : "${cubit.checkCouponModel?.data.total} ${LocaleKeys.Rs.tr()}",
                                col: AppColors.blackColor,
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(
                                  height: height(context) * 0.02),
                              CustomButton(
                                  text: LocaleKeys.PayNow.tr(),
                                  colored: true,
                                  onPressed: () {
                                    CacheHelper.saveData(AppCached.amountCart, cubit.checkCouponModel == null ?
                                    cubit.cartModel!.data!.totalSub : cubit.checkCouponModel!.data.total);
                                    navigateTo(
                                        context,
                                        CustomZoomDrawer(
                                            mainScreen: PaymentTypesScreen(
                                              paymentKey: cubit.cartModel!.data!.paymentKey!,
                                              isInstallment: cubit.cartModel!.data!.isInstallment!,
                                              isBankPayment: cubit.cartModel!.data!.isBankPayment!,
                                              amount: cubit.checkCouponModel == null
                                                ? double.parse(cubit.cartModel!.data!.totalSub!).round()
                                                : cubit.checkCouponModel!.data.total.toDouble().round(),),
                                            isTeacher: CacheHelper.getData(key: AppCached.role)));


                                    // navigateTo(context, CustomZoomDrawer(mainScreen: PaymentCartScreen(
                                    //   paymentKey: cubit.cartModel!.data!.paymentKey!,
                                    //     cartPrice:cubit.checkCouponModel == null
                                    //     ? double.parse(cubit.cartModel!.data!.totalSub!).round()
                                    //     : cubit.checkCouponModel!.data.total.toDouble().round() ), isTeacher: CacheHelper.getData(key: AppCached.role)));
                                  }),
                              SizedBox(
                                  height: height(context) * 0.02),
                            ],
                          ),
                        ),
                      ),
                    ]))),
          );
        }));
  }
}