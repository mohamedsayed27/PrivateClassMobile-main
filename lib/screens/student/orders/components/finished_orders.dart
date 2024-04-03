import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/generated/locale_keys.g.dart';
import 'package:private_courses/screens/student/orders/controller/orders_cubit.dart';
import 'package:private_courses/screens/student/orders/controller/orders_state.dart';

import '../../../../components/empty_list.dart';
import '../../../../components/style/size.dart';
import 'orders_widget.dart';

class FinishedOrders extends StatelessWidget {
  const FinishedOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersCubit, OrdersState>(
        builder: (context, state) {
          final cubit = OrdersCubit.get(context);
          return Expanded(
            child: cubit.finishedOrders.isEmpty == true
                ? const EmptyList()
                : ListView.separated(
                    padding: EdgeInsetsDirectional.only(
                        start: width(context) * 0.005,
                        top: height(context) * 0.01),
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => OrdersWidget(
                        onTap: () {},
                        buttonText: LocaleKeys.DownloadCourse.tr(),
                        courseImg: cubit.finishedOrders[index].image,
                        orderNo: cubit.finishedOrders[index].orderNo,
                        orderPrice: cubit.finishedOrders[index].orderPrice,
                        orderDate: cubit.finishedOrders[index].orderDate,
                        courseName: cubit.finishedOrders[index].name),
                    separatorBuilder: (context, index) =>
                        SizedBox(height: height(context) * 0.025),
                    itemCount: cubit.finishedOrders.length),
          );
        },
        listener: (context, state) {});
  }
}
