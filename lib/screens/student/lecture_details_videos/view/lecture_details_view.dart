import 'dart:async';
import 'dart:math';
import 'package:easy_localization/easy_localization.dart' as localization;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:private_courses/components/custom_loading.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/core/local/app_cached.dart';
import 'package:private_courses/screens/common/drawer/components/custom_zoom_drawer.dart';
import 'package:private_courses/screens/student/course_details/components/finished_vedio.dart';
import 'package:private_courses/screens/student/course_details/controller/course_details_cubit.dart';
import 'package:private_courses/screens/student/course_details/model/courses_details_model.dart';
import 'package:private_courses/screens/student/courses/components/finished_courses.dart';
import 'package:private_courses/screens/student/lecture_details_videos/components/not_pay.dart';
import 'package:private_courses/screens/student/payCourse/view/payment_types_course_view.dart';
import 'package:private_courses/screens/student/payment_course/view/payment_course_view.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';
import '../../../../components/custom_appBar.dart';
import '../../../../components/custom_text.dart';
import '../../../../components/style/colors.dart';
import '../../../../components/style/images.dart';
import '../../../../components/style/size.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../subscribe_course/view/subscribe_course_view.dart';

class LectureDetailsScreen extends StatefulWidget {
  final CourseDetailsCubit? cubit;
  final int vedIndex;
  const LectureDetailsScreen({required this.cubit, required this.vedIndex});

  @override
  State<LectureDetailsScreen> createState() => _LectureDetailsScreenState();
}

class _LectureDetailsScreenState extends State<LectureDetailsScreen> {
  VideoPlayerController? _controller;

  var _playingIndex = -1;
  var _disposed = false;
  var _isFullScreen = false;
  var _isEndOfClip = false;
  var _progress = 0.0;
  var _showingDialog = false;
  Timer? _timerVisibleControl;
  double _controlAlpha = 1.0;
  var _updateProgressInterval = 0.0;
  Duration? _duration;
  Duration? _position;

  var _playing = false;
  bool get _isPlaying {
    return _playing;
  }

  set _isPlaying(bool value) {
    _playing = value;
    _timerVisibleControl?.cancel();
    if (value) {
      _timerVisibleControl = Timer(Duration(seconds: 2), () {
        if (_disposed) return;
        setState(() {
          _controlAlpha = 0.0;
        });
      });
    } else {
      _timerVisibleControl = Timer(Duration(milliseconds: 200), () {
        if (_disposed) return;
        setState(() {
          _controlAlpha = 1.0;
        });
      });
    }
  }

  void _onTapVideo() {
    debugPrint("_onTapVideo $_controlAlpha");
    setState(() {
      _controlAlpha = _controlAlpha > 0 ? 0 : 1;
    });
    _timerVisibleControl?.cancel();
    _timerVisibleControl = Timer(Duration(seconds: 2), () {
      if (_isPlaying) {
        setState(() {
          _controlAlpha = 0.0;
        });
      }
    });
  }

  @override
  void initState() {
    Wakelock.enable();
    _initializeAndPlay(widget.vedIndex);
    super.initState();
  }

  String title = "";
  int currentVedio = 0;
  int? currentindex;

  @override
  void dispose() {
    _disposed = true;
    _timerVisibleControl?.cancel();
    Wakelock.disable();
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    // _exitFullScreen();
    _controller!.pause(); // mute instantly
    _controller!.dispose();
    _controller = null;
    _exitFullScreen();
    super.dispose();
  }

