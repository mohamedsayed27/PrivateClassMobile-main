abstract class CartStates {}

class CartInitialState extends CartStates {}

class GetCartLoadingState extends CartStates {}

class GetCartSuccessState extends CartStates {}

class GetCartFailedState extends CartStates {}

class ItemDeleteLoadingState extends CartStates {}
class SaveCartErrorState extends CartStates {}
class SaveCartSuccessState extends CartStates {}

class ItemDeleteSuccessState extends CartStates {}

class ItemDeleteFailedState extends CartStates {}

class CheckCouponLoadingState extends CartStates {}

class CheckCouponSuccessState extends CartStates {}

class CheckCouponFailedState extends CartStates {
  final dynamic error;
  CheckCouponFailedState({this.error});
}

class PayLoadingState extends CartStates {}

class PaySuccessState extends CartStates {
  final dynamic message;
  PaySuccessState({this.message});
}

class PayFailedState extends CartStates {
  final dynamic error;
  PayFailedState({this.error});
}
