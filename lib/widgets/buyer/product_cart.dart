import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kRadiusCard),
          boxShadow: const [kCardShadow],
        ),
        padding: const EdgeInsets.all(kCardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: kProductImgHeight+30,
              decoration: BoxDecoration(
                color: product.bgColor,
                borderRadius: BorderRadius.circular(kRadiusSmall),
              ),
              alignment: Alignment.center,
              child: Text(
                product.emoji,
                style: const TextStyle(fontSize: 26),
              ),
            ),
            const SizedBox(height: 15),
            Text(product.name, style: titleSmall),
            Text(product.farmName, style: farmText),
            const SizedBox(height: 3),
            Text(product.priceLabel, style: priceSmall),
          ],
        ),
      ),
    );
  }
}