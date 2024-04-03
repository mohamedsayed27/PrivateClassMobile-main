abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class HomeLoadingState extends HomeStates {}

class HomeSuccessState extends HomeStates {}

class HomeFailedState extends HomeStates {
  final dynamic error;
  HomeFailedState(this.error);
}

class SaveCourseSuccessState extends HomeStates {}

class SaveCourseErrorState extends HomeStates {}

//search courses states
class SearchCourseLoadingState extends HomeStates {}

class SearchCourseSuccessState extends HomeStates {}

class SearchCourseErrorState extends HomeStates {}

class GetLivesLoading extends HomeStates {}

class GetLivesSuccess extends HomeStates {}

class ChangeBottomState extends HomeStates {}

class GetAllSecondaryLoadingState extends HomeStates {}

class GetAllSecondaryErrorState extends HomeStates {}

class GetAllSecondarySuccessState extends HomeStates {}
