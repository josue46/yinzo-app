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

  final Dio client = DioService.getDioInstanceWithBaseUrl();

  Future<void> loadLogements() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await client.get("logements/");
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
        client.get("logement/$logementId/details/"),
        client.get("load/comments/$logementId/"),
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
      final response = await client.get("filter/logements-by/category/$slug/");
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

  Future<String?> publishLogement(
    String token, {
    required String description,
    required String price,
    required String warranty,
    required String category,
    required String location,
    required String ownerNumber,
    required String city,
    required List<File> images,
    int? visiteFee,
    int? commissionMonth,
    int? numberOfRooms,
    bool? forRent,
  }) async {
    _isLoading = true;
    notifyListeners();

    // Convertir chaque image en MultipartFile
    List<MultipartFile> multipartImages = [];
    for (File image in images) {
      String imageName = image.path.split("/").last;
      multipartImages.add(
        await MultipartFile.fromFile(image.path, filename: imageName),
      );
    }

    final data = FormData.fromMap({
      "description": description,
      "price": price,
      "category": category,
      "location": location,
      "owner_number": ownerNumber,
      "city": city,
      "warranty": warranty,
      "visite_fee": visiteFee,
      "commission_month": commissionMonth,
      "number_of_rooms": numberOfRooms,
      "for_rent": forRent,
      "images": multipartImages,
    });

    try {
      final response = await client.post(
        "publish/logement/",
        data: data,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        const String successMessage = "Votre logement a été publié";
        return successMessage;
      }
    } catch (error) {
      const String errorMessage = "Erreur lors de la publication";
      print(error);
      return "$errorMessage: $error";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return null;
  }
}
