import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order_model.dart';
import '../models/cart_item_model.dart';

class OrderProvider extends ChangeNotifier {
  List<OrderModel> _buyerOrders = [];
  List<OrderModel> _sellerOrders = [];
  bool _isLoading = false;
  String? _error;

  final _client = Supabase.instance.client;

  List<OrderModel> get buyerOrders    => List.unmodifiable(_buyerOrders);
  List<OrderModel> get sellerOrders   => List.unmodifiable(_sellerOrders);
  bool             get isLoading      => _isLoading;
  String?          get error          => _error;

  List<OrderModel> get activeOrders =>
      _buyerOrders.where((o) => o.status.isActive).toList();

  List<OrderModel> get deliveredOrders =>
      _buyerOrders.where((o) => o.status == OrderStatus.delivered).toList();

  List<OrderModel> sellerOrdersByStatus(OrderStatus status) =>
      _sellerOrders.where((o) => o.status == status).toList();

  // ── Fetch buyer orders ────────────────────────────────────────────────────
  Future<void> fetchBuyerOrders(String buyerId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _client
          .from('orders')
          .select('*, order_items(*)')
          .eq('buyer_id', buyerId)
          .order('created_at', ascending: false);

      _buyerOrders = (data as List).map((o) {
        final itemsData = o['order_items'] as List? ?? [];
        final items = itemsData.map((i) => CartItemModel.fromMap(i)).toList();
        return OrderModel.fromMap(o, items);
      }).toList();

    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // ── Fetch seller orders ───────────────────────────────────────────────────
  Future<void> fetchSellerOrders(String sellerId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _client
          .from('orders')
          .select('*, order_items(*)')
          .eq('seller_id', sellerId)
          .order('created_at', ascending: false);

      _sellerOrders = (data as List).map((o) {
        final itemsData = o['order_items'] as List? ?? [];
        final items = itemsData.map((i) => CartItemModel.fromMap(i)).toList();
        return OrderModel.fromMap(o, items);
      }).toList();

    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // ── Place order ───────────────────────────────────────────────────────────
  Future<void> placeOrder({
    required String buyerId,
    required String sellerId,
    required String farmName,
    required List<CartItemModel> items,
    required double total,
    required String buyerName,
    required String deliveryAddress,
  }) async {
    try {
      // Insert order
      final orderData = await _client.from('orders').insert({
        'buyer_id':         buyerId,
        'seller_id':        sellerId,
        'farm_name':        farmName,
        'total':            total,
        'status':           'pending',
        'buyer_name':       buyerName,
        'delivery_address': deliveryAddress,
      }).select().single();

      final orderId = orderData['id'];

      // Insert order items
      await _client.from('order_items').insert(
        items.map((i) => {
          'order_id':   orderId,
          'product_id': i.productId,
          'name':       i.name,
          'quantity':   i.quantity,
          'price':      i.price,
          'unit':       i.unit,
          'category':   i.category,
        }).toList(),
      );
      // Add to local list
      final order = OrderModel(
        id:              orderId,
        buyerId:         buyerId,
        sellerId:        sellerId,
        farmName:        farmName,
        items:           items,
        total:           total,
        status:          OrderStatus.pending,
        createdAt:       DateTime.now(),
        buyerName:       buyerName,
        deliveryAddress: deliveryAddress,
      );

      _buyerOrders.insert(0, order);
      notifyListeners();

    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // ── Advance order status (seller) ─────────────────────────────────────────
  Future<void> advanceSellerOrder(String orderId) async {
    final index = _sellerOrders.indexWhere((o) => o.id == orderId);
    if (index < 0) return;

    final nextStatus = _sellerOrders[index].status.next;

    try {
      await _client
          .from('orders')
          .update({'status': nextStatus.toDb})
          .eq('id', orderId);

      _sellerOrders[index] = _sellerOrders[index].copyWith(status: nextStatus);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void advanceOrder(String orderId) => advanceSellerOrder(orderId);

  // ── Cancel order ──────────────────────────────────────────────────────────
  Future<void> cancelOrder(String orderId) async {
    try {
      await _client.from('orders').delete().eq('id', orderId);
      _buyerOrders.removeWhere((o) => o.id == orderId);
      _sellerOrders.removeWhere((o) => o.id == orderId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}