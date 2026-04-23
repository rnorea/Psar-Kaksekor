class CartItemModel {
  final String productId;
  final String name;
  final String emoji;
  final double price;
  final int quantity;
  final String unit;
  final String? category;  // add this to derive emoji
  final String? sellerId; // add this field

  const CartItemModel({
    required this.productId,
    required this.name,
    required this.emoji,
    required this.price,
    required this.quantity,
    required this.unit,
    this.category,
    this.sellerId,

  });

  // ── From Supabase ─────────────────────────────────────────────────────────
  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    final category = map['category'] ?? '';
    return CartItemModel(
      productId: map['product_id'] ?? '',
      name:      map['name'] ?? '',
      emoji:     _emojiFromCategory(category),
      price:     (map['price'] as num).toDouble(),
      quantity:  map['quantity'] ?? 1,
      unit:      map['unit'] ?? '',
      category:  category,
    );
  }

  // ── To Supabase ───────────────────────────────────────────────────────────
  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'name':       name,
      'price':      price,
      'quantity':   quantity,
      'unit':       unit,
      'category':   category,
    };
  }

  static String _emojiFromCategory(String category) {
    switch (category) {
      case 'veg':   return '🥦';
      case 'grain': return '🌾';
      case 'fruit': return '🍎';
      case 'herb':  return '🌿';
      case 'dairy': return '🥚';
      default:      return '🛒';
    }
  }

  double get total => price * quantity;
  String get subtitle => '$quantity $unit × \$${price.toStringAsFixed(2)}';

  CartItemModel copyWith({
    String? productId,
    String? name,
    String? emoji,
    double? price,
    int? quantity,
    String? unit,
    String? category,
  }) {
    return CartItemModel(
      productId: productId ?? this.productId,
      name:      name      ?? this.name,
      emoji:     emoji     ?? this.emoji,
      price:     price     ?? this.price,
      quantity:  quantity  ?? this.quantity,
      unit:      unit      ?? this.unit,
      category:  category  ?? this.category,
    );
  }
}