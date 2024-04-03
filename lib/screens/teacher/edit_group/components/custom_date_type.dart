import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../components/custom_textfield.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../controller/edit_groups_cubit.dart';
import '../controller/edit_groups_state.dart';
class CustomDateType extends StatelessWidget {
   CustomDateType({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditGroupsCubit, EditGroupsStates>(
        listener: (context,state){},
      builder: (context,state){
    final cubit = EditGroupsCubit.get(context);
     return CustomTextFormField(
         maxLines: 1,
        isOnlyRead: true,
        contentPadding: EdgeInsets.symmetric(horizontal: width(context)*0.05, vertical:width(context)*0.02, ),
        ontap: () async{
          DateTime? pickedDate = await showDatePicker(
            builder: (context, child){
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: AppColors.mainColor,
                    onPrimary: AppColors.whiteColor,
                    onSurface: AppColors.navyBlue,
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.goldColor,
                    ),
                  ),
                ),
                child: child!,
              );
            },
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1950),
              lastDate: DateTime(2050));
          if (pickedDate != null) {
            cubit.dateInputController.text =DateFormat.yMMMMd(
                context.locale.languageCode=="ar"?"ar":"en").format(pickedDate).toString();
          }
        },
        prefixIcon: Image.asset(
          AppImages.dateBirth,
          scale: 2.6,
        ),
      ctrl: cubit.dateInputController,
    );
    });
  }
}
