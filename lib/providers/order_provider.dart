import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/cart_item_model.dart';

class OrderProvider extends ChangeNotifier {

  List<OrderModel> _buyerOrders = [];
  List<OrderModel> _sellerOrders = [];

  List<OrderModel> get buyerOrders => List.unmodifiable(_buyerOrders);
  List<OrderModel> get sellerOrders => List.unmodifiable(_sellerOrders);

  List<OrderModel> get activeOrders =>
      _buyerOrders.where((o) => o.status.isActive).toList();

  List<OrderModel> get deliveredOrders =>
      _buyerOrders.where((o) => o.status == OrderStatus.delivered).toList();

  List<OrderModel> sellerOrdersByStatus(OrderStatus status) =>
      _sellerOrders.where((o) => o.status == status).toList();

  void advanceOrder(String orderId) => advanceSellerOrder(orderId);

  void setBuyerOrders(List<OrderModel> orders) {
    _buyerOrders = orders;
    notifyListeners();
  }

  void setSellerOrders(List<OrderModel> orders) {
    _sellerOrders = orders;
    notifyListeners();
  }

  void placeOrder({
    required String id,
    required String farmName,
    required List<CartItemModel> items,
    required double total,
    required String buyerName,
    required String deliveryAddress,
  }) {
    final order = OrderModel(
      id: id,
      farmName: farmName,
      items: items,
      total: total,
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
      buyerName: buyerName,
      deliveryAddress: deliveryAddress,
    );
    _buyerOrders.insert(0, order);
    notifyListeners();
  }

  void advanceSellerOrder(String orderId) {
    final index = _sellerOrders.indexWhere((o) => o.id == orderId);
    if (index >= 0) {
      _sellerOrders[index] = _sellerOrders[index].copyWith(
        status: _sellerOrders[index].status.next,
      );
      notifyListeners();
    }
  }

  void cancelOrder(String orderId) {
    _buyerOrders.removeWhere((o) => o.id == orderId);
    _sellerOrders.removeWhere((o) => o.id == orderId);
    notifyListeners();
  }
}