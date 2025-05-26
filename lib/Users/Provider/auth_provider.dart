import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yinzo/Services/Dio/dio_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  final dio = DioService.getDioInstanceWithBaseUrl();

  Future<String?> signup({
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final formData = FormData.fromMap({
        "username": username,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "password": password,
      });

      final response = await dio.post(
        "account/signup/",
        data: formData,
        options: Options(contentType: 'application/json'),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return null;
      } else {
        return response.data["detail"] ?? "Une erreur est survenue";
      }
    } catch (e) {
      return "Erreur réseau : $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> login({
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    final data = FormData.fromMap({"username": username, "password": password});

    try {
      final response = await dio.post(
        "account/login/",
        data: data,
        options: Options(contentType: "application/json"),
      );

      if (response.statusCode == 200) {
        final SharedPreferences instance =
            await SharedPreferences.getInstance();
        await Future.wait([
          instance.setString("accessToken", response.data["access_token"]),
          instance.setString("refreshToken", response.data["refresh_token"]),
        ]);

        return null;
      }
      print(response.data["detail"]);
      return response.data["detail"] ?? "Une erreur inconnue s'est produite.";
    } catch (e) {
      return "Erreur sur le réseau: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  static AuthProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<AuthProvider>(context, listen: listen);
  }
}