  void _initializeAndPlay(int index) async {
    if ((widget.cubit!.courseVideos[index].free == true) ||
        (widget.cubit!.courseDetailsModel!.data!.isSubscribed!)) {
      print("isMute init " + isMute.toString());
      setState(() {
        isMute = false;
      });
      print("isMute setState " + isMute.toString());
      print(
          "_initializeAndPlay --*-*-*-*--*-*-*-*-*-*-*-*-*-*-*--------> $index");
      print("_initializeAndPlay --*-*-*-*--*-*-*-*-*-*-*-*-*-*-*--------> " +
          widget.cubit!.courseVideos.toString());
      final clip = widget.cubit!.courseVideos[index].video;
      title = widget.cubit!.courseVideos[index].name!;
      currentindex = widget.cubit!.courseVideos[index].vedIndx!;
      currentVedio = index;
      final controller = VideoPlayerController.network(clip!);

      final old = _controller;
      _controller = controller;
      if (old != null) {
        old.removeListener(_onControllerUpdated);
        old.pause();
        debugPrint("---- old contoller paused.");
      }

      debugPrint("---- controller changed.");
      setState(() {});

      controller
        ..initialize().then((_) {
          debugPrint("---- controller initialized");
          old?.dispose();
          _playingIndex = index;
          _duration = null;
          _position = null;
          controller.addListener(_onControllerUpdated);
          controller.play();
          setState(() {});
        });
    } else {
      print("money");
      if (_isFullScreen) {
        _exitFullScreen();
        showDialog(
            context: context,
            builder: (context) => NotPayPopup(
                  onTap: () {
                    CacheHelper.saveData(AppCached.amountCart,  widget.cubit!.courseDetailsModel!.data!.price!);
                    navigateTo(
                        context,
                        CustomZoomDrawer(
                            mainScreen: PaymentTypesCourseScreen(
                                isBankPayment: widget.cubit!.courseDetailsModel!.data!.isBankPayment!,
                                id: widget.cubit!.courseDetailsModel!.data!.id!,
                                courseName: widget.cubit!.courseDetailsModel!.data!.name!,
                                isInstallment: widget.cubit!.courseDetailsModel!.data!.isInstallment!,
                                paymentKey: widget.cubit!.courseDetailsModel!.data!.paymentKey!,
                                amount: double.parse(widget.cubit!.courseDetailsModel!.data!.price!).round()),
                            isTeacher: CacheHelper.getData(key: AppCached.role)));
                    // navigateTo(context, CustomZoomDrawer(
                    //         mainScreen: SubscribeCourseScreen(
                    //           isCart: false,
                    //           courseId:
                    //               widget.cubit!.courseDetailsModel!.data!.id,
                    //           nameCourse:
                    //               widget.cubit!.courseDetailsModel!.data!.name,
                    //         ),
                    //         isTeacher:
                    //             CacheHelper.getData(key: AppCached.role)));
                    // navigateTo(context, CustomZoomDrawer(
                    //     mainScreen:PaymentCourseScreen(
                    //       paymentKey: widget.cubit!.courseDetailsModel!.data!.paymentKey!,
                    //       coursePrice: double.parse(widget.cubit!.courseDetailsModel!.data!.price!).round(),
                    //       courseName: widget.cubit!.courseDetailsModel!.data!.name!,
                    //       id: widget.cubit!.courseDetailsModel!.data!.id!,
                    //     ),
                    //     isTeacher: CacheHelper.getData(key: AppCached.role)));
                  },
                ));
      } else {}

      showDialog(
          context: context,
          builder: (context) => NotPayPopup(
                onTap: () {
                  // navigateTo(context, CustomZoomDrawer(
                  //     mainScreen: SubscribeCourseScreen(
                  //           isCart: false,
                  //           courseId:
                  //               widget.cubit!.courseDetailsModel!.data!.id,
                  //           nameCourse:
                  //               widget.cubit!.courseDetailsModel!.data!.name,
                  //         ), isTeacher: CacheHelper.getData(key: AppCached.role)));
                  // navigateTo(context, CustomZoomDrawer(
                  //     mainScreen:PaymentCourseScreen(
                  //       paymentKey: widget.cubit!.courseDetailsModel!.data!.paymentKey!,
                  //       coursePrice: double.parse(widget.cubit!.courseDetailsModel!.data!.price!).round(),
                  //       courseName: widget.cubit!.courseDetailsModel!.data!.name!,
                  //       id: widget.cubit!.courseDetailsModel!.data!.id!,
                  //     ),
                  //     isTeacher: CacheHelper.getData(key: AppCached.role)));
                  CacheHelper.saveData(AppCached.amountCart,  widget.cubit!.courseDetailsModel!.data!.price!);
                  navigateTo(
                      context,
                      CustomZoomDrawer(
                          mainScreen: PaymentTypesCourseScreen(
                              isBankPayment: widget.cubit!.courseDetailsModel!.data!.isBankPayment!,
                              id: widget.cubit!.courseDetailsModel!.data!.id!,
                              courseName: widget.cubit!.courseDetailsModel!.data!.name!,
                              isInstallment: widget.cubit!.courseDetailsModel!.data!.isInstallment!,
                              paymentKey: widget.cubit!.courseDetailsModel!.data!.paymentKey!,
                              amount: double.parse(widget.cubit!.courseDetailsModel!.data!.price!).round()),
                          isTeacher: CacheHelper.getData(key: AppCached.role)));
                },
              ));
    }
  }

