import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/common/toggle_switch.dart';
import '../../widgets/common/action_row.dart';
import '../../widgets/seller/earnings_card.dart';
import '../../widgets/seller/linked_account_chip.dart';
import '../seller/products/my_products_modal.dart';
import '../seller/products/add_product_modal.dart';
import '../seller/orders/seller_orders_modal.dart';

class SellerProfileScreen extends StatefulWidget {
  const SellerProfileScreen({super.key});

  @override
  State<SellerProfileScreen> createState() => _SellerProfileScreenState();
}

class _SellerProfileScreenState extends State<SellerProfileScreen> {
  bool _notificationsOn = true;
  bool _smsAlertsOn = false;

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

  void _openAddProduct() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddProductModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final orders = context.watch<OrderProvider>();
    final products = context.watch<ProductProvider>();

    final user = auth.currentUser;
    final sellerName = user?.name ?? 'Seller';
    final farmName = user?.farmName ?? 'My Farm';
    final initial = sellerName.isNotEmpty ? sellerName[0].toUpperCase() : 'S';

    final activeListings =
        products.allProducts.where((p) => p.stock > 0).length;
    final lowStockCount =
        products.allProducts.where((p) => p.stock > 0 && p.stock < 10).length;
    final totalOrders = orders.sellerOrders.length;

    return Scaffold(
      backgroundColor: colorOff,
      body: Column(
        children: [
          // ── Profile Hero ─────────────────────────────────────────────────
          _ProfileHero(
            sellerName: sellerName,
            farmName: farmName,
            initial: initial,
            location: user?.province ?? 'Cambodia',
            auth: auth,
          ),

          // ── Scrollable body ───────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
              child: Column(
                children: [
                  // Business Info
                  _ProfileSection(
                    title: '🌾 Business Info',
                    children: [
                      _ProfileRow(label: '🏡 Farm Name', value: farmName),
                      _ProfileRow(
                          label: '🌱 Produce Type',
                          value: user?.produceType ?? 'Mixed Vegetables'),
                      _ProfileRow(
                          label: '📍 Province',
                          value: user?.province ?? 'Phnom Penh'),
                      _ProfileRow(
                        label: '✓ Certification',
                        isLast: true,
                        valueWidget: user?.isOrganic == true
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: colorPale,
                                  borderRadius:
                                      BorderRadius.circular(kRadiusBadge),
                                ),
                                child: const Text(
                                  '✓ Organic',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w800,
                                    fontSize: 9,
                                    color: colorAccent,
                                  ),
                                ),
                              )
                            : const Text(
                                'None',
                                style: TextStyle(
                                  fontFamily: 'DM Sans',
                                  fontSize: 10.5,
                                  color: colorG400,
                                ),
                              ),
                      ),
                    ],
                  ),

                  // Earnings
                  _ProfileSection(
                    title: '💰 Earnings',
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: EarningsCard(
                                  value: '\$32', label: 'This week')),
                          const SizedBox(width: 6),
                          Expanded(
                              child: EarningsCard(
                                  value: '\$128', label: 'This month')),
                          const SizedBox(width: 6),
                          Expanded(
                              child: EarningsCard(
                                  value: '\$984', label: 'This year')),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _ProfileRow(
                          label: '⭐ Avg Rating', value: '4.8 / 5.0'),
                      _ProfileRow(
                        label: '📦 Total Orders',
                        value: '$totalOrders',
                        isLast: true,
                      ),
                    ],
                  ),

