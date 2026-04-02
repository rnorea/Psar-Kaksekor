import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../models/cart_item_model.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onDelete;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.productId),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: colorRed,
          borderRadius: BorderRadius.circular(kRadiusBtn),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 20),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kRadiusBtn),
          boxShadow: const [kCardShadow],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
        child: Row(
          children: [
            Container(
              width: kCartEmojiSize,
              height: kCartEmojiSize,
              decoration: BoxDecoration(
                color: colorPale,
                borderRadius: BorderRadius.circular(kRadiusSmall),
              ),
              alignment: Alignment.center,
              child: Text(
                item.emoji,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: titleSmall.copyWith(fontSize: 11)),
                  Text(item.subtitle, style: metaText),
                ],
              ),
            ),
            Text(
              '\$${item.total.toStringAsFixed(2)}',
              style: priceMed,
            ),
          ],
        ),
      ),
    );
  }
}