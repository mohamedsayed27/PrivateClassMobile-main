abstract class ProductDetailsStates {}

class ProductDetailsInitialState extends ProductDetailsStates {}

class ChangeSliderState extends ProductDetailsStates {}

class ToggleAboutState extends ProductDetailsStates {}

class ToggleChatAndProfileState extends ProductDetailsStates {}

class LoadingState extends ProductDetailsStates {}

class SuccessState extends ProductDetailsStates {}

class FieldState extends ProductDetailsStates {}

class AddToCartLoadingState extends ProductDetailsStates {}

class AddToCartSuccessState extends ProductDetailsStates {
  dynamic msg;
  AddToCartSuccessState({this.msg});
}

class AddToCartFailedState extends ProductDetailsStates {
  dynamic msg;
  AddToCartFailedState({this.msg});
}

class SaveCourseErrorState extends ProductDetailsStates {}

class SaveCourseSuccessState extends ProductDetailsStates {}
