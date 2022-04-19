import 'package:areading/bloc/setting/setting_states.dart';
import 'package:areading/shared/Helpers/pref.dart';
import 'package:areading/views/log/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingCubit extends Cubit<SettingStates> {
  SettingCubit() : super(InitailState());

  static SettingCubit get(context) => BlocProvider.of(context);

  ///get user data
  late UserModel model;
  void changeLang() {
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
