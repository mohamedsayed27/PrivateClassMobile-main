abstract class FormCheckoutStates {}

class FormCheckoutInitialState extends FormCheckoutStates {}
class ChangeDropDown extends FormCheckoutStates {}
class PickGalleryImageState extends FormCheckoutStates {}
class PickCameraImageState extends FormCheckoutStates {}
class SelectDayState extends FormCheckoutStates {}
class GetBanksLoadingState extends FormCheckoutStates {}
class GetBanksErrorState extends FormCheckoutStates {}
class GetBanksSuccessState extends FormCheckoutStates {}
class FormSuccessState extends FormCheckoutStates {}
class FormErrorState extends FormCheckoutStates {}
class FormLoadingState extends FormCheckoutStates {}
class BankIbanSuccessState extends FormCheckoutStates {}
class BankIbanFieldState extends FormCheckoutStates {}
class BankIbanLoadingState extends FormCheckoutStates {}