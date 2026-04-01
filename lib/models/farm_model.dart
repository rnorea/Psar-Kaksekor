import 'package:flutter/material.dart';
import 'product_model.dart';

class FarmModel {
  final String id;
  final String name;
  final String emoji;
  final Color bgColor;
  final int rank;
  final String rankLabel;
  final ProductModel featuredProduct;

  const FarmModel({
    required this.id,
    required this.name,
    required this.emoji,
    required this.bgColor,
    required this.rank,
    required this.rankLabel,
    required this.featuredProduct,
  });

  FarmModel copyWith({
    String? id,
    String? name,
    String? emoji,
    Color? bgColor,
    int? rank,
    String? rankLabel,
    ProductModel? featuredProduct,
  }) {
    return FarmModel(
      id:              id              ?? this.id,
      name:            name            ?? this.name,
      emoji:           emoji           ?? this.emoji,
      bgColor:         bgColor         ?? this.bgColor,
      rank:            rank            ?? this.rank,
      rankLabel:       rankLabel       ?? this.rankLabel,
      featuredProduct: featuredProduct ?? this.featuredProduct,
    );
  }
}