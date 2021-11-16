import 'package:flutter/material.dart';
import 'package:nibjobs/model/config/global.dart';

class LocalConfig with ChangeNotifier {
  Category? _selectedCategory;
  List<Category>? _categories;
  String? _selectedSubCategory;
  String? _selectedsearchBook;
  Map<String, dynamic>? _amCategory;

  Map<String, dynamic> get amCategory => _amCategory!;

  set amCategory(Map<String, dynamic> value) {
    _amCategory = value;
    notifyListeners();
  }

  Category get selectedCategory => _selectedCategory ?? Category();

  set selectedCategory(Category value) {
    _selectedCategory = value;

    notifyListeners();
  }

  List<Category> get categories => _categories ?? [];
  set categories(List<Category> value) {
    _categories = value;

    notifyListeners();
  }

  String get selectedSubCategory => _selectedSubCategory!;

  set selectedSubCategory(String value) {
    _selectedSubCategory = value;
    notifyListeners();
  }

  String get selectedSearchBook => _selectedsearchBook!;

  set selectedSearchBook(String value) {
    _selectedsearchBook = value;
    notifyListeners();
  }

  LocalConfig();
}
