abstract class CreateGroupState {}

class CreateGroupInitial extends CreateGroupState {}

class GetAllUsersLoading extends CreateGroupState {}

class GetAllUsersSuccess extends CreateGroupState {}

class GetAllUsersError extends CreateGroupState {}
class ChangeSelectAll extends CreateGroupState {}

class CreateGroupLoadingState extends CreateGroupState {}
class SelectTime extends CreateGroupState {}
class SelectDay extends CreateGroupState {}

class CreateGroupSuccessState extends CreateGroupState {
  final String? msg;
  CreateGroupSuccessState({this.msg});
}

class CreateGroupErrorState extends CreateGroupState {
  final String? msg;
  CreateGroupErrorState({this.msg});
}

class RemoveSelected extends CreateGroupState {}

class UsersSelected extends CreateGroupState {}
