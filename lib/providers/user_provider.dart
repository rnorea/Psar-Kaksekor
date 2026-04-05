import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/product_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _profile;
  final List<ProductModel> _savedItems = [];

  UserModel? get profile => _profile;
  List<ProductModel> get savedItems => List.unmodifiable(_savedItems);

  bool isSaved(String productId) =>
      _savedItems.any((p) => p.id == productId);

  void setProfile(UserModel user) {
    _profile = user;
    notifyListeners();
  }

  void setSavedItems(List<ProductModel> items) {
    _savedItems.clear();
    _savedItems.addAll(items);
    notifyListeners();
  }

  void toggleSaved(ProductModel product) {
    if (isSaved(product.id)) {
      _savedItems.removeWhere((p) => p.id == product.id);
    } else {
      _savedItems.add(product);
    }
    notifyListeners();
  }

  void updateProfile(UserModel user) {
    _profile = user;
    notifyListeners();
  }
}