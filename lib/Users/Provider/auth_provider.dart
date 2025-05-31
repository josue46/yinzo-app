// import 'dart:async';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:yinzo/Services/Auth/auth_service.dart';
// import 'package:yinzo/Services/Dio/dio_service.dart';
// import 'package:yinzo/Services/SecureStorage/secure_storage_service.dart';
// import 'package:yinzo/Users/Model/user_model.dart';

// enum AuthStatus { connected, disconnected }

// class AuthProvider with ChangeNotifier {
//   String? _accessToken;
//   String? _refreshToken;
//   UserData? _userData;
//   bool _isLoading = false;
//   AuthStatus _authStatus = AuthStatus.disconnected;

//   String? get accessToken => _accessToken;
//   String? get refreshToken => _refreshToken;
//   UserData? get userData => _userData;

//   AuthStatus get authStatus => _authStatus;
//   bool get isLoading => _isLoading;

//   final dio = DioService.getDioInstanceWithBaseUrl();
//   final SecureStorageService _secureStorage = SecureStorageService();

//   Future<String?> signup({
//     required String username,
//     required String firstName,
//     required String lastName,
//     required String email,
//     required String password,
//   }) async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       final Map<String, String> data = {
//         "username": username,
//         "first_name": firstName,
//         "last_name": lastName,
//         "email": email,
//         "password": password,
//       };

//       final response = await dio.post(
//         "account/signup/",
//         data: data,
//         options: Options(contentType: 'application/json'),
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return null;
//       } else {
//         return response.data["detail"] ??
//             "Une erreur est survenue lors de la création de votre compte.";
//       }
//     } catch (e) {
//       return "Erreur réseau : $e";
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Connexion de l'utilisateur
//   Future<String?> login({
//     required String username,
//     required String password,
//   }) async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       final response = await dio.post(
//         "account/login/",
//         data: {"username": username, "password": password},
//         options: Options(contentType: "application/json"),
//       );

//       if (response.statusCode == 200) {
//         AuthService authService = AuthService();
//         final token = response.data;

