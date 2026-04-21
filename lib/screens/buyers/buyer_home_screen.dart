import 'package:flutter/material.dart';
import 'package:phsar_kaksekor_app/modals/product_detail_modal.dart';
import 'package:provider/provider.dart';
import 'package:phsar_kaksekor_app/core/constants/app_colors.dart';
import 'package:phsar_kaksekor_app/core/constants/app_text_styles.dart';
import 'package:phsar_kaksekor_app/core/constants/app_constants.dart';
import 'package:phsar_kaksekor_app/providers/cart_provider.dart';
import 'package:phsar_kaksekor_app/providers/product_provider.dart';
import 'package:phsar_kaksekor_app/providers/order_provider.dart';
import 'package:phsar_kaksekor_app/providers/auth_provider.dart';
import 'package:phsar_kaksekor_app/widgets/buyer/product_cart.dart';
import 'package:phsar_kaksekor_app/widgets/buyer/order_card_buyer.dart';
import 'package:phsar_kaksekor_app/modals/buyer_orders_modal.dart';
import 'package:phsar_kaksekor_app/screens/buyers/browse_screen.dart';
import 'package:phsar_kaksekor_app/screens/buyers/cart_screen.dart';
import 'package:phsar_kaksekor_app/screens/buyers/buyer_profile_screen.dart';

class BuyerHomeScreen extends StatefulWidget {
  const BuyerHomeScreen({super.key});

  @override
  State<BuyerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends State<BuyerHomeScreen> {
  int _currentTab = 0;
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All', '🥦 Vegetables', '🌾 Grains', '🍎 Fruits', '🌿 Herbs', '🥚 Eggs',
  ];

  final List<Widget> _screens = [];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: colorOff,
      body: IndexedStack(
        index: _currentTab,
        children: [
          _buildHomeBody(auth, cart),
          const BrowseScreen(),
          const CartScreen(),
          const BuyerProfileScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(cart),
    );
  }

  Widget _buildHomeBody(AuthProvider auth, CartProvider cart) {
    return Column(
      children: [
        _buildHeader(auth, cart),
        _buildCategoryChips(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: kScreenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: kSectionGap),
                _buildSectionTitle('🌿 Fresh Today'),
                const SizedBox(height: 9),
                _buildProductGrid(),
                const SizedBox(height: kSectionGap),
                _buildOrdersPreview(),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(AuthProvider auth, CartProvider cart) {
    final name = auth.currentUser?.name ?? 'Guest';
    final initial = auth.currentUser?.avatarInitial ?? 'G';

    return Container(
      decoration: const BoxDecoration(
        color: colorDark,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(kRadiusHeader),
          bottomRight: Radius.circular(kRadiusHeader),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(15, kHeaderPaddingTop, 15, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Good morning 👋', style: metaText.copyWith(color: colorLight)),
                  Text(name, style: titleLarge),
                ],
              ),
              Row(
                children: [
                  // Cart icon with badge
                  GestureDetector(
                    onTap: () => setState(() => _currentTab = 2),
                    child: Stack(
                      children: [
                        const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 22),
                        if (cart.itemCount > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: const BoxDecoration(
                                color: colorYellow,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${cart.itemCount}',
                                style: const TextStyle(
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w900,
                                  fontSize: 8,
                                  color: colorDark,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Avatar
                  // Container(
                  //   width: kAvatarSize,
                  //   height: kAvatarSize,
                  //   decoration: const BoxDecoration(
                  //     color: colorLight,
                  //     shape: BoxShape.circle,
                  //   ),
                  //   alignment: Alignment.center,
                  //   child: Text(
                  //     initial,
                  //     style: const TextStyle(
                  //       fontFamily: 'Nunito',
                  //       fontWeight: FontWeight.w900,
                  //       fontSize: 12,
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  // ),
                  GestureDetector(
                    onTap: () => setState(() => _currentTab = 3),
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
            ],
          ),
          const SizedBox(height: 10),
          // Search bar
          GestureDetector(
            onTap: () => setState(() => _currentTab = 1),
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(kRadiusInput),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Icon(Icons.search, color: colorG400, size: 16),
                  const SizedBox(width: 8),
                  Text('Search fresh produce…', style: hintText),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(kScreenPadding, 9, kScreenPadding, 0),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 7),
        itemBuilder: (_, i) {
          final cat = _categories[i];
          final isActive = cat == _selectedCategory;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedCategory = cat);
              context.read<ProductProvider>().setCategory(cat);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
              decoration: BoxDecoration(
                color: isActive ? colorDark : colorG100,
                borderRadius: BorderRadius.circular(kRadiusChip),
              ),
              child: Text(
                cat,
                style: chipLabel.copyWith(
                  color: isActive ? Colors.white : colorG600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: sectionTitle);
  }

  Widget _buildProductGrid() {
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        final products = provider.filteredProducts;
        if (products.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text('No products found', style: metaText),
            ),
          );
        }
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: kGridGap,
            mainAxisSpacing: kGridGap,
            childAspectRatio: 0.85,
          ),
          itemCount: products.length,
          itemBuilder: (_, i) => ProductCard(
            product: products[i],
            onTap: () =>  showProductDetail(
              context,
               products[i], 
               (qrt)=> context.read<CartProvider>().addItem(products[i], qrt),)
          ),
        );
      },
    );
  }

  Widget _buildOrdersPreview() {
    return Consumer<OrderProvider>(
      builder: (context, provider, _) {
        final recent = provider.activeOrders.take(2).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionTitle('📦 Recent Orders'),
                GestureDetector(
                  onTap: () => _openOrdersModal(),
                  child: Text('See all', style: bodySmall.copyWith(color: colorAccent)),
                ),
              ],
            ),
            const SizedBox(height: 9),
            if (recent.isEmpty)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(kRadiusCard),
                  boxShadow: const [kCardShadow],
                ),
                child: Row(
                  children: [
                    const Text('🛍️', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 10),
                    Text('No orders yet — start shopping!', style: bodySmall),
                  ],
                ),
              )
            else
              ...recent.map((order) => Padding(
                padding: const EdgeInsets.only(bottom: kListGap),
                child: OrderCardBuyer(order: order),
              )),
          ],
        );
      },
    );
  }

  // void _openOrdersModal() {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (_) => const BuyerOrdersModal(),
  //   );
  // }
  void _openOrdersModal() {
    showBuyerOrders(
      context,
      context.read<OrderProvider>().buyerOrders,
    );
  }

  Widget _buildBottomNav(CartProvider cart) {
    const items = [
      {'icon': Icons.home_outlined, 'activeIcon': Icons.home, 'label': 'Home'},
      {'icon': Icons.search_outlined, 'activeIcon': Icons.search, 'label': 'Browse'},
      {'icon': Icons.shopping_bag_outlined, 'activeIcon': Icons.shopping_bag, 'label': 'Cart'},
      {'icon': Icons.person_outline, 'activeIcon': Icons.person, 'label': 'Profile'},
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: colorG200, width: 1)),
      ),
      padding: const EdgeInsets.only(bottom: 8, top: 4),
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
                  Stack(
                    children: [
                      Icon(
                        isActive
                            ? item['activeIcon'] as IconData
                            : item['icon'] as IconData,
                        color: isActive ? colorAccent : colorG400,
                        size: kNavIconSize,
                      ),
                      if (i == 2 && cart.itemCount > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: colorYellow,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['label'] as String,
                    style: navLabel.copyWith(
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
