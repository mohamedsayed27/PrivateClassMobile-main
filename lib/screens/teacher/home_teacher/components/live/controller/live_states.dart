abstract class LiveStates {}

class LiveCubitInitial extends LiveStates {}
class SelectDay extends LiveStates {}
class SelectTime extends LiveStates {}
class CreateLiveLoading extends LiveStates {}
class CreateLiveSuccess extends LiveStates {}
class CreateLiveError extends LiveStates {}
