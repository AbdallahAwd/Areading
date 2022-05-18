import 'package:areading/shared/Helpers/dio.dart';
import 'package:areading/shared/Helpers/pref.dart';
import 'package:areading/shared/notifications/awsome_no.dart';
import 'package:areading/themes/colors.dart';
import 'package:areading/views/App/app.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
    statusBarColor: Colors.black12,
    statusBarIconBrightness: Brightness.light,
  ));
  index = CacheHelper.getData(key: 'index') ?? 0;
  String? uid = CacheHelper.getData(key: 'uid');
  await NotificationApi.init();
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
