import 'package:areading/bloc/home/home_states.dart';
import 'package:areading/bloc/setting/setting.dart';
import 'package:areading/shared/Helpers/dio.dart';
import 'package:areading/shared/Helpers/pref.dart';
import 'package:areading/themes/colors.dart';
import 'package:areading/views/Home/home_layer.dart';
import 'package:areading/views/log/welcome.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/heighlight/heighlight_bloc.dart';
import 'bloc/home/home_cubit.dart';
import 'bloc/log/login_cubit.dart';
import 'bloc_observer.dart';
import 'transliations/codegen_loader.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebasePushHandler);
  await CacheHelper.init();
  await EasyLocalization.ensureInitialized();
  await CacheHelper.removeData('isshown');
  DioHelper.init();
  index = CacheHelper.getData(key: 'index') ?? 0;
  String? uid = CacheHelper.getData(key: 'uid');
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'Areading',
        channelName: 'AreadingReminder',
        channelDescription: 'Notification channel for Light Azkar',
        defaultColor: mainColor[index],
        ledColor: Colors.white,
        playSound: true,
        enableLights: true,
        enableVibration: true,
      ),
    ],
  );
  BlocOverrides.runZoned(
    () {
      runApp(
        EasyLocalization(
            supportedLocales: const [Locale('en'), Locale('ar')],
            path: 'assets/lang', // <-- change the path of the translation files
            assetLoader: const CodegenLoader(),
            fallbackLocale: const Locale('en'),
            child: MyApp(uid)),
      );
    },
    blocObserver: MyBlocObserver(),
  );
}

Future<void> _firebasePushHandler(RemoteMessage message) async {
  AwesomeNotifications().createNotificationFromJsonData(message.data);
}

class MyApp extends StatelessWidget {
  final String? uid;
  const MyApp(this.uid, {Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => LoginCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => HomeCubit()
            ..getRandomBooks()
            ..getTopBooks()
            ..getHistory()
            ..checkConnection(),
        ),
        BlocProvider(
          create: (BuildContext context) => HeighCubit()..getAdd(),
        ),
        BlocProvider(
          create: (BuildContext context) => SettingCubit()
            ..getUserData()
            ..getDarkSetting()
            ..getLangSetting(),
        ),
      ],
      child: BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return FeatureDiscovery(
            child: MaterialApp(
              title: 'Areading',
              debugShowCheckedModeBanner: false,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              theme: ThemeData.light().copyWith(
                scaffoldBackgroundColor: Colors.white,
                appBarTheme: AppBarTheme(
                    elevation: 0.0,
                    color: Colors.white,
                    centerTitle: true,
                    iconTheme: const IconThemeData(color: Colors.black),
                    actionsIconTheme: const IconThemeData(color: Colors.black),
                    titleTextStyle:
                        TextStyle(color: mainColor[index], fontSize: 20)),
              ),
              darkTheme: ThemeData.dark().copyWith(
                scaffoldBackgroundColor: const Color(0xff141616),
                appBarTheme: AppBarTheme(
                    elevation: 0.0,
                    color: const Color(0xff141616),
                    centerTitle: true,
                    iconTheme: const IconThemeData(color: Colors.white),
                    actionsIconTheme: const IconThemeData(color: Colors.white),
                    titleTextStyle:
                        TextStyle(color: mainColor[index], fontSize: 20)),
              ),
              themeMode: CacheHelper.getData(key: 'isDark') != 'System'
                  ? CacheHelper.getData(key: 'isDark') == 'Dark'
                      ? ThemeMode.dark
                      : ThemeMode.light
                  : ThemeMode.system,
              home: uid == null ? const Welcome() : const HomeLayer(),
            ),
          );
        },
      ),
    );
  }

  ThemeMode mode() {
    if (CacheHelper.getData(key: 'isDark') == 'System' ||
        CacheHelper.getData(key: 'isDark') == null) {
      return ThemeMode.system;
    } else if (CacheHelper.getData(key: 'isDark') == 'Dark') {
      return ThemeMode.dark;
    } else {
      return ThemeMode.light;
    }
  }
}
