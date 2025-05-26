import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yinzo/Logements/Models/category.dart';
import 'package:yinzo/Services/Dio/dio_service.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];

  List<Category> get categories => _categories;

  final dio = DioService.getDioInstanceWithBaseUrl();

  Future<void> loadCategories() async {
    try {
      final response = await dio.get("/categories");
      if (response.statusCode == 200) {
        _categories =
            (response.data as List)
                .map((item) => Category.fromJson(item as Map<String, dynamic>))
                .toList();
        notifyListeners();
      } else {
        debugPrint("Erreur ${response.statusCode}");
      }
    } catch (error) {
      debugPrint("Une erreur s'est produite: $error");
    }
  }

  static CategoryProvider of(context, {bool listen = true}) {
    return Provider.of<CategoryProvider>(context, listen: listen);
  }
}
