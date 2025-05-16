import 'package:flutter/material.dart';
import 'package:yinzo/core/dio_helper.dart';
import 'package:yinzo/models/category.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];

  List<Category> get categories => _categories;

  final dio = DioHelper.getDioInstanceWithBaseUrl();

  Future<void> loadCategories() async {
    try {
      final response = await dio.get("/categories");
      if (response.statusCode == 200) {
        _categories =
            (response.data as List)
                .map((item) => Category.fromJson(item as Map<String, String>))
                .toList();
        notifyListeners();
      } else {
        debugPrint("Erreur ${response.statusCode}");
      }
    } catch (error) {
      debugPrint("Une erreur s'est produite: $error");
    }
  }
}
