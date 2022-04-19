import 'package:areading/bloc/log/login_states.dart';
import 'package:areading/shared/Helpers/pref.dart';
import 'package:areading/views/log/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(InitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  void logIn({required String email, required String password}) async {
    emit(LoginStateLoading());
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: email.trim(), password: password.trim())
        .then((value) async {
      await CacheHelper.saveData(key: 'uid', value: value.user!.uid);

      emit(LoginStateSuccess());
    }).catchError((onError) {
      emit(LoginStateError(onError.toString()));
    });
  }

  void signIn(
      {required String email,
      required String password,
      required String name}) async {
    emit(LoginStateLoading());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: email.trim(), password: password.trim())
        .then((value) async {
      await CacheHelper.saveData(key: 'uid', value: value.user!.uid);
      saveUserData(uid: value.user!.uid, email: email, name: name);
      emit(LoginStateSuccess());
    }).catchError((onError) {
      emit(LoginStateError(onError.toString()));
    });
  }

  String? uid;
  final googleSignin = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;
  Future googleLogIn() async {
    try {
      final googleUser = await googleSignin.signIn();
      if (googleUser == null) return;
      _user = googleUser;
      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      uid = _user!.id;
      await CacheHelper.saveData(key: 'uid', value: uid);
      saveUserData(email: user.email, name: user.displayName!, uid: user.id);
      emit(LoginStateSuccess());
    } catch (e) {
      emit(LoginStateError(e.toString()));
    }
  }

  UserModel? userModel;
  void saveUserData({
    required String uid,
    required String email,
    required String name,
  }) {
    userModel = UserModel(
      email: email,
      name: name,
      uid: uid,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(userModel!.toJson())
        .then((value) {})
        .catchError((onError) {
      emit(SaveUserDataError(onError.toString()));
    });
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    await CacheHelper.removeData('uid');
    emit(LogoutStateSuccess());
  }

  Future logout() async {
    await googleSignin.disconnect();
    await CacheHelper.removeData('uid');
    FirebaseAuth.instance.signOut();
    emit(LogoutStateSuccess());
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
