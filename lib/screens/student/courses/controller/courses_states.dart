abstract class CoursesStates {}

class CoursesInitialState extends CoursesStates {}

class ChangeBottomState extends CoursesStates {}

class CurrentCoursesLoadingState extends  CoursesStates{}

class CurrentCoursesSuccessState extends  CoursesStates{}

class CurrentCoursesFailureState extends  CoursesStates{}

class PreviousCoursesLoadingState extends  CoursesStates{}

class PreviousCoursesSuccessState extends  CoursesStates{}

class PreviousCoursesFailureState extends  CoursesStates{}