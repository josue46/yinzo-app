import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:yinzo/core/dio_helper.dart';
import 'package:yinzo/models/logement.dart';

class LogementProvider with ChangeNotifier {
  List<Logement> _logements = [];
  final List<Logement> _allLogements = [];
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
      final response = await Future.wait([
        dio.get("logement/$logementId/details/"),
        dio.get("load/comments/$logementId/"),
      ]);
      for (int i = 0; i < response.length; i++) {
        final res = response[i];

        if (i == 0) {
          _logementDetails = Logement.fromJson(
            res.data as Map<String, dynamic>,
          );
        } else if (i == 1) {
          _commentsLogement = res.data as List;
        }
      }
    } catch (error) {
      print("Erreur: $error");
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
      print("Erreur lors du filtrage : $error");
    }

    _isLoading = false;
    notifyListeners();
  }

  // // Fonction pour filtrer les logements par recherche
  // void setSearchQuery(String query) {
  //   if (query.isEmpty) {
  //     _logements = List.from(_allLogements);
  //   } else {
  //     _logements = _allLogements.where((logement) {
  //       return logement.title.toLowerCase().contains(query.toLowerCase());
  //     }).toList();
  //   }
  //   notifyListeners();
  // }
}