//         _userData = await authService.handleAuthResponse(
//           token as Map<String, dynamic>,
//         );
//         _authStatus = AuthStatus.connected;
//         _accessToken = token["access_token"];
//         _refreshToken = token["refresh_token"];
//         return null;
//       }
//       return response.data["detail"] ?? "Une erreur inconnue s'est produite.";
//     } catch (e) {
//       return "Erreur sur le réseau: $e";
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> loadAccessToken() async {
//     _accessToken = await _secureStorage.readToken("accessToken");
//     if (_accessToken != null) {
//       _authStatus = AuthStatus.connected;
//     } else {
//       _authStatus = AuthStatus.disconnected;
//     }
//     notifyListeners();
//   }

//   // reconnecter l'utilisateur avec le refresh token
//   Future<void> reconnect() async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       _refreshToken = await _secureStorage.readToken("refreshToken");
//       if (_refreshToken == null) {
//         _authStatus = AuthStatus.disconnected;
//         notifyListeners();
//         return;
//       }
//       final response = await dio.post(
//         "account/refresh/token/",
//         data: {"refresh": _refreshToken},
//         options: Options(contentType: "application/json"),
//       );
//       if (response.statusCode == 200) {
//         final token = response.data;
//         _accessToken = token["access_token"];
//         await _secureStorage.saveToken("accessToken", _accessToken!);
//         _authStatus = AuthStatus.connected;
//       } else {
//         _authStatus = AuthStatus.disconnected;
//       }
//     } catch (e) {
//       _authStatus = AuthStatus.disconnected;
//       print("Erreur lors de la reconnexion: $e");
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> loadRefreshToken() async {
//     _refreshToken = await _secureStorage.readToken("refreshToken");
//     if (_refreshToken != null) {
//       _authStatus = AuthStatus.connected;
//     } else {
//       _authStatus = AuthStatus.disconnected;
//     }
//     notifyListeners();
//   }

//   // Déconnexion de l'utilisateur
//   Future<void> logout() async {
//     await _secureStorage.clear();
//     _authStatus = AuthStatus.disconnected;
//     _accessToken = null;
//     _refreshToken = null;
//     notifyListeners();
//   }

//   static AuthProvider of(BuildContext context, {bool listen = true}) {
//     return Provider.of<AuthProvider>(context, listen: listen);
//   }
// }

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart' show JwtDecoder;
import 'package:provider/provider.dart';
import 'package:yinzo/Services/Auth/auth_service.dart';
import 'package:yinzo/Services/Dio/dio_service.dart';
import 'package:yinzo/Services/SecureStorage/secure_storage_service.dart';
import 'package:yinzo/Users/Model/user_model.dart';

enum AuthStatus { connected, disconnected, expired, loading }

class AuthProvider with ChangeNotifier {
  String? _accessToken;
  String? _refreshToken;
  UserData? _userData;
  AuthStatus _authStatus = AuthStatus.disconnected;
  final Dio _dio = DioService.getDioInstanceWithBaseUrl();
  final SecureStorageService _secureStorage = SecureStorageService();
  final AuthService _authService = AuthService();

  // Getters
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  UserData? get userData => _userData;
  AuthStatus get authStatus => _authStatus;
  bool get isLoading => _authStatus == AuthStatus.loading;
  bool get isConnected => _authStatus == AuthStatus.connected;

  Future<void> initialize() async {
    _authStatus = AuthStatus.loading;
    notifyListeners();

    try {
      await _loadTokens();
      if (_accessToken != null) {
        await _loadUserData();
      }
    } finally {
      if (_authStatus == AuthStatus.loading) {
        _authStatus = AuthStatus.disconnected;
      }
      notifyListeners();
    }
  }

  Future<void> _loadTokens() async {
    _accessToken = await _secureStorage.readToken("accessToken");
    _refreshToken = await _secureStorage.readToken("refreshToken");
  }

  Future<void> _loadUserData() async {
    try {
      _userData = await _authService.getCurrentUser(_accessToken);
      if (_userData == null) {
        _authStatus = AuthStatus.disconnected;
        return;
      }
      _authStatus = AuthStatus.connected;
    } catch (e) {
      await _handleInvalidToken();
    }
  }

  Future<String?> signup({
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    _authStatus = AuthStatus.loading;
    notifyListeners();

    try {
      final response = await _dio.post(
        "account/signup/",
        data: {
          "username": username,
          "first_name": firstName,
          "last_name": lastName,
          "email": email,
          "password": password,
        },
        options: Options(contentType: 'application/json'),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return null;
      }
      return response.data["detail"] ?? "Erreur lors de la création du compte";
    } on DioException catch (e) {
      return _handleDioError(e);
    } finally {
      _authStatus = AuthStatus.disconnected;
      notifyListeners();
    }
  }

  Future<String?> login({
    required String username,
    required String password,
  }) async {
    _authStatus = AuthStatus.loading;
    notifyListeners();

    try {
      final response = await _dio.post(
        "account/login/",
        data: {"username": username, "password": password},
        options: Options(contentType: "application/json"),
      );

      if (response.statusCode == 200) {
        await _handleSuccessfulLogin(response.data as Map<String, dynamic>);
        return null;
      }
      return response.data["detail"] ??
          "Nom d'utilisateur ou mot de passe incorrect";
    } on DioException catch (e) {
      return _handleDioError(e);
    } finally {
      if (_authStatus == AuthStatus.loading) {
        _authStatus = AuthStatus.disconnected;
      }
      notifyListeners();
    }
  }

  Future<void> _handleSuccessfulLogin(Map<String, dynamic> tokens) async {
    try {
      _accessToken = tokens["access_token"];
      _refreshToken = tokens["refresh_token"];

      if (_accessToken == null || _refreshToken == null) {
        throw Exception("Tokens manquants dans la réponse");
      }

      // Sauvegarde et chargement des données utilisateur
      await Future.wait([
        _secureStorage.saveToken("accessToken", _accessToken!),
        _secureStorage.saveToken("refreshToken", _refreshToken!),
      ]);

      _userData = await _authService.handleAuthResponse(tokens);

      _authStatus = AuthStatus.connected;
      notifyListeners();
    } catch (e) {
      await _handleInvalidToken();
      rethrow;
    }
  }

  // Pour rafraîchir le token après expiration.
  Future<void> refresh() async {
    if (_refreshToken == null) {
      _authStatus = AuthStatus.disconnected;
      notifyListeners();
      return;
    }

    _authStatus = AuthStatus.loading;
    notifyListeners();

    try {
      final response = await _dio.post(
        "account/token/refresh/",
        data: {"refresh": _refreshToken},
        options: Options(contentType: "application/json"),
      );

      if (response.statusCode == 200) {
        _accessToken = response.data["access_token"];
        await _secureStorage.saveToken("accessToken", _accessToken!);
        _authStatus = AuthStatus.connected;
      } else {
        await _handleInvalidToken();
      }
    } catch (e) {
      await _handleInvalidToken();
    } finally {
      notifyListeners();
    }
  }

  Future<String?> getValidToken() async {
    if (_accessToken == null) return null;

    if (!JwtDecoder.isExpired(_accessToken!)) {
      return _accessToken;
    }

    if (_refreshToken == null) {
      _authStatus = AuthStatus.expired;
      notifyListeners();
      return null;
    }

    try {
      await refresh();
      return _accessToken;
    } catch (e) {
      await _handleInvalidToken();
      return null;
    }
  }

  Future<void> _handleInvalidToken() async {
    await _secureStorage.clear();
    _accessToken = null;
    _refreshToken = null;
    _userData = null;
    _authStatus = AuthStatus.disconnected;
    notifyListeners();
  }

  Future<void> logout() async {
    // _authStatus = AuthStatus.loading;
    // notifyListeners();
    await _handleInvalidToken();

    // try {
    //   await _dio.post(
    //     "account/logout/",
    //     options: Options(headers: {"Authorization": "Bearer $_accessToken"}),
    //   );
    // } finally {
    //   await _handleInvalidToken();
    // }
  }

  String _handleDioError(DioException e) {
    if (e.response != null) {
      return e.response?.data["detail"] ?? "Erreur serveur";
    }
    return "Erreur réseau: ${e.message}";
  }

  static AuthProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<AuthProvider>(context, listen: listen);
  }
}