                  // Product Management
                  _ProfileSection(
                    title: '📦 Product Management',
                    children: [
                      _ProfileRow(
                        label: 'Active Listings',
                        valueWidget: Row(
                          children: [
                            Text(
                              '$activeListings products',
                              style: const TextStyle(
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w600,
                                fontSize: 10.5,
                                color: colorTextDark,
                              ),
                            ),
                            if (lowStockCount > 0) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF3CD),
                                  borderRadius:
                                      BorderRadius.circular(kRadiusBadge),
                                ),
                                child: Text(
                                  '⚠ $lowStockCount low stock',
                                  style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w800,
                                    fontSize: 9,
                                    color: Color(0xFF956E00),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _SmallActionBtn(
                              label: '📦 Products',
                              isPrimary: false,
                              onTap: _openMyProducts,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: _SmallActionBtn(
                              label: '📋 Orders',
                              isPrimary: false,
                              onTap: _openOrders,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: _SmallActionBtn(
                              label: '＋ Add',
                              isPrimary: true,
                              onTap: _openAddProduct,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Promotions & Analytics
                  _ProfileSection(
                    title: '📣 Promotions & Analytics',
                    children: [
                      _ProfileRow(label: '🏷 Discount', value: 'None active'),
                      _ProfileRow(label: '⭐ Featured', value: 'Not featured'),
                      _ProfileRow(label: '👁 Views (30d)', value: '1,240'),
                      _ProfileRow(
                          label: '🖱 Clicks', value: '312', isLast: true),
                    ],
                  ),

                  // Ratings & Reviews
                  _ProfileSection(
                    title: '⭐ Ratings & Reviews',
                    children: [
                      _ReviewRow(
                        buyerName: 'Sophea K.',
                        product: 'Fresh Broccoli',
                        stars: 5,
                        comment: 'Very fresh, delivered quickly!',
                      ),
                      _ReviewRow(
                        buyerName: 'Dara M.',
                        product: 'Jasmine Rice 5kg',
                        stars: 4,
                        comment: 'Great quality, good price.',
                        isLast: true,
                      ),
                    ],
                  ),

                  // Settings
                  _ProfileSection(
                    title: '⚙️ Settings',
                    children: [
                      _ProfileRow(
                        label: '🔔 Notifications',
                        isLast: false,
                        valueWidget: ToggleSwitch(
                          isOn: _notificationsOn,
                          onChanged: (v) =>
                              setState(() => _notificationsOn = v),
                        ),
                      ),
                      _ProfileRow(
                        label: '💬 SMS Alerts',
                        isLast: false,
                        valueWidget: ToggleSwitch(
                          isOn: _smsAlertsOn,
                          onChanged: (v) =>
                              setState(() => _smsAlertsOn = v),
                        ),
                      ),
                      _ProfileRow(
                        label: '🌐 Language',
                        value: 'English',
                        isLast: false,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 7),
                            child: Text(
                              'Linked Accounts',
                              style: TextStyle(
                                fontFamily: 'DM Sans',
                                fontSize: 10.5,
                                color: colorG600,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              LinkedAccountChip(
                                  label: 'Google',
                                  isConnected: true,
                                  onTap: () {}),
                              const SizedBox(width: 7),
                              LinkedAccountChip(
                                  label: 'Apple',
                                  isConnected: false,
                                  onTap: () {}),
                              const SizedBox(width: 7),
                              LinkedAccountChip(
                                  label: 'Facebook',
                                  isConnected: false,
                                  onTap: () {}),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Action rows
                  _ProfileSection(
                    title: '',
                    children: [
                      ActionRow(
                        icon: '❓',
                        label: 'Help & Support',
                        iconBg: const Color(0xFFF0F9FF),
                        onTap: () {},
                      ),
                      ActionRow(
                        icon: '📄',
                        label: 'Terms & Privacy',
                        iconBg: const Color(0xFFF5F5FF),
                        onTap: () {},
                      ),
                      ActionRow(
                        icon: '🎁',
                        label: 'Invite Friends',
                        iconBg: const Color(0xFFFFF5E8),
                        onTap: () {},
                      ),
                      ActionRow(
                        icon: '🚪',
                        label: 'Log Out',
                        iconBg: const Color(0xFFFFEAEA),
                        isDanger: true,
                        isLast: true,
                        onTap: () => auth.logout(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  const Text(
                    'Psar Kaksekor v1.0.0',
                    style: TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 9,
                      color: colorG400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Profile Hero ──────────────────────────────────────────────────────────────

class _ProfileHero extends StatelessWidget {
  final String sellerName;
  final String farmName;
  final String initial;
  final String location;
  final AuthProvider auth;

  const _ProfileHero({
    required this.sellerName,
    required this.farmName,
    required this.initial,
    required this.location,
    required this.auth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [colorDark, colorMid],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(kRadiusProfile),
          bottomRight: Radius.circular(kRadiusProfile),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 42, 16, 20),
      child: Column(
        children: [
          // Role toggle
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(kRadiusChip),
            ),
            padding: const EdgeInsets.all(3),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _RoleTab(
                    label: 'Buyer',
                    isActive: false,
                    onTap: () =>
                        auth.switchRole(UserRole.buyer)),
                _RoleTab(
                    label: 'Seller',
                    isActive: true,
                    onTap: () {}),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Avatar with edit overlay
          Stack(
            children: [
              Container(
                width: kAvatarLarge,
                height: kAvatarLarge,
                decoration: BoxDecoration(
                  color: colorLight,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  initial,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: colorYellow,
                    shape: BoxShape.circle,
                    border: Border.all(color: colorDark, width: 1.5),
                  ),
                  alignment: Alignment.center,
                  child: const Text('✏',
                      style: TextStyle(fontSize: 10)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          Text(
            sellerName,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Text(
            farmName,
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 11,
              color: Colors.white.withOpacity(0.65),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            '📍 $location',
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 10,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 12),

          // Edit profile button
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(kRadiusBtn),
                border: Border.all(
                  color: Colors.white.withOpacity(0.25),
                  width: 1.5,
                ),
              ),
              child: const Text(
                '✏ Edit Profile',
                style: TextStyle(
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _RoleTab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(kRadiusChip),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w700,
            fontSize: 11,
            color: isActive ? colorDark : Colors.white.withOpacity(0.6),
          ),
        ),
      ),
    );
  }
}

// ── Profile Section ───────────────────────────────────────────────────────────

class _ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _ProfileSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kRadiusCard),
        boxShadow: const [kCardShadow],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty) ...[
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w800,
                fontSize: 11.5,
                color: colorTextDark,
              ),
            ),
            const SizedBox(height: 10),
          ],
          ...children,
        ],
      ),
    );
  }
}

// ── Profile Row ───────────────────────────────────────────────────────────────

class _ProfileRow extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? valueWidget;
  final bool isLast;

  const _ProfileRow({
    required this.label,
    this.value,
    this.valueWidget,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: isLast ? 0 : 7),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: colorG100, width: 1),
              ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 10.5,
              color: colorG600,
            ),
          ),
          valueWidget ??
              Text(
                value ?? '',
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                  fontSize: 10.5,
                  color: colorTextDark,
                ),
              ),
        ],
      ),
    );
  }
}

// ── Review Row ────────────────────────────────────────────────────────────────

class _ReviewRow extends StatelessWidget {
  final String buyerName;
  final String product;
  final int stars;
  final String comment;
  final bool isLast;

  const _ReviewRow({
    required this.buyerName,
    required this.product,
    required this.stars,
    required this.comment,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
      margin: EdgeInsets.only(bottom: isLast ? 0 : 10),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: colorG100, width: 1),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '★' * stars + '☆' * (5 - stars),
                style: const TextStyle(color: colorYellow, fontSize: 11),
              ),
              const SizedBox(width: 6),
              Text(
                buyerName,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w700,
                  fontSize: 10.5,
                  color: colorTextDark,
                ),
              ),
            ],
          ),
          Text(
            product,
            style: const TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 9.5,
              color: colorG400,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            comment,
            style: const TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 10.5,
              color: colorG600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Small action button ───────────────────────────────────────────────────────

class _SmallActionBtn extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  const _SmallActionBtn({
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 6),
        decoration: BoxDecoration(
          color: isPrimary ? colorDark : colorG100,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w800,
            fontSize: 10,
            color: isPrimary ? Colors.white : colorMid,
          ),
        ),
      ),
    );
  }
}
