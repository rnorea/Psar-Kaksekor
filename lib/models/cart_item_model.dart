class CartItemModel {
  final String productId;
  final String name;
  final String emoji;
  final double price;
  final int quantity;
  final String unit;

  const CartItemModel({
    required this.productId,
    required this.name,
    required this.emoji,
    required this.price,
    required this.quantity,
    required this.unit,
  });

  double get total => price * quantity;

  String get subtitle => '$quantity $unit × \$${price.toStringAsFixed(2)}';

  CartItemModel copyWith({
    String? productId,
    String? name,
    String? emoji,
    double? price,
    int? quantity,
    String? unit,
  }) {
    return CartItemModel(
      productId: productId ?? this.productId,
      name:      name      ?? this.name,
      emoji:     emoji     ?? this.emoji,
      price:     price     ?? this.price,
      quantity:  quantity  ?? this.quantity,
      unit:      unit      ?? this.unit,
    );
  }
}