import 'package:areading/shared/constant.dart';
import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;
  static late Dio extDio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://www.googleapis.com/books/v1',
        receiveDataWhenStatusError: true,
      ),
    );
    extDio = Dio(
      BaseOptions(
        baseUrl: 'https://api.api-ninjas.com/v1/imagetotext',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
    };

    return await dio.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    required String url,
    required var data,
    Map<String, dynamic>? query,
  }) async {
    extDio.options.headers = {
      'Content-Type': 'application/json',
      'X-Api-Key': TEXT_EXTRACTOR_API,
    };

    return extDio.post(
      url,
      queryParameters: query,
      data: data,
    );
  }

  static Future<Response> putData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
    };

    return dio.put(
      url,
      queryParameters: query,
      data: data,
    );
  }
}
