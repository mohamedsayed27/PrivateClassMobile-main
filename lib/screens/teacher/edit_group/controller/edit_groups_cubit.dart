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
import '../../create_group/model/all_users_model.dart';
import '../model/get_group_model.dart' as groupModel;
import 'edit_groups_state.dart';

class EditGroupsCubit extends Cubit<EditGroupsStates> {
  EditGroupsCubit() : super(EditGroupsInitialState());

  static EditGroupsCubit get(context) => BlocProvider.of(context);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController dateInputController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController fromController = TextEditingController();
  TextEditingController chooseStudentController = TextEditingController();


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
      mySelectedUsers = users ;
      usersId = usersIdSelectAll ;
      navigatorPop(context);
    }
    emit(ChangeSelectAll());
  }

  List<dynamic> mySelectedUsers = [];



onConfirm(values){
    print(values);
  mySelectedUsers = values;
  usersId = values.map((user) => user.id).toList();
  debugPrint("${usersId}");
  debugPrint("${mySelectedUsers}");
  emit(onConfirmState());

}


  void removeSelected(value) {
     mySelectedUsers.remove(value);
      usersId.remove(value.id);
    emit(RemoveSelected());
  }

  List<Users> selectedUsers = [];
  List<dynamic> usersss = [];
  List<dynamic> usersId = [];
  void selectUsers(values) {
    mySelectedUsers = values;
    emit(UsersSelected());
  }

  // void removeSelected(value) {
  //   selectedUsers.remove(value);
  //   emit(RemoveSelected());
  // }
  Map<dynamic, dynamic>? getGroupResponse;
  groupModel.GetGroupModel? getGroupModel;

  Future<void> getGroup(BuildContext? context, int groupId) async {
    emit(GetGroupLoadingState());
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      getGroupResponse = await myDio(
          url: AllAppApiConfig.baseUrl + AllAppApiConfig.getGroup + '$groupId',
          methodType: "get",
          dioBody: null,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if (getGroupResponse!['status'] == false) {
        debugPrint(getGroupResponse.toString());
        emit(GetGroupErrorState());
      } else {
        debugPrint(getGroupResponse!.toString());
        getGroupModel = groupModel.GetGroupModel.fromJson(getGroupResponse);
        nameController.text = getGroupModel!.data.name;
        detailController.text = getGroupModel!.data.details;
        dateInputController.text = getGroupModel!.data.dateGroup;
        fromController.text = getGroupModel!.data.timeFrom;
        mySelectedUsers = getGroupModel!.data.users;
        mySelectedUsers.forEach((element) {
          usersId.add(element.id);
        });
        print(mySelectedUsers);
        print(usersId);
        await getAllUsers(context);
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }



  Map<dynamic, dynamic>? editGroupResponse;
  Future<void> updateGroup(BuildContext? context, int groupId) async {
    emit(EditGroupLoadingState());
    try {
      Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': CacheHelper.getData(key: AppCached.appLanguage),
        'Authorization': 'Bearer ${CacheHelper.getData(key: AppCached.token)}'
      };
      final body = {
        "group_id": groupId,
        "name": nameController.text,
        "date_group": formatBackendDate??dateInputController.text,
        "time_from": valueBackend??fromController.text,
        "details": detailController.text,
        "users": usersId.isEmpty? mySelectedUsers : usersId,
      };
      print(body.toString());
      editGroupResponse = await myDio(
          url: AllAppApiConfig.baseUrl + AllAppApiConfig.updateGroup,
          methodType: "post",
          dioBody: body,
          dioHeaders: headers,
          appLanguage: CacheHelper.getData(key: AppCached.appLanguage),
          context: context!);
      if (editGroupResponse!['status'] == false) {
        debugPrint(editGroupResponse.toString());
        emit(EditGroupErrorState(msg: editGroupResponse!['message']));
      } else {
        debugPrint(editGroupResponse!.toString());
        await FirebaseFirestore.instance.collection('groups').doc(groupId.toString()).update({
          'date': formatBackendDate ??dateInputController.text ,
          'details': detailController.text,
          'group_name': nameController.text,
          'teacher_name': CacheHelper.getData(key: AppCached.name),
          'time': valueBackend ?? fromController.text,
        });
        navigateAndFinish(context: context, widget: CustomZoomDrawer(mainScreen: CustomBtnNavBarScreen(page: 0,isTeacher: CacheHelper.getData(key: AppCached.role)), isTeacher: CacheHelper.getData(key: AppCached.role)));
        emit(EditGroupSuccessState(msg: editGroupResponse!['message']));
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
          url: AllAppApiConfig.baseUrl +AllAppApiConfig.getAllUsers,
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
        emit(GetGroupSuccessState());
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }



  /// value to firebase
  String? valueBackend ;
  void pickedTime({required TimeOfDay value, required BuildContext context}) {
    final now = DateTime.now();
    final formatted = DateTime(now.year, now.month, now.day, value.hour, value.minute);
    String formatUI  = context.locale.languageCode == "ar" ?DateFormat.jm("ar").format(formatted):DateFormat.jm("en").format(formatted);
    fromController.text = formatUI ;
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
    dateInputController.text = formatUiDate! ;
    print(formatBackendDate);
    print(formatUiDate);
    emit(SelectDay());
  }
}
