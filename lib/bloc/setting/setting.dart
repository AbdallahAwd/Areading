import 'package:areading/bloc/setting/setting_states.dart';
import 'package:areading/shared/Helpers/pref.dart';
import 'package:areading/views/log/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../transliations/locale_keys.g.dart';

class SettingCubit extends Cubit<SettingStates> {
  SettingCubit() : super(InitailState());

  static SettingCubit get(context) => BlocProvider.of(context);

  ///get user data
  late UserModel model;
  List<Icon> icons = const [
    Icon(Icons.language_outlined),
    Icon(Icons.dark_mode),
    Icon(Icons.light_mode),
  ];
  List<Icon> langIcons = const [
    Icon(Icons.abc),
    Icon(Icons.area_chart),
  ];
  List<String> text = [
    LocaleKeys.system_mode.tr(),
    LocaleKeys.dark.tr(),
    LocaleKeys.light.tr(),
  ];
  List<String> text2Save = [
    'System',
    'Dark',
    'Light',
  ];
  List<String> langText = ["English", "العربية"];
  late List<String> darkSetting;
  void getDarkSetting() async {
    darkSetting = await CacheHelper.getStrings('DarkSettings') ??
        [
          'false',
          'false',
          'true',
        ];
  }

  List<String> langSettingItems = [
    'en',
    'ar',
  ];
  late List<String> langSetting;
  void getLangSetting() async {
    langSetting = await CacheHelper.getStrings('LangSettings') ??
        [
          'false',
          'false',
        ];
  }

  void changeMode() {
    emit(ChangeLang());
  }

  void getUserData() {
    emit(GetUserLoading());
    FirebaseFirestore.instance
        .collection('users')
        .doc(CacheHelper.getData(key: 'uid'))
        .get()
        .then((value) {
      model = UserModel.fromJson(value.data()!);
      emit(GetUserSuccess());
    }).catchError((onError) {
      emit(GetUserError());
    });
  }

  void updateNameOrPassword(
    String name,
    String email,
  ) {
    model = UserModel(
        name: name.trim(),
        email: email.trim(),
        uid: CacheHelper.getData(key: 'uid'));
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(CacheHelper.getData(key: 'uid'))
          .update(model.toJson());
      emit(UpdateUserSuccess());
    } catch (e) {
      emit(UpdateUserError());
    }
  }

  void resetPassword(String email) {
    try {
      FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      emit(UpdateUserSuccess());
    } catch (e) {
      emit(UpdateUserError());
    }
  }
}
