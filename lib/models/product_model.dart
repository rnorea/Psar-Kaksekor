import 'package:flutter/material.dart';

class ProductModel {
  final String id;
  final String name;
  final String farmName;
  final String sellerId;
  final String emoji;
  final Color bgColor;
  final double basePrice;
  final String unit;
  final int stock;
  final String category;
  final String description;
  final bool isOrganic;
  final double rating;
  final int reviewCount;
  final String? imageUrl;

  const ProductModel({
    required this.id,
    required this.name,
    required this.farmName,
    required this.sellerId,
    required this.emoji,
    required this.bgColor,
    required this.basePrice,
    required this.unit,
    required this.stock,
    required this.category,
    required this.description,
    this.isOrganic = false,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.imageUrl,
  });

  // ── From Supabase ─────────────────────────────────────────────────────────
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    final category = map['category'] ?? '';
    return ProductModel(
      id:          map['id'] ?? '',
      name:        map['name'] ?? '',
      farmName:    map['farm_name'] ?? '',
      sellerId:    map['seller_id'] ?? '',
      emoji:       _emojiFromCategory(category),
      bgColor:     _colorFromCategory(category),
      basePrice:   (map['price'] as num).toDouble(),
      unit:        map['unit'] ?? 'kg',
      stock:       map['stock'] ?? 0,
      category:    category,
      description: map['description'] ?? '',
      isOrganic:   map['is_organic'] ?? false,
      rating:      (map['rating'] as num?)?.toDouble() ?? 0.0,  // ← from db
      reviewCount: map['review_count'] ?? 0,                    // ← from db
      imageUrl:    map['image_url'],
    );
  }
  static String _emojiFromCategory(String category) {
    switch (category) {
      case 'veg':   return '🥦';
      case 'grain': return '🌾';
      case 'fruit': return '🍎';
      case 'herb':  return '🌿';
      case 'dairy': return '🥚';
      default:      return '🌿';
    }
  }

  static Color _colorFromCategory(String category) {
    switch (category) {
      case 'veg':   return const Color(0xFFE8F5E9);
      case 'grain': return const Color(0xFFFFF8E1);
      case 'fruit': return const Color(0xFFFFEBEE);
      case 'herb':  return const Color(0xFFE8F5E9);
      case 'dairy': return const Color(0xFFFFF3E0);
      default:      return const Color(0xFFF0F0F0);
    }
  }


  // ── To Supabase ───────────────────────────────────────────────────────────
  Map<String, dynamic> toMap() {
    return {
      'name':         name,
      'farm_name':    farmName,
      'seller_id':    sellerId,
      'price':        basePrice,
      'unit':         unit,
      'stock':        stock,
      'category':     category,
      'description':  description,
      'is_organic':   isOrganic,
      'image_url':    imageUrl,
      'rating':       rating,
      'review_count': reviewCount,
    };
  }

  // ── Color helpers ─────────────────────────────────────────────────────────
  static Color _colorFromHex(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  static String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  String get priceLabel => '\$${basePrice.toStringAsFixed(2)}/$unit';
  String get farmAndStock => '$farmName · ${stock}$unit left';
  bool get isLowStock => stock > 0 && stock < 10;
  bool get isOutOfStock => stock == 0;

  ProductModel copyWith({
    String? id,
    String? name,
    String? farmName,
    String? sellerId,
    String? emoji,
    Color? bgColor,
    double? basePrice,
    String? unit,
    int? stock,
    String? category,
    String? description,
    bool? isOrganic,
    double? rating,
    int? reviewCount,
    String? imageUrl,
  }) {
    return ProductModel(
      id:          id          ?? this.id,
      name:        name        ?? this.name,
      farmName:    farmName    ?? this.farmName,
      sellerId:    sellerId    ?? this.sellerId,
      emoji:       emoji       ?? this.emoji,
      bgColor:     bgColor     ?? this.bgColor,
      basePrice:   basePrice   ?? this.basePrice,
      unit:        unit        ?? this.unit,
      stock:       stock       ?? this.stock,
      category:    category    ?? this.category,
      description: description ?? this.description,
      isOrganic:   isOrganic   ?? this.isOrganic,
      rating:      rating      ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      imageUrl:    imageUrl    ?? this.imageUrl,
    );
  }
}