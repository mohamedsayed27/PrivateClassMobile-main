abstract class ContactUsStates {}

class ContactUsInitialState extends ContactUsStates {}

class LoadingState extends ContactUsStates {}

class FieldState extends ContactUsStates {
  final dynamic msg;
  FieldState({this.msg});
}

class SuccessState extends ContactUsStates {}
