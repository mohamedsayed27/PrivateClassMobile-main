import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/style/size.dart';
import 'package:private_courses/generated/locale_keys.g.dart';
import 'package:private_courses/screens/student/orders/components/orders_widget.dart';
import 'package:private_courses/screens/student/orders/controller/orders_cubit.dart';
import 'package:private_courses/screens/student/orders/controller/orders_state.dart';
import '../../../../components/empty_list.dart';

class CurrentOrders extends StatelessWidget {
  const CurrentOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersCubit, OrdersState>(
        builder: (context, state) {
          final cubit = OrdersCubit.get(context);
          return Expanded(
            child: cubit.currentOrders.isEmpty == true
                ? const EmptyList()
                : ListView.separated(
                    padding: EdgeInsetsDirectional.only(
                        start: width(context) * 0.005,
                        top: height(context) * 0.01),
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => OrdersWidget(
                        onTap: () {},
                        buttonText: LocaleKeys.Details.tr(),
                        courseImg: cubit.currentOrders[index].image,
                        orderNo: cubit.currentOrders[index].orderNo,
                        orderPrice: cubit.currentOrders[index].orderPrice,
                        orderDate: cubit.currentOrders[index].orderDate,
                        courseName: cubit.currentOrders[index].name),
                    separatorBuilder: (context, index) =>
                        SizedBox(height: height(context) * 0.025),
                    itemCount: cubit.currentOrders.length),
          );
        },
        listener: (context, state) {});
  }
}
