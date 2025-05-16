import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:yinzo/core/dio_helper.dart';
import 'package:yinzo/models/logement.dart';

class LogementProvider with ChangeNotifier {
  List<Logement> _logements = [];
  bool _isLoading = false;
  Logement? _logementDetails;
  List _commentsLogement = [];

  List<Logement> get logements => _logements;

  bool get isLoading => _isLoading;

  Logement? get logementDetails => _logementDetails;

  List get commentsLogement => _commentsLogement;

  final Dio dio = DioHelper.getDioInstanceWithBaseUrl();

  Future<void> loadLogements() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await dio.get("logements/");
      _logements =
          (response.data as List)
              .map((item) => Logement.fromJson(item as Map<String, dynamic>))
              .toList();
    } catch (error) {
      print("Erreur: $error");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadLogementDetails({required String logementId}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final responses = await Future.wait([
        dio.get("logement/$logementId/details/"),
        dio.get("load/comments/$logementId/"),
      ]);

      for (int i = 0; i < responses.length; i++) {
        final response = responses[i];

        switch (i) {
          case 0:
            _logementDetails = Logement.fromJson(
              response.data as Map<String, dynamic>,
            );
            break;
          case 1:
            _commentsLogement = response.data as List;
            break;
        }
      }
    } catch (error) {
      debugPrint("Erreur: $error");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> filterByCategory(String slug) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await dio.get("filter/logements-by/category/$slug/");
      _logements =
          (response.data as List)
              .map((item) => Logement.fromJson(item as Map<String, dynamic>))
              .toList();
    } catch (error) {
      debugPrint("Erreur lors du filtrage : $error");
    }

    _isLoading = false;
    notifyListeners();
  }
}
