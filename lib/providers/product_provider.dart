import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> _products = [];
  List<ProductModel> _trendingProducts = [];
  String _selectedCategory = 'all';
  String _searchQuery = '';

  List<ProductModel> get products => _products;
  List<ProductModel> get trendingProducts => _trendingProducts;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  List<ProductModel> get filteredProducts {
    List<ProductModel> result = _products;
    if (_selectedCategory != 'all') {
      result = result.where((p) => p.category == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((p) =>
      p.name.toLowerCase().contains(q) ||
          p.farmName.toLowerCase().contains(q)
      ).toList();
    }
    return result;
  }

  List<ProductModel> get searchResults {
    if (_searchQuery.isEmpty) return [];
    final q = _searchQuery.toLowerCase();
    return _products.where((p) =>
    p.name.toLowerCase().contains(q) ||
        p.farmName.toLowerCase().contains(q)
    ).toList();
  }

  void setProducts(List<ProductModel> products) {
    _products = products;
    notifyListeners();
  }

  void setTrendingProducts(List<ProductModel> products) {
    _trendingProducts = products;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }
}