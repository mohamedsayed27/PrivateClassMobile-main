// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:private_courses/components/custom_loading.dart';
// import 'package:private_courses/components/empty_list.dart';
// import 'package:private_courses/components/my_navigate.dart';
// import '../../../../components/custom_appBar.dart';
// import '../../../../components/style/size.dart';
// import '../../../../components/text_form_field_serch.dart';
//
// import '../../../../generated/locale_keys.g.dart';
// import '../components/secondary_search_view.dart';
// import '../components/secondary_view.dart';
// import '../controller/all_secondary_cubit.dart';
// import '../controller/all_secondary_states.dart';
//
// class AllSecondaryScreen extends StatelessWidget {
//   AllSecondaryScreen({required this.secondaryId, required this.valueChanged});
//   final ValueChanged<String?> valueChanged;
//   final secondaryId;
//   @override
//   Widget build(BuildContext context) {
//     FocusScopeNode currentFocus = FocusScope.of(context);
//     return GestureDetector(
//       onTap: () {
//         currentFocus.unfocus();
//       },
//       child: BlocProvider(
//         create: (context) =>
//             AllSecondaryCubit()..getAllUniversity(context, secondaryId),
//         child: BlocBuilder<AllSecondaryCubit, AllSecondaryStates>(
//             builder: (context, state) {
//           final cubit = AllSecondaryCubit.get(context);
//           return WillPopScope(
//             onWillPop: () async {
//               valueChanged.call('');
//               return true;
//             },
//             child: Scaffold(
//               body: Padding(
//                 padding:
//                     EdgeInsets.symmetric(horizontal: width(context) * 0.04),
//                 child: Column(
//                   children: [
//                     CustomAppBar(
//                       isNotify: false,
//                       textAppBar: LocaleKeys.AllStages.tr(),
//                       onTapBack: () {
//                         valueChanged.call('');
//                         navigatorPop(context);
//                       },
//                     ),
//                     SizedBox(height: height(context) * 0.01),
//                     CustomTextFormFieldSearch(
//                       ctrl: cubit.searchCtrl,
//                       hintText: LocaleKeys.SearchOfStage.tr(),
//                       onChanged: (value) {
//                         if (value.isNotEmpty) {
//                           print(secondaryId);
//                           cubit.searchSecondary(
//                               context: context,
//                               secondaryName: value,
//                               id: secondaryId);
//                           cubit.isSearch = true;
//                         } else {
//                           cubit.isSearch = false;
//                           cubit.getAllUniversity(context, secondaryId);
//                         }
//                       },
//                     ),
//                     SizedBox(height: height(context) * 0.035),
//                     state is GetAllSecondaryLoadingState
//                         ? const CustomLoading(load: true)
//                         : state is SearchCourseLoadingState
//                             ? CustomLoading(load: false)
//                             : cubit.isSearch == true
//                                 ? cubit.searchSecondaryModel!.data!.isEmpty
//                                     ? const Expanded(child: EmptyList())
//                                     : SecondarySearchView(
//                                         cubit: cubit,
//                                         secondaryName: cubit.searchCtrl.text,
//                                         secondaryId: secondaryId)
//                                 : SecondaryView(
//                                     cubit: cubit, secondaryId: secondaryId),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
