import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/custom_loading.dart';
import 'package:private_courses/components/custom_text.dart';
import 'package:private_courses/components/custom_toast.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/components/style/colors.dart';
import 'package:private_courses/screens/common/report_problem/view/report_view.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../components/custom_appBar.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../generated/locale_keys.g.dart';
import '../components/contact_usItem.dart';
import '../controller/contact_us_cubit.dart';
import '../controller/contact_us_states.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ContactUsCubit()..fetchContactUs(context: context),
        child: BlocConsumer<ContactUsCubit, ContactUsStates>(
            listener: (context, state) {
          if (state is FieldState) {
            showSnackBar(context: context, text: state.msg, success: false);
          }
        }, builder: (context, state) {
          final cubit = ContactUsCubit.get(context);
          return SafeArea(
              child: Scaffold(
                  body: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: width(context) * 0.04),
                      child:  Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                  CustomAppBar(
                                      isNotify: true,
                                      textAppBar: LocaleKeys.ContactUs.tr(),
                                      isDrawer: true),
                                state is LoadingState
                                    ? const CustomLoading(load: true)
                                    :Expanded(
                                    child: SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              height: height(context) * 0.02),
                                          Image.asset(AppImages.contactUsImg,
                                              scale: 4.4),
                                          SizedBox(
                                              height: height(context) * 0.04),
                                          Card(
                                            elevation: 1.2,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: InkWell(
                                                borderRadius: BorderRadius.circular(20),
                                              onTap:(){
                                                navigateTo(context,ReportView(twak: cubit.contactUsModel!.data!.tawk!));
                                              },
                                              child: Container(
                                                padding: EdgeInsetsDirectional.all(width(context)*0.038,),
                                                decoration: BoxDecoration(
                                                    color: AppColors.lightBlueColor.withOpacity(.05),
                                                    borderRadius: BorderRadius.circular(20)
                                                ),
                                                child: Row(
                                                  children: [
                                                    context.locale.languageCode=="ar"?
                                                    Image.asset(AppImages.chatAr, scale: 2):
                                                    Image.asset(AppImages.chatEn, scale: 2),
                                                    SizedBox(width: width(context)*0.017),
                                                    CustomText(text: LocaleKeys.ChatNow.tr(), color: AppColors.blackColor),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          // ContactUsItem(
                                          //   title: LocaleKeys.PhoneNum.tr(),
                                          //   img: AppImages.blackPhone,
                                          //   subTitle: cubit.contactUsModel!.data!.phone,
                                          //   onTap: () async {
                                          //     final Uri launchUri = Uri(
                                          //       scheme: 'tel',
                                          //       path: cubit.contactUsModel!
                                          //           .data!.phone,
                                          //     );
                                          //     await launchUrl(launchUri);
                                          //   },
                                          // ),
                                          SizedBox(
                                              height: height(context) * 0.01),
                                          ContactUsItem(
                                            title: LocaleKeys.Email.tr(),
                                            img: AppImages.blackEmail,
                                            subTitle: cubit.contactUsModel!.data!.email,
                                            onTap: () async {
                                              final url = Uri(
                                                  scheme: 'mailto',
                                                  path: cubit.contactUsModel!
                                                      .data!.email
                                                      .toString());
                                              if (await canLaunchUrl(url)) {
                                                await launchUrl(url);
                                              } else {
                                                throw 'Could not launch $url';
                                              }
                                            },
                                          ),
                                          SizedBox(
                                              height: height(context) * 0.01),
                                          ContactUsItem(
                                              title: LocaleKeys.Telegram.tr(),
                                              img: context.locale.languageCode == "ar"
                                                      ? AppImages.blackTel
                                                      : AppImages.telegramEn,
                                              subTitle: cubit.contactUsModel!.data!.twitterLink!,
                                              onTap: () async {
                                                if (!await launchUrl(
                                                  Uri.parse(cubit.contactUsModel!.data!.twitterLink!),
                                                  mode: LaunchMode
                                                      .externalApplication,
                                                )) {
                                                  throw 'Could not launch ${cubit.contactUsModel!.data!.twitterLink!}';
                                                }
                                              }),
                                          SizedBox(
                                              height: height(context) * 0.01),
                                          ContactUsItem(
                                            title: LocaleKeys.WhatsApp.tr(),
                                            img: AppImages.whatsApp,
                                            scale:2.25,
                                            subTitle: cubit.contactUsModel!.data!.phone,
                                            onTap: ()async {
                                              if (!await launchUrl(Uri.parse('whatsapp://send?phone=${cubit.contactUsModel!.data!.phone}'))) {
                                              throw 'Could not launch';
                                              } else {
                                              return null ;
                                              }
                                            },
                                          ),
                                          SizedBox(height: height(context) * 0.02),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]))));
        }));
  }
}
