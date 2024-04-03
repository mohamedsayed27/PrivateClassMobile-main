abstract class SubscribeCourseStates {}

class SubscribeCourseInitialState extends SubscribeCourseStates {}
class ChangeRadioState extends SubscribeCourseStates {}
class SubscribeNowLoadingState extends SubscribeCourseStates {}
class SubscribeNowSuccessState extends SubscribeCourseStates {}
class SubscribeNowErrorState extends SubscribeCourseStates {}
class PayNowErrorState extends SubscribeCourseStates {}
class PayNowLoadingState extends SubscribeCourseStates {}
class PayNowSuccessState extends SubscribeCourseStates {}
