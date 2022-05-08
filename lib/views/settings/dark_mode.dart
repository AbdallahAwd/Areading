import 'package:areading/bloc/setting/setting.dart';
import 'package:areading/bloc/setting/setting_states.dart';
import 'package:areading/themes/colors.dart';
import 'package:areading/transliations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/home/home_cubit.dart';
import '../../shared/Helpers/pref.dart';

class DarkModeScreen extends StatefulWidget {
  const DarkModeScreen({Key? key}) : super(key: key);

  @override
  _DarkModeScreenState createState() => _DarkModeScreenState();
}

class _DarkModeScreenState extends State<DarkModeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingCubit, SettingStates>(
        listener: ((context, state) {}),
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: Text(LocaleKeys.dark_mode.tr()),
              ),
              body: ListView.separated(
                  itemBuilder: (context, index) {
                    return listTileBuilder(
                      icon: SettingCubit.get(context).icons[index],
                      onTap: () {
                        setState(() {
                          CacheHelper.saveData(
                              key: 'isDark',
                              value:
                                  SettingCubit.get(context).text2Save[index]);
                          SettingCubit.get(context).darkSetting = [
                            'false',
                            'false',
                            'false',
                          ];
                          SettingCubit.get(context).darkSetting[index] = 'true';
                        });
                        HomeCubit.get(context).changeMode();
                        CacheHelper.setStrings('DarkSettings',
                            SettingCubit.get(context).darkSetting);
                      },
                      text: SettingCubit.get(context).text[index],
                      selected: SettingCubit.get(context).darkSetting[index] ==
                          "true",
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemCount: SettingCubit.get(context).icons.length));
        });
  }

  Widget listTileBuilder(
      {required Icon icon,
      required String text,
      bool selected = false,
      var onTap}) {
    return ListTile(
      onTap: onTap,
      leading: icon,
      selected: selected,
      selectedColor: mainColor[index],
      title: Text(text),
    );
  }
}
