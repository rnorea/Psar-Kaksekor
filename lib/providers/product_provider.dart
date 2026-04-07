import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/farm_model.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> _products = [];
  List<ProductModel> _trendingProducts = [];
  List<FarmModel> _farms = [];
  String _selectedCategory = 'all';
  String _searchQuery = '';

  List<ProductModel> get products => _products;
  List<ProductModel> get trendingProducts => _trendingProducts;
  List<FarmModel> get farms => _farms;
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

  void setFarms(List<FarmModel> farms) {
    _farms = farms;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  List<ProductModel> get allProducts => _products;

  void addProduct(ProductModel product) {
    _products.add(product);
    notifyListeners();
  }

  void updateProduct(ProductModel product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      _products[index] = product;
      notifyListeners();
    }
  }

  void removeProduct(String productId) {
    _products.removeWhere((p) => p.id == productId);
    notifyListeners();
  }
}