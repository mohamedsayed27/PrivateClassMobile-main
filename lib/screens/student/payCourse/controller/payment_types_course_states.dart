abstract class PaymentTypesCourseStates {}

class PaymentTypesCourseInitialState extends PaymentTypesCourseStates {}
class PayNowLoadingState extends PaymentTypesCourseStates {}
class PayNowErrorState extends PaymentTypesCourseStates {}
class PayNowSuccessState extends PaymentTypesCourseStates {}
class ChangeRadioState extends PaymentTypesCourseStates {}
class CreateSessionState extends PaymentTypesCourseStates {}