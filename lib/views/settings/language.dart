import 'package:areading/bloc/home/home_cubit.dart';
import 'package:areading/bloc/setting/setting.dart';
import 'package:areading/bloc/setting/setting_states.dart';
import 'package:areading/shared/Helpers/pref.dart';
import 'package:areading/themes/colors.dart';
import 'package:areading/transliations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingCubit, SettingStates>(
        listener: ((context, state) {}),
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: Text(LocaleKeys.lang.tr()),
              ),
              body: ListView.separated(
                  itemBuilder: (context, index) {
                    return listTileBuilder(
                      icon: SettingCubit.get(context).langIcons[index],
                      onTap: () {
                        setState(() {
                          context.setLocale(Locale(SettingCubit.get(context)
                              .langSettingItems[index]));
                          SettingCubit.get(context).langSetting = [
                            'false',
                            'false',
                          ];
                          SettingCubit.get(context).langSetting[index] = 'true';
                          CacheHelper.setStrings('LangSettings',
                              SettingCubit.get(context).langSetting);
                          HomeCubit.get(context).changeMode();
                          SettingCubit.get(context).changeMode();
                        });
                      },
                      text: SettingCubit.get(context).langText[index],
                      selected: SettingCubit.get(context).langSetting[index] ==
                          "true",
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemCount: SettingCubit.get(context).langIcons.length));
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
