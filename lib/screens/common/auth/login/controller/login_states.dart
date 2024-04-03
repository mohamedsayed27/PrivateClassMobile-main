abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class SecurePassState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {}

class LoginErrorState extends LoginStates {}

class LoginGoogleFailureState extends LoginStates {}

class LoginGoogleLoadingState extends LoginStates {}

class LoginFaceBookLoadingState extends LoginStates {}

class LoginFaceBookSuccessState extends LoginStates {}

class LoginGoogleSuccessState extends LoginStates {}
