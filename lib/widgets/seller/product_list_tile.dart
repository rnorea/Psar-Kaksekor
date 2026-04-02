import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../models/product_model.dart';

class ProductListTile extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductListTile({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  Color get _stockDotColor {
    if (product.isOutOfStock) return colorRed;
    if (product.isLowStock)   return colorYellow;
    return colorAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [kCardShadow],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      margin: const EdgeInsets.only(bottom: kListGap),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: product.bgColor,
              borderRadius: BorderRadius.circular(kRadiusSmall),
            ),
            alignment: Alignment.center,
            child: Text(product.emoji, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: titleSmall.copyWith(fontSize: 11)),
                Row(
                  children: [
                    Text(
                      '\$${product.basePrice.toStringAsFixed(2)}/${product.unit} · ${product.stock} left ',
                      style: metaText,
                    ),
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _stockDotColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
          Row(
            children: [
              _PillBtn(label: 'Edit', bg: colorPale, textColor: colorAccent, onTap: onEdit),
              const SizedBox(width: 5),
              _PillBtn(label: 'Del', bg: deleteBg, textColor: colorRed, onTap: onDelete),
            ],
          ),
        ],
      ),
    );
  }
}

class _PillBtn extends StatelessWidget {
  final String label;
  final Color bg;
  final Color textColor;
  final VoidCallback onTap;

  const _PillBtn({
    required this.label,
    required this.bg,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w800,
            fontSize: 9,
            color: textColor,
          ),
        ),
      ),
    );
  }
}