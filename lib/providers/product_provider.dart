import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/farm_model.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> _products = [];
  List<ProductModel> _trendingProducts = [];
  List<FarmModel> _farms = [];
  String _selectedCategory = 'all';
  String _searchQuery = '';

  // ── Getters ──────────────────────────────────────────────────────────────
  List<ProductModel> get products        => _products;
  List<ProductModel> get allProducts     => _products; // alias
  List<ProductModel> get trendingProducts => _trendingProducts;
  List<FarmModel>    get farms           => _farms;
  String get selectedCategory            => _selectedCategory;
  String get searchQuery                 => _searchQuery;

  // Maps chip display labels → product category keys
  static const _categoryMap = {
    'all':            'all',
    'All':            'all',
    '🥦 Vegetables':  'veg',
    '🌾 Grains':      'grain',
    '🌾 Grains & Rice': 'grain',
    '🍎 Fruits':      'fruit',
    '🌿 Herbs':       'herb',
    '🥚 Eggs':        'dairy',
    '🥚 Eggs & Dairy': 'dairy',
  };

  List<ProductModel> get filteredProducts {
    List<ProductModel> result = _products;

    // Resolve chip label to category key (e.g. '🥦 Vegetables' → 'veg')
    final catKey = _categoryMap[_selectedCategory] ?? _selectedCategory;

    if (catKey != 'all') {
      result = result.where((p) => p.category == catKey).toList();
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

  // ── Setters ──────────────────────────────────────────────────────────────
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

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // alias used in browse_screen
  void setQuery(String query) => setSearchQuery(query);

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  // ── CRUD (used by seller screens) ────────────────────────────────────────
  void addProduct(ProductModel product) {
    _products = [product, ..._products];
    notifyListeners();
  }

  void updateProduct(ProductModel updated) {
    _products = _products.map((p) => p.id == updated.id ? updated : p).toList();
    notifyListeners();
  }

  void removeProduct(String id) {
    _products = _products.where((p) => p.id != id).toList();
    notifyListeners();
  }
}
