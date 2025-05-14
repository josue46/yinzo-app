import 'package:dio/dio.dart';

class DioHelper {
  static const String _baseUrl = "http://127.0.0.1:8000/api/";

  // getter for to get baseUrl
  static String get baseUrl => _baseUrl;

  static Dio getDioInstanceWithBaseUrl({String? token}) {
    Dio dio = Dio(BaseOptions(baseUrl: _baseUrl));

    // if the token is provided, it is added in the headers.
    if (token != null) {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            options.headers["Authorizations"] = "Bearer $token";
            handler.next(options);
          },
        ),
      );
    }
    return dio;
  }
}
