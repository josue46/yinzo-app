import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:yinzo/Logements/Models/logement.dart';
import 'package:yinzo/Services/Dio/dio_service.dart';

class LogementProvider with ChangeNotifier {
  List<Logement> _logements = [];
  bool _isLoading = false;
  Logement? _logementDetails;
  List _commentsLogement = [];

  List<Logement> get logements => _logements;

  bool get isLoading => _isLoading;

  Logement? get logementDetails => _logementDetails;

  List get commentsLogement => _commentsLogement;

  final Dio _dio = DioService.getDioInstanceWithBaseUrl();

  Future<void> loadLogements() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _dio.get("logements/");
      if (response.statusCode == 200) {
        _logements =
            (response.data as List)
                .map((item) => Logement.fromJson(item as Map<String, dynamic>))
                .toList();
      }
    } catch (error) {
      print("Erreur lors de la recupération des logements: $error");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadLogementDetails({required String logementId}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final responses = await Future.wait([
        _dio.get("logement/$logementId/details/"),
        _dio.get("load/comments/$logementId/"),
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
      final response = await _dio.get("filter/logements-by/category/$slug/");
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

  Future<String> publishLogement({
    required String token,
    required List<File> images,
    required Map<String, dynamic> logementData,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final formData = FormData.fromMap({
        ...logementData,
        'images': await _prepareImages(images),
      });

      final response = await _dio.post(
        'logement/publish/',
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          contentType: 'multipart/form-data',
        ),
      );

      if (response.statusCode == 201) {
        return 'Logement publié avec succès !';
      } else if (response.statusCode == 401) {
        return response.data['detail'];
      }
      return "Echec de publication: ${response.data['detail']}";
    } on DioException catch (e) {
      throw _handlePublishError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<MultipartFile>> _prepareImages(List<File> images) async {
    return await Future.wait(
      images.map(
        (image) async => await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
      ),
    );
  }

  String _handlePublishError(DioException e) {
    if (e.response?.statusCode == 400) {
      final errors = e.response?.data as Map<String, dynamic>;
      return errors['images']?.first ?? 'Erreur de validation';
    }
    return 'Erreur lors de la publication: ${e.message}';
  }
}
