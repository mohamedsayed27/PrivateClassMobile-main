
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/screens/common/btnNavBar/view/custom_btn_nav_bar_view.dart';
import 'package:private_courses/screens/common/drawer/components/custom_zoom_drawer.dart';
import '../../../../core/local/app_cached.dart';
import '../../../../core/local/global_config.dart';
import '../../../../shared/local/cache_helper.dart';
import '../../../../shared/remote/dio.dart';
import '../../groups/model/groups_model.dart';
import '../model/all_users_model.dart';
import 'create_group_state.dart';

class CreateGroupCubit extends Cubit<CreateGroupState> {
  CreateGroupCubit() : super(CreateGroupInitial());

  static CreateGroupCubit get(context) => BlocProvider.of(context);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController groupNameCtrl = TextEditingController();
  final TextEditingController groupDateCtrl = TextEditingController();
  final TextEditingController fromCtrl = TextEditingController();
  final TextEditingController chooseStudentCtrl = TextEditingController();
  final TextEditingController groupDiscriptioCtrl = TextEditingController();

  String? timeFrom;
  String? groupDate;
  bool selectAll = false ;
  List<int> usersIdSelectAll = [];
  List<Users> users = [];

  void changeAll (context){
    selectAll = !selectAll ;
    if(selectAll==false){
      usersIdSelectAll.clear();
      users.clear();
      print("usersIdSelectAll >>>" + usersIdSelectAll.toString());
      print("users >>>" + users.toString());
      navigatorPop(context);
  }else{
      usersIdSelectAll.clear();
      users.clear();

    allUsersModel!.users.forEach((element) {
      usersIdSelectAll.add(element.id);});
    allUsersModel!.users.forEach((element) {users.add(element);});
    print("usersIdSelectAll >>>" +usersIdSelectAll.toString());
    print("users >>>" +users.toString());
    selectedUsers = users ;
    usersId = usersIdSelectAll ;
      navigatorPop(context);
    }
    emit(ChangeSelectAll());
  }

  List<Users> selectedUsers = [];
  List<int> usersId = [];
  void selectUsers(values) {
      selectedUsers = values;
    emit(UsersSelected());
  }

  void removeSelected(value) {
    selectedUsers.remove(value);
    emit(RemoveSelected());
  }

  Map<dynamic, dynamic>? createGroupReponse;
  GroupsModel? groupsModel;
  Future<void> createGroup(BuildContext? context) async {
    emit(CreateGroupLoadingState());
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      final body = {
        "name": groupNameCtrl.text,
        "date_group": formatBackendDate,
        "time_from": valueBackend,
        "details": groupDiscriptioCtrl.text,
        "users": usersId,
      };
      debugPrint(body.toString());
      createGroupReponse = await myDio(
          url: "${AllAppApiConfig.baseUrl}"
              "${AllAppApiConfig.createGroup}",
          methodType: "post",
          dioBody: body,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if (createGroupReponse!['status'] == false) {
        debugPrint(createGroupReponse.toString());
        emit(CreateGroupErrorState(msg: createGroupReponse!['message']));
      } else {

        debugPrint(createGroupReponse!.toString());
        await FirebaseFirestore.instance.collection('groups').doc(createGroupReponse!["data"]["id"].toString()).set({
          'active': false,
          'date': formatBackendDate,
          'group_id': createGroupReponse!["data"]["id"].toString(),
          'details': groupDiscriptioCtrl.text,
          'link' : createGroupReponse!["data"]["link"].toString(),
          'finished': false,
          'slug': createGroupReponse!["data"]["slug"].toString(),
          'group_name': groupNameCtrl.text,
          'teacher_name': CacheHelper.getData(key: AppCached.name),
          'time': valueBackend,
          'user_id': CacheHelper.getData(key: AppCached.userId).toString(),
        });
        navigateAndFinish(context: context, widget: CustomZoomDrawer(mainScreen: CustomBtnNavBarScreen(page: 0,isTeacher: CacheHelper.getData(key: AppCached.role)), isTeacher: CacheHelper.getData(key: AppCached.role)));
        emit(CreateGroupSuccessState(msg: createGroupReponse!['message']));
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  Map<dynamic, dynamic>? getUsersResponse;
  AllUsersModel? allUsersModel;
  Future<void> getAllUsers(BuildContext? context) async {
    emit(GetAllUsersLoading());
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      getUsersResponse = await myDio(
          url: "${AllAppApiConfig.baseUrl}"
              "${AllAppApiConfig.getAllUsers}",
          methodType: "get",
          dioBody: null,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if (getUsersResponse!['status'] == false) {
        debugPrint(getUsersResponse.toString());
        emit(GetAllUsersError());
      } else {
        debugPrint(getUsersResponse!.toString());
        allUsersModel = AllUsersModel.fromJson(getUsersResponse);
        emit(GetAllUsersSuccess());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  void clearFields() {
    groupNameCtrl.clear();
    groupDateCtrl.clear();
    groupDiscriptioCtrl.clear();
    fromCtrl.clear();
    selectedUsers.clear();
  }


       /// value to firebase
  String? valueBackend ;
  void pickedTime({required TimeOfDay value, required BuildContext context}) {
    final now = DateTime.now();
    final formatted = DateTime(now.year, now.month, now.day, value.hour, value.minute);
    String formatUI  = context.locale.languageCode == "ar" ?DateFormat.jm("ar").format(formatted):DateFormat.jm("en").format(formatted);
    fromCtrl.text = formatUI ;
    valueBackend = '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}' ;
    print(valueBackend);
    print(formatUI+" Ui ");
    emit(SelectTime());
  }


  String? formatUiDate ;
  String? formatBackendDate ;
  void pickedDate({required dynamic value, required BuildContext context}){
    formatBackendDate = DateFormat("yyyy-MM-dd",'en').format(value);
    formatUiDate = context.locale.languageCode == "ar"?DateFormat.yMMMMd('ar').format(value):DateFormat.yMMMMd('en').format(value);
    groupDateCtrl.text = formatUiDate! ;
    print(formatBackendDate);
    print(formatUiDate);
    emit(SelectDay());
  }
}