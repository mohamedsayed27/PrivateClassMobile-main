import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_appBar.dart';
import 'package:private_courses/screens/student/courses/components/current_courses.dart';
import 'package:private_courses/screens/student/courses/components/finished_courses.dart';
import 'package:private_courses/screens/student/orders/components/finished_orders.dart';
import 'package:private_courses/screens/student/orders/controller/orders_cubit.dart';

import '../../../../components/custom_text.dart';
import '../../../../components/my_navigate.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../common/notification/view/notification_view.dart';
import '../components/current_orders.dart';
import '../controller/orders_state.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ((context) => OrdersCubit()),
      child: BlocBuilder<OrdersCubit, OrdersState>(builder: ((context, state) {
        final cubit = OrdersCubit.get(context);
        return SafeArea(
          child: Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: width(context) * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAppBar(
                    isNotify: true,
                    textAppBar: LocaleKeys.Orders.tr(),
                  ),
                  SizedBox(height: height(context) * 0.02),
                  Row(
                    children: List.generate(
                      cubit.courses.length,
                      (index) => Expanded(
                        child: GestureDetector(
                          onTap: () {
                            cubit.changeCourses(index);
                          },
                          child: Container(
                            height: height(context) * 0.07,
                            padding: EdgeInsets.symmetric(
                                horizontal: width(context) * 0.01,
                                vertical: height(context) * 0.007),
                            margin: EdgeInsetsDirectional.only(
                                end: width(context) * 0.02),
                            decoration: cubit.selectedIndex == index
                                ? BoxDecoration(
                                    image: const DecorationImage(
                                        image: AssetImage(AppImages.backSaves),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(25),
                                  )
                                : BoxDecoration(
                                    color: AppColors.greyWhite,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                            child: Center(
                              child: CustomText(
                                text: cubit.courses[index],
                                color: cubit.selectedIndex == index
                                    ? AppColors.whiteColor
                                    : AppColors.greyTextColor,
                                fontSize: AppFonts.t8,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height(context) * 0.03),
                  cubit.selectedIndex == 0
                      ? const CurrentOrders()
                      : const FinishedOrders()
                ],
              ),
            ),
          ),
        );
      })),
    );
  }
}