  void _onControllerUpdated() async {
    if (_disposed) return;
    // blocking too many updation
    // important !!
    final now = DateTime.now().millisecondsSinceEpoch;
    if (_updateProgressInterval > now) {
      return;
    }
    _updateProgressInterval = now + 500.0;

    final controller = _controller;
    if (controller == null) return;
    if (!controller.value.isInitialized) return;
    if (_duration == null) {
      _duration = _controller!.value.duration;
    }
    var duration = _duration;
    if (duration == null) return;

    var position = await controller.position;
    _position = position;
    final playing = controller.value.isPlaying;
    final isEndOfClip = position!.inMilliseconds > 0 &&
        position.inSeconds + 1 >= duration.inSeconds;
    if (playing) {
      // handle progress indicator
      if (_disposed) return;
      setState(() {
        _progress = position.inMilliseconds.ceilToDouble() /
            duration.inMilliseconds.ceilToDouble();
      });
    }

    // handle clip end
    if (_isPlaying != playing || _isEndOfClip != isEndOfClip) {
      _isPlaying = playing;
      _isEndOfClip = isEndOfClip;
      debugPrint(
          "updated -----> isPlaying=$playing / isEndOfClip=$isEndOfClip");
      if (isEndOfClip && !playing) {
        debugPrint(
            "========================== End of Clip / Handle NEXT ========================== ");
        await widget.cubit!.finishVedio(
            context: context,
            id: widget.cubit!.courseVideos[currentindex!].id!);
        final isComplete =
            _playingIndex == widget.cubit!.courseVideos.length - 1;
        if (isComplete) {
          _showPlayedAllDialog();
          if (!_showingDialog) {
            _showingDialog = true;
            // showDialog(context: context, builder: (context) => NotPayPopup(),).then((value) => _showingDialog = false);
            // _showPlayedAllDialog().then((value) {
            //   // _exitFullScreen();
            //   _showingDialog = false;
            // });
          }
        } else {
          _initializeAndPlay(_playingIndex + 1);
        }
      }
    }
  }

