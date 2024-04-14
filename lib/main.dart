import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fcm_config/fcm_config.dart';
import 'package:private_courses/bloc_observer.dart';
import 'package:private_courses/components/noInterNet.dart';
import 'package:private_courses/screens/common/btnNavBar/controller/custom_btn_nav_bar_cubit.dart';
import 'package:private_courses/screens/common/splash/splash_view.dart';
import 'package:private_courses/shared/local/cache_helper.dart';
import 'components/style/colors.dart';




Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
// If you're going to use other Firebase services in the background, such as Firestore,
// make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  importance: Importance.high,
  'high_importance_channel', // id
  'High Importance Notifications', // title
  // 'importance: Importance.high',
);

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: AppColors.navyBlue,
      )
  );
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  Bloc.observer = MyBlocObserver();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true
  );

  /// app in backGround
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print(event.data.toString());
    // customToast(title: event.notification!.body.toString());
    print('onMessage  App');
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(
      EasyLocalization(
          useOnlyLangCode: true,
          supportedLocales: const [Locale('en'), Locale('ar')],
          startLocale: const Locale('ar'),
          path: 'assets/translations',
          fallbackLocale: const Locale('ar'),
          child: MyApp()
      )
  );
}

class MyApp extends StatefulWidget {

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  ConnectivityResult? _connectivityResult;
  late StreamSubscription connectivitySubscription;
  final navigatorKey = GlobalKey<NavigatorState>();
  bool isOpened = false;
  void initState() {
    super.initState();
    FirebaseMessaging.instance.requestPermission();
    var initialzationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializationSettings =
    InitializationSettings(android: initialzationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                '${channel.name}'
                    "'your channel id', 'your channel name'",
                channel.id,
                // channel.name,
                color: Colors.red,
                icon: "@mipmap/launcher_icon",

              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                  title: Text(notification.title.toString()),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text(notification.body.toString())],
                    ),
                  )
              );
            });
      }
    });

    ///-*-///
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      print('Current connectivity status: $result');
      setState(() {
        _connectivityResult = result;
        print('changed print 1' + _connectivityResult.toString());
      });
      if (_connectivityResult == ConnectivityResult.none) {
        _connectivityResult == ConnectivityResult.none
            ? showDialog(
            barrierDismissible: false,
            context: navigatorKey.currentContext!,
            builder: (_) {
              isOpened = true;
              print('changed print 2' + _connectivityResult.toString());
              print('isOpened value 1' + isOpened.toString());
              return NoInternetDialog();
            })
            : null;
        print('isOpened value 1' + isOpened.toString());
      } else if (isOpened) {
        setState(() {
          isOpened = false;
        });
        Navigator.pop(navigatorKey.currentContext!);
        print('isOpened value 2' + isOpened.toString());
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CustomBtnNavBarCubit()),
      ],
      child: MaterialApp(
          navigatorKey: navigatorKey,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          title: 'دروس خصوصية',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: "STC", scaffoldBackgroundColor: AppColors.whiteColor),
          home:  SplashScreen()),
    );
  }
}
