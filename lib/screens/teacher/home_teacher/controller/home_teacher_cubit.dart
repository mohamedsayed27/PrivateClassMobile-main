import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_teacher_states.dart';

class HomeTeacherCubit extends Cubit<HomeTeacherStates> {
  HomeTeacherCubit() : super(HomeTeacherInitialState());

  static HomeTeacherCubit get(context) => BlocProvider.of(context);

}