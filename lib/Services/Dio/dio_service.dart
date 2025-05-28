import 'package:dio/dio.dart';

class DioService {
  static const String _baseUrl = "http://192.168.32.146:8000/api/";

  // getter for to get baseUrl
  static String get baseUrl => _baseUrl;

  static Dio getDioInstanceWithBaseUrl() {
    Dio dio = Dio(BaseOptions(baseUrl: _baseUrl));
    return dio;
  }

  Dio putTokenInHeader(String token) {
    final dio = DioService.getDioInstanceWithBaseUrl();
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
