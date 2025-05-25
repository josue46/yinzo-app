import 'package:dio/dio.dart';

class DioHelper {
  static const String _baseUrl = "http://127.0.0.1:8000/api/";

  // getter for to get baseUrl
  static String get baseUrl => _baseUrl;

  static Dio getDioInstanceWithBaseUrl() {
    Dio dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 3),
        sendTimeout: const Duration(seconds: 3),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );
    return dio;
  }

  Dio putTokenInHeader(String token) {
    final dio = DioHelper.getDioInstanceWithBaseUrl();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers["Authorization"] = "Bearer $token";
          handler.next(options);
        },
      ),
    );
    return dio;
  }
}
