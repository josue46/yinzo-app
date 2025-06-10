import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:yinzo/Services/SecureStorage/secure_storage_service.dart';
import 'package:yinzo/Users/Model/user_model.dart';

class AuthService {
  final SecureStorageService _secureStorage = SecureStorageService();

  Future<UserData?> handleAuthResponse(Map<String, dynamic> tokens) async {
    try {
      final accessToken = tokens["access_token"];
      final refreshToken = tokens["refresh_token"];

      final userData = _decodeAndExtractUserData(accessToken);
      await _saveTokens(accessToken, refreshToken);

      return userData;
    } catch (e) {
      await _secureStorage.clear();
      rethrow;
    }
  }

  UserData _decodeAndExtractUserData(String token) {
    final payload = decodeToken(token);
    print(payload);
    return UserData.fromToken(payload);
  }

  Map<String, dynamic> decodeToken(String token) {
    if (!JwtDecoder.isExpired(token)) {
      return JwtDecoder.decode(token);
    }
    throw Exception("Token expiré");
  }

  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    await Future.wait([
      _secureStorage.saveToken("accessToken", accessToken),
      _secureStorage.saveToken("refreshToken", refreshToken),
    ]);
    print("Token sauvegardé");
  }

  Future<UserData?> getCurrentUser(token) async {
    // final token = await _secureStorage.readToken("accessToken");
    if (token != null) {
      try {
        return _decodeAndExtractUserData(token);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  Future<bool> isTokenValid() async {
    final token = await _secureStorage.readToken("accessToken");
    return token != null && !JwtDecoder.isExpired(token);
  }

  Future<void> activateTemporaryUserAccount(String userId, Dio dio) async {
    try {
      final _ = await dio.post(
        'account/activate-temporary-account/',
        data: {'user_id': userId},
      );
    } catch (e) {
      print("Erreur lors de l'activation du compte temporaire : $e");
      throw Exception("Échec de l'activation du compte temporaire");
    }
  }

  Future<void> deactivateTemporaryUserAccount(String userId, Dio dio) async {
    try {
      final _ = await dio.post(
        'account/deactivate-temporary-account/',
        data: {'user_id': userId},
      );
    } catch (e) {
      print("Erreur lors de la désactivation du compte temporaire : $e");
      throw Exception("Échec de la désactivation du compte temporaire");
    }
  }
}
