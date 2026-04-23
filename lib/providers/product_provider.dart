import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_model.dart';
import '../models/farm_model.dart';

class ProductProvider extends ChangeNotifier {
  ProductProvider() {
    fetchProducts(); // ← add this
  }

  List<ProductModel> _products = [];
  List<ProductModel> _trendingProducts = [];
  List<FarmModel> _farms = [];
  String _selectedCategory = 'all';
  String _searchQuery = '';
  bool _isLoading = false;
  String? _error;


  final _client = Supabase.instance.client;

  // ── Getters ──────────────────────────────────────────────────────────────
  List<ProductModel> get products         => _products;
  List<ProductModel> get allProducts      => _products;
  List<ProductModel> get trendingProducts => _trendingProducts;
  List<FarmModel>    get farms            => _farms;
  String             get selectedCategory => _selectedCategory;
  String             get searchQuery      => _searchQuery;
  bool               get isLoading        => _isLoading;
  String?            get error            => _error;

  static const _categoryMap = {
    'all':              'all',
    'All':              'all',
    '🥦 Vegetables':    'veg',
    '🌾 Grains':        'grain',
    '🌾 Grains & Rice': 'grain',
    '🍎 Fruits':        'fruit',
    '🌿 Herbs':         'herb',
    '🥚 Eggs':          'dairy',
    '🥚 Eggs & Dairy':  'dairy',
  };

  List<ProductModel> get filteredProducts {
    List<ProductModel> result = _products;
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

  // ── Fetch all products (buyer) ───────────────────────────────────────────
  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _client
          .from('products')
          .select();  // ← remove order for now to rule out created_at issue

      print('fetched: ${(data as List).length} products');
      print('data: $data');

      _products = (data as List)
          .map((e) => ProductModel.fromMap(e))
          .toList();

      print('mapped: ${_products.length} products');
    } catch (e) {
      print('fetchProducts error: $e');
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // ── Fetch only seller's products ─────────────────────────────────────────
  Future<void> fetchSellerProducts(String sellerId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _client
          .from('products')
          .select()
          .eq('seller_id', sellerId)
          .order('created_at', ascending: false);

      _products = (data as List)
          .map((e) => ProductModel.fromMap(e))
          .toList();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // ── CRUD ─────────────────────────────────────────────────────────────────
  Future<void> addProduct(ProductModel product) async {
    try {
      await _client.from('products').insert(product.toMap());
      _products = [product, ..._products];
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateProduct(ProductModel updated) async {
    try {
      await _client
          .from('products')
          .update(updated.toMap())
          .eq('id', updated.id);
      _products = _products
          .map((p) => p.id == updated.id ? updated : p)
          .toList();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> removeProduct(String id) async {
    try {
      await _client.from('products').delete().eq('id', id);
      _products = _products.where((p) => p.id != id).toList();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // ── Setters ──────────────────────────────────────────────────────────────
  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setQuery(String query) => setSearchQuery(query);

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }
}