  Future<Future> _showPlayedAllDialog() async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return FinishedVideo();
        });
  }

  Widget _playView(BuildContext context) {
    final controller = _controller;
    if (controller != null && controller.value.isInitialized) {
      return AspectRatio(
        //aspectRatio: controller.value.aspectRatio,
        aspectRatio: 12.5 / 6.0,
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onDoubleTap: _toggleFullscreen,
              child: VideoPlayer(controller),
              onTap: _onTapVideo,
            ),
            _controlAlpha > 0
                ? AnimatedOpacity(
                    opacity: _controlAlpha,
                    duration: Duration(milliseconds: 250),
                    child: _controlView(context),
                  )
                : Container(),
          ],
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: 12.5 / 6.0,
        child: CustomLoading(load: false),
      );
    }
  }

  Widget _controlView(BuildContext context) {
    return _bottomUI();
  }

  String videoDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(' : ');
  }

  String convertTwo(int value) {
    return value < 10 ? "0$value" : "$value";
  }

  Widget _bottomUI() {
    return _isFullScreen
        ? Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: height(context) * 0.02,
                  horizontal: width(context) * 0.05),
              child: Row(
                children: <Widget>[
                  IconButton(
                    color: Colors.yellow,
                    icon: Icon(
                      Icons.fullscreen,
                      color: Colors.white,
                    ),
                    onPressed: _toggleFullscreen,
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () {
                            _initializeAndPlay(currentVedio + 1);
                          },
                          child: Image.asset(
                              context.locale.languageCode == "ar"
                                  ? AppImages.nextWardAr
                                  : AppImages.nextWardEn,
                              scale: 2.5,
                              color: AppColors.whiteColor)),
                      SizedBox(width: width(context) * 0.05),
                      GestureDetector(
                          onTap: () async {
                            if (_isPlaying) {
                              _controller?.pause();
                              _isPlaying = false;
                            } else {
                              final controller = _controller;
                              if (controller != null) {
                                final pos = _position?.inSeconds ?? 0;
                                final dur = _duration?.inSeconds ?? 0;
                                final isEnd = pos == dur;
                                if (isEnd) {
                                  _initializeAndPlay(_playingIndex);
                                } else {
                                  controller.play();
                                }
                              }
                            }
                            setState(() {});
                          },
                          child: Image.asset(
                              _isPlaying == true
                                  ? AppImages.pause
                                  : AppImages.play,
                              scale: 2.6)),
                      SizedBox(width: width(context) * 0.05),
                      GestureDetector(
                          onTap: () {
                            currentVedio > 0
                                ? _initializeAndPlay(currentVedio - 1)
                                : null;
                          },
                          child: Image.asset(
                              context.locale.languageCode == "ar"
                                  ? AppImages.backWardAr
                                  : AppImages.backWardEn,
                              scale: 2.5,
                              color: AppColors.whiteColor)),
                    ],
                  ),
                  Spacer(),
                  GestureDetector(
                      onTap: () {
                        isMute = (_controller?.value.volume ?? 0) > 0;
                        if (isMute) {
                          _controller?.setVolume(0);
                        } else {
                          _controller?.setVolume(1.0);
                        }
                        setState(() {});
                      },
                      child: Image.asset(
                          isMute != true
                              ? AppImages.volume
                              : AppImages.noVolume,
                          scale: 2.5,
                          color: AppColors.whiteColor)),
                ],
              ),
            ),
          )
        : IconButton(
            color: Colors.yellow,
            icon: Icon(
              Icons.fullscreen,
              color: Colors.white,
            ),
            onPressed: _toggleFullscreen,
          );
  }

  bool isMute = false;
  void _toggleFullscreen() async {
    if (_isFullScreen) {
      _exitFullScreen();
    } else {
      _enterFullScreen();
    }
  }

  void _enterFullScreen() async {
    debugPrint("enterFullScreen");
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    if (_disposed) return;
    setState(() {
      _isFullScreen = true;
    });
  }

  void _exitFullScreen() async {
    debugPrint("exitFullScreen");
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    if (_disposed) return;
    setState(() {
      _isFullScreen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isFullScreen
          ? _playView(context)
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: width(context) * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: height(context) * 0.1,
                      child: CustomAppBar(isNotify: false, textAppBar: title)),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: _playView(context)),
                  SizedBox(
                    height: height(context) * 0.05,
                    child: Row(
                      children: [
                        Directionality(
                            textDirection: context.locale.languageCode == "ar"
                                ? TextDirection.ltr
                                : TextDirection.rtl,
                            child: ValueListenableBuilder(
                                valueListenable: _controller!,
                                builder: ((context, value, child) => CustomText(
                                    text: videoDuration(value.position),
                                    fontSize: AppFonts.t9,
                                    color: AppColors.greyTextColor)))),
                        Expanded(
                            child: SliderTheme(
                                data: const SliderThemeData(
                                    activeTickMarkColor: Colors.transparent,
                                    inactiveTickMarkColor: Colors.transparent,
                                    trackHeight: 3.5,
                                    rangeThumbShape: RoundRangeSliderThumbShape(
                                        enabledThumbRadius: 6)),
                                child: Slider(
                                  value: max(0, min(_progress * 100, 100)),
                                  min: 0,
                                  max: 100,
                                  activeColor: AppColors.goldColor,
                                  inactiveColor: AppColors.sliderColor,
                                  onChanged: (value) {
                                    setState(() {
                                      _progress = value * 0.01;
                                    });
                                  },
                                  onChangeStart: (value) {
                                    debugPrint("-- onChangeStart $value");
                                    _controller?.pause();
                                  },
                                  onChangeEnd: (value) {
                                    debugPrint("-- onChangeEnd $value");
                                    final duration =
                                        _controller?.value.duration;
                                    if (duration != null) {
                                      var newValue =
                                          max(0, min(value, 99)) * 0.01;
                                      var millis =
                                          (duration.inMilliseconds * newValue)
                                              .toInt();
                                      _controller?.seekTo(
                                          Duration(milliseconds: millis));
                                      _controller?.play();
                                    }
                                  },
                                ))),
                        Directionality(
                            textDirection: context.locale.languageCode == "ar"
                                ? TextDirection.ltr
                                : TextDirection.rtl,
                            child: ValueListenableBuilder(
                                valueListenable: _controller!,
                                builder: ((context, value, child) => CustomText(
                                    text: videoDuration(
                                        _controller!.value.duration),
                                    fontSize: AppFonts.t9,
                                    color: AppColors.greyTextColor)))),
                      ],
                    ),
                  ),
                  SizedBox(height: height(context) * 0.015),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: width(context) * 0.04),
                    child: Row(
                      children: [
                        SizedBox(width: width(context) * 0.195),
                        GestureDetector(
                            onTap: () {
                              _initializeAndPlay(currentVedio + 1);
                            },
                            child: Image.asset(
                                context.locale.languageCode == "ar"
                                    ? AppImages.nextWardAr
                                    : AppImages.nextWardEn,
                                scale: 2.5)),
                        SizedBox(width: width(context) * 0.05),
                        GestureDetector(
                            onTap: () async {
                              if (_isPlaying) {
                                _controller?.pause();
                                _isPlaying = false;
                              } else {
                                final controller = _controller;
                                if (controller != null) {
                                  final pos = _position?.inSeconds ?? 0;
                                  final dur = _duration?.inSeconds ?? 0;
                                  final isEnd = pos == dur;
                                  if (isEnd) {
                                    _initializeAndPlay(_playingIndex);
                                  } else {
                                    controller.play();
                                  }
                                }
                              }
                              setState(() {});
                            },
                            child: Image.asset(
                                _isPlaying == true
                                    ? AppImages.pause
                                    : AppImages.play,
                                scale: 2.5)),
                        SizedBox(width: width(context) * 0.05),
                        GestureDetector(
                            onTap: () {
                              currentVedio > 0
                                  ? _initializeAndPlay(currentVedio - 1)
                                  : null;
                            },
                            child: Image.asset(
                                context.locale.languageCode == "ar"
                                    ? AppImages.backWardAr
                                    : AppImages.backWardEn,
                                scale: 2.5)),
                        SizedBox(width: width(context) * 0.12),
                        GestureDetector(
                            onTap: () {
                              isMute = (_controller?.value.volume ?? 0) > 0;
                              if (isMute) {
                                _controller?.setVolume(0);
                              } else {
                                _controller?.setVolume(1.0);
                              }
                              setState(() {});
                              print(isMute);
                            },
                            child: Image.asset(
                                isMute != true
                                    ? AppImages.volume
                                    : AppImages.noVolume,
                                scale: 2.5)),
                      ],
                    ),
                  ),
                  SizedBox(height: height(context) * 0.03),
                  CustomText(
                      text: widget.cubit!.courseDetailsModel!.data!.name!,
                      fontSize: AppFonts.t7,
                      color: AppColors.navyBlue,
                      fontWeight: FontWeight.bold),
                  SizedBox(height: height(context) * 0.005),
                  SizedBox(
                    height: height(context) * 0.05,
                    child: Row(
                      children: [
                        CustomText(
                            text: widget.cubit!.courseDetailsModel!.data!
                                .teacher!.name!,
                            color: AppColors.goldColor,
                            fontSize: AppFonts.t9),
                        const Spacer(),
                        Row(
                          children: [
                            Image.asset(AppImages.clock,
                                width: width(context) * 0.045),
                            SizedBox(width: width(context) * 0.01),
                            CustomText(
                                text:
                                    "${widget.cubit!.courseDetailsModel!.data!.numHours}",
                                color: AppColors.textFieldColor,
                                fontSize: AppFonts.t10),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: height(context) * 0.015),
                  Image.asset(AppImages.lineWidth),
                  SizedBox(height: height(context) * 0.03),
                  Expanded(
                      child: ListView.separated(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) => Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width(context) * 0.007),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        CustomText(
                                            text: widget
                                                .cubit!
                                                .courseDetailsModel!
                                                .data!
                                                .categories![index]
                                                .name!,
                                            color: AppColors.navyBlue,
                                            fontSize: AppFonts.t8),
                                        const Spacer(),
                                        Row(
                                          children: [
                                            Image.asset(AppImages.clock,
                                                width: width(context) * 0.045),
                                            SizedBox(
                                                width: width(context) * 0.01),
                                            CustomText(
                                                text:
                                                    "${widget.cubit!.courseDetailsModel!.data!.categories![index].timeVideos!}",
                                                color: AppColors.textFieldColor,
                                                fontSize: AppFonts.t10),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(height: height(context) * 0.02),
                                    ListView.separated(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.symmetric(
                                            vertical: height(context) * 0.005,
                                            horizontal: width(context) * 0.01),
                                        shrinkWrap: true,
                                        itemBuilder: (context, idx) => InkWell(
                                              onTap: () {
                                                _initializeAndPlay(widget
                                                    .cubit!
                                                    .courseDetailsModel!
                                                    .data!
                                                    .categories![index]
                                                    .videos![idx]
                                                    .vedIndx!);
                                                // print(widget.cubit!.courseDetailsModel!.model!.courseVideos[idx].id);
                                                // widget.cubit!.data!.categories![index].videos![idx].free==true?
                                                //  _initializeAndPlay(idx) : showDialog(context: context, builder: (context) => const NotPayPopup(),);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: AppColors.whiteColor,
                                                  border: Border.all(
                                                      color: widget
                                                                  .cubit!
                                                                  .courseDetailsModel!
                                                                  .data!
                                                                  .categories![
                                                                      index]
                                                                  .videos![idx]
                                                                  .vedIndx ==
                                                              currentVedio
                                                          ? AppColors.navyBlue
                                                          : Colors.transparent),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                        color: AppColors
                                                            .textFieldColor,
                                                        offset:
                                                            Offset(0.5, 0.5),
                                                        spreadRadius: 0.5,
                                                        blurRadius: 0.5),
                                                  ],
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        height(context) * 0.01,
                                                    horizontal:
                                                        width(context) * 0.015),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width:
                                                          width(context) * 0.1,
                                                      decoration: const BoxDecoration(
                                                          image: DecorationImage(
                                                              image: AssetImage(
                                                                  AppImages
                                                                      .circleNumber))),
                                                      child: Center(
                                                          child: CustomText(
                                                              text:
                                                                  '${widget.cubit!.courseDetailsModel!.data!.categories![index].videos![idx].vedIndx! + 1}',
                                                              color: AppColors
                                                                  .whiteColor,
                                                              fontSize:
                                                                  AppFonts.t8)),
                                                    ),
                                                    SizedBox(
                                                        width: width(context) *
                                                            0.015),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CustomText(
                                                            text: widget
                                                                .cubit!
                                                                .courseDetailsModel!
                                                                .data!
                                                                .categories![
                                                                    index]
                                                                .videos![idx]
                                                                .name!,
                                                            color: AppColors
                                                                .navyBlue,
                                                            fontSize:
                                                                AppFonts.t7),
                                                        Row(
                                                          children: [
                                                            Image.asset(
                                                              AppImages.clock,
                                                              width: width(
                                                                      context) *
                                                                  0.04,
                                                              color: AppColors
                                                                  .textFieldColor,
                                                            ),
                                                            SizedBox(
                                                                width: width(
                                                                        context) *
                                                                    0.01),
                                                            CustomText(
                                                                text: widget
                                                                    .cubit!
                                                                    .courseDetailsModel!
                                                                    .data!
                                                                    .categories![
                                                                        index]
                                                                    .videos![
                                                                        idx]
                                                                    .timeVideo!,
                                                                color: AppColors
                                                                    .textFieldColor,
                                                                fontSize:
                                                                    AppFonts
                                                                        .t10),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    const Spacer(),

                                                    /// -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
                                                    /// -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
                                                    /// -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
                                                    /// -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
                                                    GestureDetector(
                                                      onTap: () {
                                                        print(
                                                            "////////////////////////////");
                                                        _initializeAndPlay(widget
                                                            .cubit!
                                                            .courseDetailsModel!
                                                            .data!
                                                            .categories![index]
                                                            .videos![idx]
                                                            .vedIndx!);
                                                      },
                                                      child: widget
                                                                  .cubit!
                                                                  .courseDetailsModel!
                                                                  .data!
                                                                  .isSubscribed! ||
                                                              widget
                                                                  .cubit!
                                                                  .courseDetailsModel!
                                                                  .data!
                                                                  .categories![
                                                                      index]
                                                                  .videos![idx]
                                                                  .free!
                                                          ? Image.asset(
                                                              AppImages
                                                                  .videosCircle,
                                                              scale: 2.2)
                                                          : Image.asset(
                                                              AppImages
                                                                  .vedioNotFree,
                                                              scale: 3.7),
                                                    ),
                                                    SizedBox(
                                                        width: width(context) *
                                                            0.015),
                                                  ],
                                                ),
                                              ),
                                            ),
                                        separatorBuilder: (context, index) =>
                                            SizedBox(
                                                height:
                                                    height(context) * 0.025),
                                        itemCount: widget
                                            .cubit!
                                            .courseDetailsModel!
                                            .data!
                                            .categories![index]
                                            .videos!
                                            .length)
                                  ],
                                ),
                              ),
                          separatorBuilder: (context, index) =>
                              SizedBox(height: height(context) * 0.02),
                          itemCount: widget.cubit!.courseDetailsModel!.data!.categories!.length)),
                  SizedBox(height: height(context) * 0.02),
                ],
              ),
            ),
    );
  }

  // playView(context) {
  //   final controller = videoPlayerController ;
  //   if (controller != null && controller.value.isInitialized) {
  //     return SizedBox(
  //         height: height(context) * 0.18,
  //         child: VideoPlayer(controller));
  //   } else {
  //     return SizedBox(
  //         height: height(context) * 0.18,
  //         child: const Center(
  //             child: CircularProgressIndicator(color: AppColors.goldColor)));
  //   }
  // }
  //
  // onTapVideo(int index,List<String> videosUrl )async{
  //   final controller = VideoPlayerController.network(videosUrl[index]);
  //   videoPlayerController=controller ;
  //
  //   await  controller..initialize().then((value) {
  //     setState(() {
  //       controller.play();
  //     });
  //
  //   });
  // }
}
