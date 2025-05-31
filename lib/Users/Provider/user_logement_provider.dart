import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:yinzo/Logements/Models/logement.dart';
import 'package:yinzo/Services/Dio/dio_service.dart';

class UserLogementProvider with ChangeNotifier {
  // This class is used to manage user logement data
  List<Logement> _logements = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<Logement> get logements => _logements;

  Future<void> fetchLogements(String token) async {
    _isLoading = true;
    notifyListeners();

    // Fetch logements from the API
    Dio client = DioService.getDioInstanceWithBaseUrl();
    try {
      final response = await client.get(
        'user/logements/',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        _logements =
            (response.data as List)
                .map(
                  (logement) =>
                      Logement.fromJson(logement as Map<String, dynamic>),
                )
                .toList();
      } else {
        throw Exception(
          'Le chargement des logements a échoué avec le code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching logements: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void removeLogement(Logement logement) {
    _logements.remove(logement);
    notifyListeners();
  }
}
