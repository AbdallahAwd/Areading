import 'package:easy_localization/easy_localization.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/heighlight/heighlight_bloc.dart';
import '../../bloc/home/home_cubit.dart';
import '../../bloc/home/home_states.dart';
import '../../bloc/log/login_cubit.dart';
import '../../bloc/setting/setting.dart';
import '../../shared/Helpers/pref.dart';
import '../../themes/colors.dart';
import '../Home/home_layer.dart';
import '../log/welcome.dart';

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
}
