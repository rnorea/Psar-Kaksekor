import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:phsar_kaksekor_app/core/constants/app_colors.dart';
import 'package:phsar_kaksekor_app/core/constants/app_text_styles.dart';
import 'package:phsar_kaksekor_app/core/constants/app_constants.dart';
import 'package:phsar_kaksekor_app/models/user_model.dart';
import 'package:phsar_kaksekor_app/providers/auth_provider.dart';
import 'package:phsar_kaksekor_app/providers/order_provider.dart';
import 'package:phsar_kaksekor_app/providers/product_provider.dart';
import 'package:phsar_kaksekor_app/providers/user_provider.dart';
import 'package:phsar_kaksekor_app/widgets/common/toggle_switch.dart';
import 'package:phsar_kaksekor_app/widgets/common/action_row.dart';
import 'package:phsar_kaksekor_app/widgets/seller/earnings_card.dart';
import 'package:phsar_kaksekor_app/widgets/seller/linked_account_chip.dart';
import 'package:phsar_kaksekor_app/modals/my_products_modal.dart';
import 'package:phsar_kaksekor_app/modals/add_product_modal.dart';
import 'package:phsar_kaksekor_app/modals/seller_orders_modal.dart';
import 'package:phsar_kaksekor_app/Data/mock_data.dart';

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
    final user = context.watch<UserProvider>();

    final profile = auth.currentUser;
    if (profile == null) return const SizedBox();

    final farmName = profile.farmName ?? 'My Farm';
    final activeListings = products.allProducts.where((p) => p.stock > 0).length;
    final lowStockCount = products.allProducts.where((p) => p.stock > 0 && p.stock < 10).length;
    final totalOrders = orders.sellerOrders.length;

    return Scaffold(
      backgroundColor: colorOff,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Hero (same layout as buyer) ──────────────────────────────
            _buildProfileHeader(profile, farmName),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                  kScreenPadding, kSectionGap, kScreenPadding, 0),
              child: Column(
                children: [
                  // Account Info
                  _buildAccountInfo(profile),

                  // Business Info
                  _buildBusinessInfo(profile, farmName),

                  // Earnings
                  _buildEarnings(totalOrders),

                  // Product Management
                  _buildProductManagement(activeListings, lowStockCount),

                  // Preferences
                  _buildPreferences(user),

                  // Account actions
                  _buildAccountActions(context, auth),

                  const SizedBox(height: kSectionGap),

                  // Switch to buyer
                  // _buildSwitchRoleButton(context, auth),

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
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(UserModel profile, String farmName) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: colorDark,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(kRadiusProfile),
          bottomRight: Radius.circular(kRadiusProfile),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(15, kHeaderPaddingTop, 15, 22),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: kAvatarLarge,
                height: kAvatarLarge,
                decoration: BoxDecoration(
                  color: colorLight,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 2.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  profile.avatarInitial,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w900,
                    fontSize: 26,
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
                  child: const Text('✏', style: TextStyle(fontSize: 10)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            profile.name,
            style: titleXL.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            farmName,
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '📍 ${profile.province ?? profile.location}',
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 10,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(kRadiusBtn),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25),
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

  Widget _buildAccountInfo(UserModel profile) {
    return _Section(
      title: '👤 Account Info',
      children: [
        _Row(icon: '✉️', label: 'Email', value: profile.email),
        _Row(icon: '📞', label: 'Phone', value: profile.phone),
        _Row(icon: '📍', label: 'Location', value: profile.location, isLast: true),
      ],
    );
  }

  Widget _buildBusinessInfo(UserModel profile, String farmName) {
    return _Section(
      title: '🌾 Business Info',
      children: [
        _Row(label: '🏡 Farm Name', value: farmName),
        _Row(label: '🌱 Produce Type', value: profile.produceType ?? 'Mixed Vegetables'),
        _Row(label: '📍 Province', value: profile.province ?? 'Phnom Penh'),
        _Row(
          label: '✓ Certification',
          isLast: true,
          valueWidget: profile.isOrganic
              ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: colorPale,
              borderRadius: BorderRadius.circular(kRadiusBadge),
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
    );
  }

  Widget _buildEarnings(int totalOrders) {
    return _Section(
      title: '💰 Earnings',
      children: [
        Row(
          children: [
            Expanded(child: EarningsCard(value: '\$32', label: 'This week')),
            const SizedBox(width: 6),
            Expanded(child: EarningsCard(value: '\$128', label: 'This month')),
            const SizedBox(width: 6),
            Expanded(child: EarningsCard(value: '\$984', label: 'This year')),
          ],
        ),
        const SizedBox(height: 8),
        _Row(label: '⭐ Avg Rating', value: '4.8 / 5.0'),
        _Row(label: '📦 Total Orders', value: '$totalOrders', isLast: true),
      ],
    );
  }

  Widget _buildProductManagement(int activeListings, int lowStockCount) {
    return _Section(
      title: '📦 Product Management',
      children: [
        _Row(
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
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3CD),
                    borderRadius: BorderRadius.circular(kRadiusBadge),
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
            Expanded(child: _Btn(label: '📦 Products', isPrimary: false, onTap: _openMyProducts)),
            const SizedBox(width: 6),
            Expanded(child: _Btn(label: '📋 Orders', isPrimary: false, onTap: _openOrders)),
            const SizedBox(width: 6),
            Expanded(child: _Btn(label: '＋ Add', isPrimary: true, onTap: _openAddProduct)),
          ],
        ),
      ],
    );
  }

  Widget _buildPreferences(UserProvider user) {
    return _Section(
      title: '⚙️ Preferences',
      children: [
        _Row(
          label: '🔔 Notifications',
          valueWidget: ToggleSwitch(
            value: _notificationsOn,
            onChanged: (v) => setState(() => _notificationsOn = v),
          ),
        ),
        _Row(
          label: '💬 SMS Alerts',
          valueWidget: ToggleSwitch(
            value: _smsAlertsOn,
            onChanged: (v) => setState(() => _smsAlertsOn = v),
          ),
        ),
        _Row(label: '🌐 Language', value: 'English'),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 7, top: 7),
              child: Text(
                'Linked Accounts',
                style: TextStyle(fontFamily: 'DM Sans', fontSize: 10.5, color: colorG600),
              ),
            ),
            Row(
              children: [
                LinkedAccountChip(label: 'Google', isConnected: true, onTap: () {}),
                const SizedBox(width: 7),
                LinkedAccountChip(label: 'Apple', isConnected: false, onTap: () {}),
                const SizedBox(width: 7),
                LinkedAccountChip(label: 'Facebook', isConnected: false, onTap: () {}),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAccountActions(BuildContext context, AuthProvider auth) {
    return _Section(
      title: 'Account',
      children: [
        ActionRow(icon: '❓', label: 'Help & Support', iconBg: const Color(0xFFF0F9FF), onTap: () {}),
        ActionRow(icon: '📄', label: 'Terms & Privacy', iconBg: const Color(0xFFF5F5FF), onTap: () {}),
        ActionRow(icon: '🎁', label: 'Invite Friends', iconBg: const Color(0xFFFFF5E8), onTap: () {}),
        ActionRow(
          icon: '🚪',
          label: 'Log Out',
          iconBg: const Color(0xFFFFEAEA),
          isDanger: true,
          isLast: true,
          onTap: () => _confirmLogout(context, auth),
        ),
      ],
    );
  }

  Widget _buildSwitchRoleButton(BuildContext context, AuthProvider auth) {
    return GestureDetector(
      onTap: () {
        context.read<OrderProvider>().setBuyerOrders(mockBuyerOrders);
        auth.setUser(mockBuyerUser);
        auth.switchRole(UserRole.buyer);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kRadiusBtn),
          border: Border.all(color: colorG200, width: 1.5),
        ),
        alignment: Alignment.center,
        child: const Text(
          '🛒 Switch to Buyer Mode',
          style: TextStyle(
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w700,
            fontSize: 12,
            color: colorAccent,
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, AuthProvider auth) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(kRadiusModal)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(15, 14, 15, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36, height: 4,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(color: colorG200, borderRadius: BorderRadius.circular(2)),
            ),
            Text('Log Out?', style: titleMed),
            const SizedBox(height: 6),
            Text('Are you sure you want to log out?', style: metaText),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorRed,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadiusBtn)),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.pop(context);
                auth.logout();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login', // or '/welcome', whatever your login route is named
                      (route) => false, // removes all previous routes from stack
                );
              },
              child: const Text('Yes, Log Out'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: colorG600,
                minimumSize: const Size(double.infinity, 44),
                side: const BorderSide(color: colorG200),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadiusBtn)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared private helpers ────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({required this.title, required this.children});

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
            Text(title, style: const TextStyle(
              fontFamily: 'Nunito', fontWeight: FontWeight.w800,
              fontSize: 11.5, color: colorTextDark,
            )),
            const SizedBox(height: 10),
          ],
          ...children,
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String? icon;
  final String? value;
  final Widget? valueWidget;
  final bool isLast;

  const _Row({
    required this.label,
    this.icon,
    this.value,
    this.valueWidget,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: isLast ? 0 : 7),
      decoration: BoxDecoration(
        border: isLast ? null : const Border(bottom: BorderSide(color: colorG100, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            if (icon != null) ...[
              Text(icon!, style: const TextStyle(fontSize: 13)),
              const SizedBox(width: 6),
            ],
            Text(label, style: const TextStyle(
              fontFamily: 'DM Sans', fontSize: 10.5, color: colorG600,
            )),
          ]),
          valueWidget ?? Text(value ?? '', style: const TextStyle(
            fontFamily: 'Nunito', fontWeight: FontWeight.w600,
            fontSize: 10.5, color: colorTextDark,
          )),
        ],
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  const _Btn({required this.label, required this.isPrimary, required this.onTap});

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
        child: Text(label, style: TextStyle(
          fontFamily: 'Nunito', fontWeight: FontWeight.w800,
          fontSize: 10, color: isPrimary ? Colors.white : colorMid,
        )),
      ),
    );
  }
}