import 'package:flutter/material.dart';

/// Navigator Push

void navigateTo(context, widget) => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
);
/// Navigator Finish
void navigateAndFinish({required context,required widget}) => Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
        (Route<dynamic> route) => false);


/// Navigator Pop

 navigatorPop(context)=> Navigator.pop(context);

/// Navigator And Replace
navigateAndReplace({required context,required widget}) => Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),);