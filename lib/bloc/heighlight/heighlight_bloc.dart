import 'package:areading/bloc/heighlight/heigh_state.dart';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/Helpers/pref.dart';
import '../../shared/components/components.dart';
import '../../views/heighlights/models/add.dart';

class HeighCubit extends Cubit<HeighState> {
  HeighCubit() : super(InistalState());
  static HeighCubit get(context) => BlocProvider.of(context);
  //copy heighlight text
  void copy(String copy, context) {
    FlutterClipboard.copy(copy).then((value) {
      toast(text: 'Copied');
      pop(context);
    });
  }

  List<AddHeighLight> getAdded = [];
  List<String> txt = [];
  List<String> bookName = [];
  List<String> bookImage = [];
  List<String> getAddedId = [];
  void getAdd() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(CacheHelper.getData(key: 'uid'))
        .collection('heighlights')
        .snapshots()
        .listen((event) {
      getAdded = [];
      getAddedId = [];
      for (var element in event.docs) {
        getAddedId.add(element.id);
        txt.add(element['text']);
        bookName.add(element['bookname']);
        bookImage.add(element['bookimage']);
        getAdded.add(AddHeighLight.fromJson(element.data()));
      }

      emit(GetSuccess());
    });
  }

  AddHeighLight? updatedHeighLight;
  void updateHeighLight(
    String updatedId, {
    bookauthor,
    bookimage,
    bookname,
    date,
    required String text,
  }) {
    updatedHeighLight = AddHeighLight(
        bookauthor: bookauthor,
        bookimage: bookimage,
        bookname: bookname,
        date: date,
        text: text);
    FirebaseFirestore.instance
        .collection('users')
        .doc(CacheHelper.getData(key: 'uid'))
        .collection('heighlights')
        .doc(updatedId)
        .update(updatedHeighLight!.toJson())
        .then((value) {
      emit(UpdateSuccess());
    }).catchError((onError) {
      emit(UpdateError());
    });
  }

  void deleteHeighLight(
    String deletedId,
  ) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(CacheHelper.getData(key: 'uid'))
        .collection('heighlights')
        .doc(deletedId)
        .delete()
        .then((value) {
      emit(DeletedSuccess());
    }).catchError((onError) {
      emit(DeletedError());
    });
  }
}
