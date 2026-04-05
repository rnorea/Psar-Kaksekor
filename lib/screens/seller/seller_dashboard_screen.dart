import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/seller/stat_card.dart';
import '../../widgets/common/status_badge.dart';
import '../seller/products/my_products_modal.dart';
import '../seller/products/add_product_modal.dart';
import '../seller/orders/seller_orders_modal.dart';
import 'package:provider/provider.dart';

class SellerDashboardScreen extends StatelessWidget {
  const SellerDashboardScreen({super.key});

  void _openAddProduct(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddProductModal(),
    );
  }

  void _openMyProducts(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const MyProductsModal(),
    );
  }

  void _openOrders(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SellerOrdersModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final orders = context.watch<OrderProvider>();
    final products = context.watch<ProductProvider>();

    final sellerName = auth.currentUser?.name ?? 'Seller';
    final initial = sellerName.isNotEmpty ? sellerName[0].toUpperCase() : 'S';

    final recentOrders = orders.sellerOrders.take(3).toList();

    return Scaffold(
      backgroundColor: colorOff,
      body: Column(
        children: [
          // ── Header (no bottom radius, full dark bg) ──────────────────────
          Container(
            color: colorDark,
            padding: const EdgeInsets.fromLTRB(15, kHeaderPaddingTop, 15, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good morning,',
                  style: TextStyle(
                    fontFamily: 'DM Sans',
                    fontSize: 10,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      sellerName,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    // Avatar
                    Container(
                      width: kAvatarSize,
                      height: kAvatarSize,
                      decoration: const BoxDecoration(
                        color: colorLight,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        initial,
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // 2×2 stat grid
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 7,
                  mainAxisSpacing: 7,
                  childAspectRatio: 2.6,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    StatCard(value: '\$128', label: 'This month'),
                    StatCard(value: '7', label: 'New orders'),
                    StatCard(value: '4', label: 'Products listed'),
                    StatCard(value: '4.8★', label: 'Avg rating'),
                  ],
                ),
              ],
            ),
          ),

          // ── Scrollable body ───────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(kScreenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Action buttons row
                  Row(
                    children: [
                      Expanded(
                        child: _ActionBtn(
                          label: '＋ Add Product',
                          isPrimary: true,
                          onTap: () => _openAddProduct(context),
                        ),
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: _ActionBtn(
                          label: '📦 My Products',
                          isPrimary: false,
                          onTap: () => _openMyProducts(context),
                        ),
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: _ActionBtn(
                          label: '📋 Orders',
                          isPrimary: false,
                          onTap: () => _openOrders(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: kSectionGap),

                  // Section title
                  const Padding(
                    padding: EdgeInsets.only(bottom: 9),
                    child: Text(
                      'Recent Orders',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w800,
                        fontSize: 12.5,
                        color: colorTextDark,
                      ),
                    ),
                  ),

                  // Recent order cards
                  if (recentOrders.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          'No orders yet',
                          style: TextStyle(
                            fontFamily: 'DM Sans',
                            fontSize: 12,
                            color: colorG400,
                          ),
                        ),
                      ),
                    )
                  else
                    ...recentOrders.map((order) => _CompactOrderCard(order: order)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Private widgets ───────────────────────────────────────────────────────────

class _ActionBtn extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 6),
        decoration: BoxDecoration(
          color: isPrimary ? colorDark : colorG100,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w800,
            fontSize: 10.5,
            color: isPrimary ? Colors.white : colorMid,
          ),
        ),
      ),
    );
  }
}

class _CompactOrderCard extends StatelessWidget {
  final OrderModel order;

  const _CompactOrderCard({required this.order});

  String get _statusLabel {
    switch (order.status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.onWay:
        return 'On the Way';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemsSummary = order.items
        .map((i) => '${i.quantity}× ${i.name}')
        .join(', ');

    return Container(
      margin: const EdgeInsets.only(bottom: kListGap),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kRadiusCard),
        boxShadow: const [kCardShadow],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#${order.id}',
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    color: colorTextDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  itemsSummary,
                  style: const TextStyle(
                    fontFamily: 'DM Sans',
                    fontSize: 10,
                    color: colorG600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '\$${order.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w800,
                    fontSize: 11.5,
                    color: colorDark,
                  ),
                ),
              ],
            ),
          ),
          StatusBadge(status: order.status),
        ],
      ),
    );
  }
}
