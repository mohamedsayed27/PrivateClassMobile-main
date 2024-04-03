import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:private_courses/components/style/colors.dart';
import 'package:private_courses/components/style/size.dart';

 showToast({
  required String text,
  required ToastStates state,
}) => Fluttertoast.showToast(
  msg: text,
  toastLength: Toast.LENGTH_LONG,
  gravity: ToastGravity.BOTTOM,
  timeInSecForIosWeb: 5,
  backgroundColor: choseToastColor(state),
  textColor: Colors.white
);

// enum
enum ToastStates {success , error}

Color? choseToastColor(ToastStates state)
{
  Color color;
  switch(state)
  {
    case ToastStates.success:
      color = AppColors.mainColor;
      break;
    case ToastStates.error:
      color =  Colors.red;
      break;
  }
  return color;
}