import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:private_courses/components/style/colors.dart';
import 'package:private_courses/generated/locale_keys.g.dart';

Future<void> showSnackBar(
    {required BuildContext context,
      required String text,
      required bool success}) async {
 await ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(duration: const Duration(seconds: 2),
    content: Text(text),
    dismissDirection: DismissDirection.endToStart,
    backgroundColor: success==true ? AppColors.mainColor : Colors.red,
    action: SnackBarAction(
        textColor: Colors.white,
        label: LocaleKeys.Ok.tr(),
        onPressed: ()async{
           ScaffoldMessenger.of(context).removeCurrentSnackBar();
        }),
    behavior: SnackBarBehavior.floating,
  ));
}