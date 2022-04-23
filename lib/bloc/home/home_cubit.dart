import 'dart:math';
import 'package:areading/views/Books/books.dart';
import 'package:areading/views/Books/model/book_model.dart';
import 'package:areading/views/heighlights/heighlights.dart';
import 'package:areading/views/review/review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import '../../shared/Helpers/dio.dart';
import '../../shared/Helpers/pref.dart';
import '../../shared/components/components.dart';
import '../../shared/constant.dart';
import '../../themes/colors.dart';
import '../../views/heighlights/models/add.dart';
import '../../views/settings/settings.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(InitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  int floatIndex = 0;
  List<String> recentSearch = [];
  void getHistory() async {
    recentSearch = await CacheHelper.getStrings('search') ?? [];
    emit(ChangeDrop());
  }

  List<String> booksKeys = [
    'how to earn كسب',
    'the seven سبع',
    'the power قوه',
    'thinking fast and slow',
    'Atomic الذريه habits',
    'the 4 hour ',
    'The 48 L قانون law',
    'who moved تحرك',
    'rich dad القوة',
    "Business الاعمال",
    "heighly فاعليه",
    "secret سر",
    'rich غني',
    'art of فن',
    'the magic thinking سحر',
    "Quiet:  introverts الانطوائيين",
    "the richest اغني",
    'life',
    'habits',
    "فن",
    "brain عقلك",
    'How to Stop Worrying',
    "harry potter",
    "mindset",
    "the lucifer",
    "outliers",
    "sway",
    "Power of now",
    "you are bad",
    "deep work",
    "eat that frog",
    "5 love lang"
  ];
  void changeIndex(int indexa) {
    index = indexa;
    emit(LightMode());
  }

  void changeLang() {
    emit(LightMode());
  }

  List<Widget> screens = [
    const Review(),
    const HeighLights(key: Key('heigh')),
    const Books(),
    const Setting()
  ];

  late bool hasInternet;
  void checkConnection() async {
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    hasInternet = connectivityResult != ConnectivityResult.none;
  }

  void changeFloatindex(int index) {
    floatIndex = index;

    emit(ChangeFloatIndex());
  }

  //recognization_google_kit
  String scannedText = '';

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        FormData formData = FormData.fromMap({
          "image": await MultipartFile.fromFile(pickedImage.path,
              filename: pickedImage.path.split('/').last,
              contentType: MediaType('image', 'png')),
          "type": "image/png"
        });

        emit(TextRecognizationLoading());
        // getRecognisedText(pickedImage);
        extractImageText(formData);
      }
    } catch (e) {
      scannedText = "Error occured while scanning";
      emit(TextRecognizationError());
    }
  }

  // void getRecognisedText(XFile image) async {
  //   final inputImage = InputImage.fromFilePath(image.path);
  //   final textDetector = GoogleMlKit.vision.textDetector();
  //   RecognisedText recognisedText = await textDetector.processImage(inputImage);
  //   await textDetector.close();
  //   scannedText = "";
  //   for (TextBlock block in recognisedText.blocks) {
  //     for (TextLine line in block.lines) {
  //       scannedText = scannedText + line.text + '\n';
  //     }
  //   }
  //   // textScanning = false;
  //   emit(TextRecognizationSuccess());
  // }

  //all book api methods
  BookModel? bookModel;
  int limit = 6;
  void getTopBooks() async {
    emit(GetBooksLoading());
    await DioHelper.getData(url: '/volumes', query: {
      'q': booksKeys[Random().nextInt(booksKeys.length - 1)],
      'key': APIKEY,
      'maxResults': limit,
      'printType': 'books'
    }).then((value) {
      bookModel = BookModel.fromJson(value.data);
      emit(GetBooksSuccess());
    }).catchError((onError) {
      emit(GetBooksError());
    });
  }

  BookModel? bookModel2;
  void getRandomBooks() async {
    emit(GetBooksLoading());
    await DioHelper.getData(url: '/volumes', query: {
      'q': booksKeys[Random().nextInt(booksKeys.length - 1)],
      'key': APIKEY,
      'maxResults': limit,
      'printType': 'books'
    }).then((value) {
      bookModel2 = BookModel.fromJson(value.data);
      emit(GetBooksSuccess());
    }).catchError((onError) {
      emit(GetBooksError());
    });
  }

  BookModel? searchModel;
  void getSearchBooks(String searchedBook) async {
    emit(GetBooksLoading());
    await DioHelper.getData(url: '/volumes', query: {
      'q': searchedBook,
      'key': APIKEY,
      'maxResults': 5,
      'printType': 'books'
    }).then((value) {
      searchModel = BookModel.fromJson(value.data);
      emit(GetBooksSuccess());
    }).catchError((onError) {
      emit(GetBooksError());
    });
  }

  // text extractor api
  List<String> strings = [];
  void extractImageText(data) async {
    await DioHelper.postData(url: '/', data: data).then((value) {
      strings = [];
      for (var i = 0; i < value.data.length; i++) {
        strings.add(value.data[i]['text']);
      }
      print(strings);
      scannedText = strings.join(' ');
      emit(TextRecognizationSuccess());
    }).catchError((onError) {
      print('Error $onError');
      emit(TextRecognizationError());
    });
  }

  //firebase methods

  String? bookName;
  String? bookImage;
  String? bookAuthor;
  AddHeighLight? add;

  void addHeighLight({
    required String text,
  }) async {
    if (bookAuthor == null || bookImage == null || bookName == null) {
      emit(AddError());
      throw Exception('some variables are null');
    }
    add = AddHeighLight(
      bookauthor: bookAuthor,
      date: formattedDate(),
      bookimage: bookImage,
      bookname: bookName,
      text: text,
    );
    emit(AddLoading());

    await FirebaseFirestore.instance
        .collection('users')
        .doc(CacheHelper.getData(key: 'uid'))
        .collection('heighlights')
        .add(add!.toJson())
        .then((value) {
      bookAuthor = null;
      bookName = null;
      bookImage = null;
      emit(AddSuccess());
    }).catchError((onError) {
      emit(AddError());
    });
  }

  void changeMode() {
    if (CacheHelper.getData(key: 'isDark') == null ||
        CacheHelper.getData(key: 'isDark') == 'System') {
      emit(SystemMode());
    } else if (CacheHelper.getData(key: 'isDark') == 'Dark') {
      emit(DarkMode());
    } else {
      emit(LightMode());
    }
  }
}
