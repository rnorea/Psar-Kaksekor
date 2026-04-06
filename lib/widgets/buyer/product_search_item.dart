import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../models/product_model.dart';

class ProductSearchItem extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;
  final int? rank;

  const ProductSearchItem({
    super.key,
    required this.product,
    required this.onTap,
    this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [kCardShadow],
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            if (rank != null)
              SizedBox(
                width: 22,
                child: Text(
                  rank.toString(),
                  style: rank == 1 ? rankGoldStyle : rankGrayStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            if (rank != null) const SizedBox(width: 6),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: product.bgColor,
                borderRadius: BorderRadius.circular(kRadiusSmall),
              ),
              alignment: Alignment.center,
              child: Text(
                product.emoji,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: titleSmall.copyWith(fontSize: 11),
                  ),
                  Text(product.farmName, style: metaText),
                ],
              ),
            ),
            Text(product.priceLabel, style: priceMed),
          ],
        ),
      ),
    );
  }
}