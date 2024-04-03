import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:private_courses/components/style/colors.dart';
import 'package:private_courses/components/style/size.dart';

class CustomLoading extends StatelessWidget {
  final bool load;

  const CustomLoading({Key? key, required this.load}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return load == true
        ? SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
          child: Column(
              children: [
                SizedBox(
                  height: height(context) * 0.25
                ),
                Center(
                    child: SpinKitPouringHourGlassRefined(
                        color: AppColors.mainColor, size: width(context) * 0.15)),
              ],
            ),
        )
        : Center(
            child: SpinKitThreeBounce(
              size: width(context) * 0.1,
              color: AppColors.mainColor,
            ),
          );
  }
}
