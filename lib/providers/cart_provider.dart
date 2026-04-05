import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItemModel> _items = [];

  List<CartItemModel> get items => List.unmodifiable(_items);
  int get itemCount => _items.length;

  double get subtotal =>
      _items.fold(0, (sum, item) => sum + item.total);

  double get deliveryFee => 0.50;

  double get platformFee => subtotal * 0.05;

  double get total => subtotal + deliveryFee + platformFee;

  bool contains(String productId) =>
      _items.any((item) => item.productId == productId);

  void addItem(ProductModel product, int quantity) {
    final index = _items.indexWhere((i) => i.productId == product.id);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(
        quantity: _items[index].quantity + quantity,
      );
    } else {
      _items.add(CartItemModel(
        productId: product.id,
        name: product.name,
        emoji: product.emoji,
        price: product.basePrice,
        quantity: quantity,
        unit: product.unit,
      ));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.productId == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    final index = _items.indexWhere((i) => i.productId == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index] = _items[index].copyWith(quantity: quantity);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}