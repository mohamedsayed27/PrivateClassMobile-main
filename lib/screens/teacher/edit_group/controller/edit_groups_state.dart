abstract class EditGroupsStates {}

class EditGroupsInitialState extends EditGroupsStates {}

class GetGroupLoadingState extends EditGroupsStates {}

class GetGroupSuccessState extends EditGroupsStates {}

class GetGroupErrorState extends EditGroupsStates {}

class EditGroupLoadingState extends EditGroupsStates {}
class ChangeSelectAll extends EditGroupsStates {}
class UsersSelected extends EditGroupsStates {}

class EditGroupSuccessState extends EditGroupsStates {
  final String? msg;
  EditGroupSuccessState({this.msg});
}

class EditGroupErrorState extends EditGroupsStates {
  final String? msg;
  EditGroupErrorState({this.msg});
}

class RemoveSelected extends EditGroupsStates {}

class AddSelected extends EditGroupsStates {}

class GetAllUsersLoading extends EditGroupsStates {}

class GetAllUsersSuccess extends EditGroupsStates {}

class GetAllUsersError extends EditGroupsStates {}

class onConfirmState extends EditGroupsStates {}

class SelectTime extends EditGroupsStates {}
class SelectDay extends EditGroupsStates {}
