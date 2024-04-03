import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/style/images.dart';
import 'package:private_courses/screens/student/orders/model/orders_model.dart';

import '../../../../generated/locale_keys.g.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(OrdersInitial());

  static OrdersCubit get(context) => BlocProvider.of(context);

  List<String> courses = [
    LocaleKeys.CurrentOrders.tr(),
    LocaleKeys.FinishedOrders.tr()
  ];
  List<OrdersModel> currentOrders = [
    OrdersModel(
        name: "Course 1",
        image: AppImages.physics,
        orderDate: "22 فبراير 2023",
        orderNo: "#345xyi6",
        orderPrice: "250"),
    OrdersModel(
        name: "Course 2",
        image: AppImages.physics,
        orderDate: "28 فبراير 2023",
        orderNo: "#545jki6",
        orderPrice: "350"),
  ];

  List<OrdersModel> finishedOrders = [
    OrdersModel(
        name: "Course 3",
        image: AppImages.physics,
        orderDate: "22 فبراير 2023",
        orderNo: "#552kug",
        orderPrice: "440"),
    OrdersModel(
        name: "Course 4",
        image: AppImages.physics,
        orderDate: "28 فبراير 2023",
        orderNo: "#351fsy",
        orderPrice: "500"),
    OrdersModel(
        name: "Course 5",
        image: AppImages.physics,
        orderDate: "28 فبراير 2023",
        orderNo: "#351fsy",
        orderPrice: "520"),
  ];

  int selectedIndex = 0;

  void changeCourses(int index) {
    selectedIndex = index;
    emit(ChangeOrders());
  }
}
