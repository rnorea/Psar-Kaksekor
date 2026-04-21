import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';
import '../core/constants/app_constants.dart';
import '../models/product_model.dart';
import 'package:phsar_kaksekor_app/widgets/common/qty_control.dart';
import 'package:phsar_kaksekor_app/widgets/common/custom_button.dart';

class ProductDetailModal extends StatefulWidget {
  final ProductModel product;
  final ValueChanged<int> onAddToCart;

  const ProductDetailModal({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  State<ProductDetailModal> createState() => _ProductDetailModalState();
}

class _ProductDetailModalState extends State<ProductDetailModal>
    with SingleTickerProviderStateMixin {
  int _qty = 1;
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: 0, end: -6).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      maxChildSize: 0.92,
      minChildSize: 0.4,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(kRadiusModal)),
        ),
        child: Column(
          children: [
            // ── Hero ─────────────────────────────────────────────────────
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFDFF0E5), Color(0xFFC8E6D2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(kRadiusModal)),
              ),
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 28, height: 28,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Text('←',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                        ),
                      ),
                      if (widget.product.isOrganic)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                          decoration: BoxDecoration(
                            color: colorAccent,
                            borderRadius: BorderRadius.circular(kRadiusBadge),
                          ),
                          child: const Text('✓ Organic',
                            style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w800, fontSize: 8.5, color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                  AnimatedBuilder(
                    animation: _floatAnimation,
                    builder: (_, __) => Transform.translate(
                      offset: Offset(0, _floatAnimation.value),
                      child: Text(widget.product.emoji,
                        style: const TextStyle(fontSize: 68),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Body ─────────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.product.name, style: titleXL),
                    Text('by ${widget.product.farmName}', style: farmText),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Text('★★★★★',
                          style: TextStyle(color: colorYellow, fontSize: 12),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${widget.product.rating} (${widget.product.reviewCount} reviews)',
                          style: const TextStyle(fontFamily: 'DM Sans', fontSize: 10, color: colorG600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${widget.product.basePrice.toStringAsFixed(2)}',
                          style: priceXL,
                        ),
                        Text(' / ${widget.product.unit}',
                          style: const TextStyle(fontSize: 12, color: colorG400),
                        ),
                      ],
                    ),
                    Text(
                      '${widget.product.stock} ${widget.product.unit} available',
                      style: const TextStyle(fontSize: 10, color: colorG400),
                    ),
                    const Divider(color: colorG200, height: 22),
                    const Text('About this product',
                      style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w800, fontSize: 12, color: colorTextDark),
                    ),
                    const SizedBox(height: 5),
                    Text(widget.product.description,
                      style: const TextStyle(fontFamily: 'DM Sans', fontSize: 10.5, color: colorG600, height: 1.6),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Quantity',
                          style: TextStyle(fontFamily: 'DM Sans', fontWeight: FontWeight.w600, fontSize: 11.5, color: colorTextMid),
                        ),
                        QtyControl(
                          qty: _qty,
                          max: widget.product.stock,
                          onChanged: (v) => setState(() => _qty = v),
                        ),
                      ],
                    ),
                    const SizedBox(height: 11),
                    CustomButton(
                      label: '🛒 Add to Cart — \$${(_qty * widget.product.basePrice).toStringAsFixed(2)}',
                      onPressed: () {
                        widget.onAddToCart(_qty);
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(height: 7),
                    CustomButton(
                      label: '✉ Message Seller',
                      variant: ButtonVariant.secondary,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Fixed: useRootNavigator: true so modal works inside IndexedStack ──────────
void showProductDetail(
  BuildContext context,
  ProductModel product,
  ValueChanged<int> onAddToCart,
) {
  showModalBottomSheet(
    context: context,
    useRootNavigator: true,   // ← THIS is the fix for taps not working
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => ProductDetailModal(
      product: product,
      onAddToCart: onAddToCart,
    ),
  );
}