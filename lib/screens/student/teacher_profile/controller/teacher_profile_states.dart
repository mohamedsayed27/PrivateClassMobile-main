abstract class TeacherProfileStates {}

class TeacherProfileInitialState extends TeacherProfileStates {}

class TeacherProfileLoadingState extends TeacherProfileStates {}

class TeacherProfileSuccessState extends TeacherProfileStates {}

class TeacherProfileFailureState extends TeacherProfileStates {}

class SaveTeacherCourseSuccess extends TeacherProfileStates {}

class SaveTeacherCourseError extends TeacherProfileStates {}
