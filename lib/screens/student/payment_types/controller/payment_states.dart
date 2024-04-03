abstract class PayCartTypesStates {}

class PayCartTypesInitialState extends PayCartTypesStates {}

class PayNowLoadingState extends PayCartTypesStates {}

class PayNowSuccessState extends PayCartTypesStates {}

class PayNowErrorState extends PayCartTypesStates {}

class NewState extends PayCartTypesStates {}

class ChangeRadioState extends PayCartTypesStates {}
