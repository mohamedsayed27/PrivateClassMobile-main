abstract class ChangePassword {}

class ChangePassInitialState extends ChangePassword {}
class SecurePassState extends ChangePassword{}
class ChangePassLoadingState extends ChangePassword{}
class ChangePassSuccessState extends ChangePassword{}
class ChangePassErrorState extends ChangePassword{}