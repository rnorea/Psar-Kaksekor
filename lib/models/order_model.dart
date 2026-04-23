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

  // ── Supabase string conversion ──────────────────────────────────────────
  String get toDb {
    switch (this) {
      case OrderStatus.pending:   return 'pending';
      case OrderStatus.confirmed: return 'confirmed';
      case OrderStatus.onWay:     return 'on_way';
      case OrderStatus.delivered: return 'delivered';
    }
  }

  static OrderStatus fromDb(String value) {
    switch (value) {
      case 'confirmed': return OrderStatus.confirmed;
      case 'on_way':    return OrderStatus.onWay;
      case 'delivered': return OrderStatus.delivered;
      default:          return OrderStatus.pending;
    }
  }
}

class OrderModel {
  final String id;
  final String buyerId;
  final String sellerId;
  final String farmName;
  final List<CartItemModel> items;
  final double total;
  final OrderStatus status;
  final DateTime createdAt;
  final String buyerName;
  final String deliveryAddress;

  const OrderModel({
    required this.id,
    required this.buyerId,
    required this.sellerId,
    required this.farmName,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.buyerName,
    required this.deliveryAddress,
  });

  String get itemsSummary => items
      .map((i) => '${i.emoji} ${i.name} ${i.quantity}${i.unit}')
      .join(' · ');

  // ── From Supabase ─────────────────────────────────────────────────────────
  factory OrderModel.fromMap(Map<String, dynamic> map, List<CartItemModel> items) {
    return OrderModel(
      id:              map['id'],
      buyerId:         map['buyer_id'] ?? '',
      sellerId:        map['seller_id'] ?? '',
      farmName:        map['farm_name'] ?? '',
      items:           items,
      total:           (map['total'] as num).toDouble(),
      status:          OrderStatusExtension.fromDb(map['status']),
      createdAt:       DateTime.parse(map['created_at']),
      buyerName:       map['buyer_name'] ?? '',
      deliveryAddress: map['delivery_address'] ?? '',
    );
  }

  // ── To Supabase ───────────────────────────────────────────────────────────
  Map<String, dynamic> toMap() {
    return {
      'buyer_id':         buyerId,
      'seller_id':        sellerId,
      'farm_name':        farmName,
      'total':            total,
      'status':           status.toDb,
      'buyer_name':       buyerName,
      'delivery_address': deliveryAddress,
    };
  }

  OrderModel copyWith({
    String? id,
    String? buyerId,
    String? sellerId,
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
      buyerId:         buyerId         ?? this.buyerId,
      sellerId:        sellerId        ?? this.sellerId,
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