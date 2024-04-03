import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../../../../generated/locale_keys.g.dart';
import 'lecture_details_states.dart';

class LectureDetailsCubit extends Cubit<LectureDetailsStates> {
  LectureDetailsCubit() : super(LectureDetailsInitialState());

  static LectureDetailsCubit get(context) => BlocProvider.of(context);

  List<String> videosUrl = [
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
    "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
    "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
    "http://techslides.com/demos/sample-videos/small.mp4",
    "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
    "http://techslides.com/demos/sample-videos/small.mp4",
  ];
  List<String> units = [
    LocaleKeys.ModuleOneIntroduction.tr(),
    LocaleKeys.ModuleTwoIntroduction.tr(),
    LocaleKeys.ModuleThreeIntroduction.tr(),
  ];

  List<String> leasons = [
    LocaleKeys.FirstLectureName.tr(),
    LocaleKeys.SecondLectureName.tr()
  ];

  List<String> numbers = ["1", "2"];

  late VideoPlayerController controller;

  int currentIndex = 0;

  // void playVideo({bool init = false, int index = 0}) {
  //   print("Loading");
  //   controller = VideoPlayerController.network(videosUrl[currentIndex])
  //     ..setLooping(true)
  //     ..initialize().then((value) => controller.play());
  //   emit(PlayVideo());
  //   print("Success");
  // }
}
