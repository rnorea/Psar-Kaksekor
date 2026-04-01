import 'cart_item_model.dart';

enum OrderStatus { pending, confirmed, onWay, delivered }

extension OrderStatusExtension on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending:   return 'Pending';
      case OrderStatus.confirmed: return 'Confirmed';
      case OrderStatus.onWay:     return 'On the Way';
      case OrderStatus.delivered: return 'Delivered';
    }
  }

  int get step {
    switch (this) {
      case OrderStatus.pending:   return 0;
      case OrderStatus.confirmed: return 1;
      case OrderStatus.onWay:     return 2;
      case OrderStatus.delivered: return 3;
    }
  }

  bool get isActive => this != OrderStatus.delivered;

  OrderStatus get next {
    switch (this) {
      case OrderStatus.pending:   return OrderStatus.confirmed;
      case OrderStatus.confirmed: return OrderStatus.onWay;
      case OrderStatus.onWay:     return OrderStatus.delivered;
      case OrderStatus.delivered: return OrderStatus.delivered;
    }
  }
}

class OrderModel {
  final String id;
  final String farmName;
  final List<CartItemModel> items;
  final double total;
  final OrderStatus status;
  final DateTime createdAt;
  final String buyerName;
  final String deliveryAddress;

  const OrderModel({
    required this.id,
    required this.farmName,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.buyerName,
    required this.deliveryAddress,
  });

  String get itemsSummary => items.map((i) => '${i.emoji} ${i.name} ${i.quantity}${i.unit}').join(' · ');

  OrderModel copyWith({
    String? id,
    String? farmName,
    List<CartItemModel>? items,
    double? total,
    OrderStatus? status,
    DateTime? createdAt,
    String? buyerName,
    String? deliveryAddress,
  }) {
    return OrderModel(
      id:              id              ?? this.id,
      farmName:        farmName        ?? this.farmName,
      items:           items           ?? this.items,
      total:           total           ?? this.total,
      status:          status          ?? this.status,
      createdAt:       createdAt       ?? this.createdAt,
      buyerName:       buyerName       ?? this.buyerName,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
    );
  }
}