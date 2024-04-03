import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../generated/locale_keys.g.dart';

class DeletePopUp extends StatelessWidget {
  DeletePopUp({Key? key, required this.onTap}) : super(key: key);
  void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: const Color(0xffF2F2F2),
      constraints:  BoxConstraints.tightFor(width: width(context)*0.55),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            onTap: onTap,
            padding: EdgeInsets.symmetric(horizontal: width(context) * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                    text: LocaleKeys.DeleteNotification.tr(),
                    fontSize: AppFonts.t5,
                    color: Colors.redAccent),
                SizedBox(
                  width: width(context) * 0.02
                ),
                Image.asset(AppImages.trashFilled, scale: 3.01),
              ],
            ),
          ),
        ];
      },
      child: Icon(
        Icons.more_horiz_outlined,
        color: Colors.grey.shade300,
      ),
    );
  }
}
