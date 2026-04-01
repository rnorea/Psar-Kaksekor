import 'package:flutter/material.dart';

class ProductModel {
  final String id;
  final String name;
  final String farmName;
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

  const ProductModel({
    required this.id,
    required this.name,
    required this.farmName,
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
  });

  String get priceLabel => '\$${basePrice.toStringAsFixed(2)}/$unit';

  String get farmAndStock => '$farmName · ${stock}$unit left';

  bool get isLowStock => stock > 0 && stock < 10;

  bool get isOutOfStock => stock == 0;

  ProductModel copyWith({
    String? id,
    String? name,
    String? farmName,
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
  }) {
    return ProductModel(
      id:          id          ?? this.id,
      name:        name        ?? this.name,
      farmName:    farmName    ?? this.farmName,
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
    );
  }
}