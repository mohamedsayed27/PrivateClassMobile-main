abstract class OnlineStoreStates {}

class OnlineStoreInitialState extends OnlineStoreStates {}

class ChangeSliderState extends OnlineStoreStates {}

class ChangeColorState extends OnlineStoreStates {}

class LoadingState extends OnlineStoreStates {}

class FieldState extends OnlineStoreStates {}

class SuccessState extends OnlineStoreStates {}

class SaveCourseSuccess extends OnlineStoreStates {}

class SaveCourseField extends OnlineStoreStates {}

class FinishLoading extends OnlineStoreStates {}

class SearchStoreLoadingState extends OnlineStoreStates {}

class SearchStoreSuccessState extends OnlineStoreStates {}

class SearchStoreErrorState extends OnlineStoreStates {}

class AddToCartLoadingState extends OnlineStoreStates {}

class AddToCartSuccessState extends OnlineStoreStates {
  dynamic msg;
  AddToCartSuccessState({this.msg});
}

class AddToCartFailedState extends OnlineStoreStates {
  dynamic msg;
  AddToCartFailedState({this.msg});
}
