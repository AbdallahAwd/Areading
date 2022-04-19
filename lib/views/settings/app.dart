import 'package:areading/bloc/home/home_cubit.dart';
import 'package:areading/bloc/setting/setting.dart';
import 'package:areading/bloc/setting/setting_states.dart';
import 'package:areading/shared/Helpers/pref.dart';
import 'package:areading/shared/components/components.dart';
import 'package:areading/themes/colors.dart';
import 'package:areading/views/log/welcome.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../../transliations/locale_keys.g.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingCubit, SettingStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: Text(LocaleKeys.dark_mode.tr()),
                trailing: DropdownButtonHideUnderline(
                  child: Container(
                    width: 120,
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.5), width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: DropdownButton<String>(
                      // value: value ?? 'Lang',
                      hint: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: AutoSizeText(LocaleKeys.system_mode.tr()),
                      ),
                      items: [
                        DropdownMenuItem(
                          child: Text(LocaleKeys.system_mode.tr()),
                          value: 'System',
                        ),
                        DropdownMenuItem(
                          child: Text(LocaleKeys.dark.tr()),
                          value: 'Dark',
                        ),
                        DropdownMenuItem(
                          child: Text(LocaleKeys.light.tr()),
                          value: 'Light',
                        ),
                      ],
                      onChanged: (String? val) {
                        setState(() {
                          CacheHelper.saveData(key: 'isDark', value: val!);
                        });
                        HomeCubit.get(context).changeMode();
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(LocaleKeys.lang.tr()),
                trailing: DropdownButtonHideUnderline(
                  child: Container(
                    width: 120,
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.5), width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: DropdownButton<String>(
                      // value: value ?? 'Lang',
                      hint: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: AutoSizeText(LocaleKeys.lang.tr()),
                      ),
                      items: const [
                        DropdownMenuItem(
                          child: Text('English'),
                          value: 'English',
                        ),
                        DropdownMenuItem(
                          child: Text('العربية'),
                          value: 'Arabic',
                        ),
                      ],
                      onChanged: (String? val) {
                        if (val == 'Arabic') {
                          context.setLocale(const Locale('ar'));
                        } else {
                          context.setLocale(const Locale('en'));
                        }
                        HomeCubit.get(context).changeLang();
                      },
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.color_lens),
                title: Text(LocaleKeys.theme.tr()),
                onTap: () {
                  Dialog themeDialog = Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(LocaleKeys.change_theme.tr(),
                              style: const TextStyle(fontSize: 18)),
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: SizedBox(
                              height: 60,
                              child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, indexa) => InkWell(
                                        onTap: () {
                                          HomeCubit.get(context)
                                              .changeIndex(indexa);
                                          CacheHelper.saveData(
                                              key: 'index', value: indexa);
                                          pop(context);
                                        },
                                        child: Container(
                                          width: 50,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: mainColor[indexa]),
                                        ),
                                      ),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(width: 10),
                                  itemCount: mainColor.length),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                  showDialog(
                      context: context, builder: (context) => themeDialog);
                },
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: AutoSizeText(LocaleKeys.clear_tile.tr()),
                onTap: () {
                  Dialog dialog = Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            LocaleKeys.ensure.tr(),
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            LocaleKeys.ensure_dis.tr(),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              defaultButton(
                                  colors: Colors.transparent,
                                  width: 70,
                                  fontSize: 12,
                                  borderRadius: 8,
                                  height: 30,
                                  onPressed: () {
                                    pop(context);
                                  },
                                  textButton: LocaleKeys.cancel.tr()),
                              defaultButton(
                                  colors: mainColor[index],
                                  width: 70,
                                  fontSize: 12,
                                  borderRadius: 8,
                                  height: 30,
                                  onPressed: () {
                                    CacheHelper.removeData(
                                      'search',
                                    );
                                    HomeCubit.get(context).recentSearch = [];
                                    pop(context);
                                  },
                                  textButton: LocaleKeys.clear.tr()),
                            ],
                          )
                        ],
                      ),
                    ),
                  );

                  showDialog(context: context, builder: (context) => dialog);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(LocaleKeys.logout.tr()),
                onTap: () {
                  CacheHelper.removeData('uid');
                  navigateAndRemove(
                      context, PageTransitionType.leftToRight, const Welcome());
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
