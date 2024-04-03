abstract class AllSecondaryDepartmentStates {}

class AllSecondaryDepartmentInitialState extends AllSecondaryDepartmentStates {}

class GetAllSecondaryDepartmentLoadingState
    extends AllSecondaryDepartmentStates {}

class GetAllSecondaryDepartmentSuccessState
    extends AllSecondaryDepartmentStates {}

class GetAllSecondaryDepartmentErrorState
    extends AllSecondaryDepartmentStates {}

class SaveSuccessState extends AllSecondaryDepartmentStates {}

class SaveErrorState extends AllSecondaryDepartmentStates {}

class SearchCourseLoadingState extends AllSecondaryDepartmentStates {}

class SearchCourseSuccessState extends AllSecondaryDepartmentStates {}

class SearchCourseErrorState extends AllSecondaryDepartmentStates {}
