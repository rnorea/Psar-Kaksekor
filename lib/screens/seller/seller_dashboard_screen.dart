import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phsar_kaksekor_app/core/constants/app_colors.dart';
import 'package:phsar_kaksekor_app/core/constants/app_constants.dart';
import 'package:phsar_kaksekor_app/providers/order_provider.dart';
import 'package:phsar_kaksekor_app/providers/product_provider.dart';
import 'package:phsar_kaksekor_app/providers/auth_provider.dart';
import 'package:phsar_kaksekor_app/widgets/seller/stat_card.dart';
import 'package:phsar_kaksekor_app/widgets/common/status_badge.dart';
import 'package:phsar_kaksekor_app/modals/my_products_modal.dart';
import 'package:phsar_kaksekor_app/modals/add_product_modal.dart';
import 'package:phsar_kaksekor_app/modals/seller_orders_modal.dart';
import 'package:phsar_kaksekor_app/screens/seller/seller_profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:phsar_kaksekor_app/models/order_model.dart';

class SellerDashboardScreen extends StatefulWidget {
  const SellerDashboardScreen({super.key});

  @override
  State<SellerDashboardScreen> createState() => _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends State<SellerDashboardScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final userId = context.read<AuthProvider>().currentUser!.id;
      context.read<ProductProvider>().fetchSellerProducts(userId);
      context.read<OrderProvider>().fetchSellerOrders(userId);
    });
  }

  int _currentTab = 0;

  void _openAddProduct() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddProductModal(),
    );
  }

  void _openMyProducts() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const MyProductsModal(),
    );
  }

  void _openOrders() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SellerOrdersModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorOff,
      body: IndexedStack(
        index: _currentTab,
        children: [
          _buildDashboardBody(),
          const SellerProfileScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildDashboardBody() {
    final auth = context.watch<AuthProvider>();
    final orders = context.watch<OrderProvider>();

    final sellerName = auth.currentUser?.name ?? 'Seller';
    final initial = sellerName.isNotEmpty ? sellerName[0].toUpperCase() : 'S';
    final recentOrders = orders.sellerOrders.take(3).toList();

    return Column(
      children: [
        // ── Header ──────────────────────────────────────────────────────────
        Container(
          color: colorDark,
          padding: const EdgeInsets.fromLTRB(15, kHeaderPaddingTop, 15, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning,',
                style: TextStyle(
                  fontFamily: 'DM Sans',
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    sellerName,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _currentTab = 1),
                    child: Container(
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
                  ),
                ],
              ),
              const SizedBox(height: 30),
              GridView.count(
                padding: EdgeInsets.zero,
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  StatCard(value: '\$128', label: 'This month'),
                  StatCard(value: '7', label: 'New orders'),
                  StatCard(value: '4', label: 'Products listed'),
                  StatCard(value: '4.8'+'★', label: 'Avg rating'),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),

        // ── Scrollable body ────────────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(kScreenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _ActionBtn(
                        label: '＋ Add Product',
                        isPrimary: true,
                        onTap: _openAddProduct,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: _ActionBtn(
                        label: '📦 Products',
                        isPrimary: false,
                        onTap: _openMyProducts,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: _ActionBtn(
                        label: '📋 Orders',
                        isPrimary: false,
                        onTap: _openOrders,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kSectionGap),
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
                  ...recentOrders.map(
                        (order) => _CompactOrderCard(order: order),
                  ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.grid_view_outlined, 'activeIcon': Icons.grid_view, 'label': 'Dashboard'},
      {'icon': Icons.person_outline, 'activeIcon': Icons.person, 'label': 'Profile'},
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: colorG200, width: 1)),
      ),
      padding: const EdgeInsets.only(bottom: 24, top: 10),
      child: Row(
        children: List.generate(items.length, (i) {
          final isActive = _currentTab == i;
          final item = items[i];
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _currentTab = i),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isActive
                        ? item['activeIcon'] as IconData
                        : item['icon'] as IconData,
                    color: isActive ? colorAccent : colorG400,
                    size: kNavIconSize,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['label'] as String,
                    style: TextStyle(
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w700,
                      fontSize: 8.5,
                      color: isActive ? colorAccent : colorG400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
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
                Row(
                  children: [
                    Text(
                      'ID: ${order.id.substring(0, 8)}...',
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                        color: colorTextDark,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.copy, size: 16),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: order.id));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('ID copied to clipboard')),
                        );
                      },
                    ),
                  ],
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