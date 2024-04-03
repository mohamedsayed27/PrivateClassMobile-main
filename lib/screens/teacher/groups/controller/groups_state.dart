abstract class GroupsStates {}

class GroupsInitialState extends GroupsStates {}

class GetGroupsLoading extends GroupsStates {}

class GetGroupsSuccess extends GroupsStates {}

class GetGroupsError extends GroupsStates {
  final String? msg;
  GetGroupsError({this.msg});
}
