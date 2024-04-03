abstract class CustomFilterStates {}

class CustomFilterInitialState extends CustomFilterStates {}

class RadioCheckState extends CustomFilterStates {}

class ChangeDropDown extends CustomFilterStates {}

class ChangeDropDownTwo extends CustomFilterStates {}

//stages states
class GetStagesLoadingState extends CustomFilterStates {}

class GetStagesSuccessState extends CustomFilterStates {}

class GetStagesErrorState extends CustomFilterStates {
  final dynamic error;
  GetStagesErrorState(this.error);
}

//university states
class GetUniversityLoadingState extends CustomFilterStates {}

class GetUniversitySuccessState extends CustomFilterStates {}

class GetUniversityErrorState extends CustomFilterStates {}

//colleges states
class GetCollegesLoadingState extends CustomFilterStates {}

class GetCollegesSuccessState extends CustomFilterStates {}

class GetCollegesErrorState extends CustomFilterStates {}

//filter courses states
class FilterCoursesLoadingState extends CustomFilterStates {}

class FilterCoursesSuccessState extends CustomFilterStates {}

class FilterCoursesErrorState extends CustomFilterStates {}
class SaveCourseErrorState extends CustomFilterStates {}
class SaveCourseSuccessState extends CustomFilterStates {}
