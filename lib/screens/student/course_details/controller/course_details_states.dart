abstract class CourseDetailsStates {}

class CourseDetailsInitialState extends CourseDetailsStates {}

class CourseDetailsLoadingState extends CourseDetailsStates {}

class CourseDetailsSuccessState extends CourseDetailsStates {}

class CourseDetailsFailureState extends CourseDetailsStates {}

class SaveCourseSuccessState extends CourseDetailsStates {}

class SaveCourseErrorState extends CourseDetailsStates {}
class UnSubscribeCourseLoadingState extends CourseDetailsStates {}
class UnSubscribeCourseSuccessState extends CourseDetailsStates {}
class UnSubscribeCourseErrorState extends CourseDetailsStates {}
class CheckCouponLoadingState extends CourseDetailsStates {}
class CheckCouponFailedState extends CourseDetailsStates {}
class CheckCouponSuccessState extends CourseDetailsStates {}

class SubscribeCourseSuccessState extends CourseDetailsStates {
  final dynamic msg;
  SubscribeCourseSuccessState({this.msg});
}

class SubscribeCourseErrorState extends CourseDetailsStates {
  final dynamic msg;
  SubscribeCourseErrorState({this.msg});
}

class FinishedVedioSuccessState extends CourseDetailsStates {
  final dynamic msg;
  FinishedVedioSuccessState({this.msg});
}

class FinishedVedioErrorState extends CourseDetailsStates {
  final dynamic msg;
  FinishedVedioErrorState({this.msg});
}