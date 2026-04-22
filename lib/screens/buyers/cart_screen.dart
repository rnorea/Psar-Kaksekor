import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:phsar_kaksekor_app/widgets/buyer/order_card_buyer.dart';
import 'package:phsar_kaksekor_app/modals/buyer_orders_modal.dart';
import 'package:phsar_kaksekor_app/core/constants/app_colors.dart';
import 'package:phsar_kaksekor_app/core/constants/app_text_styles.dart';
import 'package:phsar_kaksekor_app/core/constants/app_constants.dart';
import 'package:phsar_kaksekor_app/providers/cart_provider.dart';
import 'package:phsar_kaksekor_app/providers/order_provider.dart';
import 'package:phsar_kaksekor_app/providers/auth_provider.dart';
import 'package:phsar_kaksekor_app/widgets/buyer/cart_item.dart';
import 'package:phsar_kaksekor_app/widgets/buyer/payment_option.dart';
import 'package:phsar_kaksekor_app/modals/buyer_orders_modal.dart';
import 'package:phsar_kaksekor_app/screens/buyers/buyer_home_screen.dart';

class CartScreen extends StatefulWidget {
  final VoidCallback? onBrowseTap;
  const CartScreen({super.key, this.onBrowseTap});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String _selectedPayment = 'Cash';

  final List<Map<String, String>> _paymentMethods = [
    {'label': '💵 Cash', 'value': 'Cash'},
    {'label': '💳 Card', 'value': 'Card'},
    {'label': '📱 QR', 'value': 'QR'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorOff,
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          return Column(
            children: [
              // _buildOrdersPreview(),
              _buildHeader(cart),
              Expanded(
                child: cart.items.isEmpty
                    ? _buildEmptyState()
                    : _buildCartBody(cart),
              ),


            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(CartProvider cart) {
    return Container(
      decoration: const BoxDecoration(
        color: colorDark,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(kRadiusHeader),
          bottomRight: Radius.circular(kRadiusHeader),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(15, kHeaderPaddingTop, 15, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 30,
            ),
            child: Text('🛒 My Cart', style: titleLarge),
          ),
          if (cart.itemCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: colorYellow,
                borderRadius: BorderRadius.circular(kRadiusBadge),
              ),
              child: Text(
                '${cart.itemCount} items',
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                  color: colorDark,
                ),
              ),
            ),
        ],
      ),
    );
  }
  Widget _buildCartBody(CartProvider cart) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: kScreenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: kSectionGap),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cart.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: kListGap),
            itemBuilder: (context, i) {
              final item = cart.items[i];
              return CartItemWidget(
                item: item,
                onDelete: () =>
                    context.read<CartProvider>().removeItem(item.productId),
              );
            },
          ),
          const SizedBox(height: kSectionGap),
          Text('Payment Method', style: sectionTitle),
          const SizedBox(height: 9),
          Row(
            children: _paymentMethods.map((method) {
              final isLast = method == _paymentMethods.last;
              return Padding(
                padding: EdgeInsets.only(right: isLast ? 0 : 7),
                child: PaymentOption(
                  label: method['label']!,
                  isSelected: _selectedPayment == method['value'],
                  onTap: () =>
                      setState(() => _selectedPayment = method['value']!),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: kSectionGap),
          _buildPriceSummary(cart),
          const SizedBox(height: kSectionGap),
          _buildPlaceOrderButton(cart),
          const SizedBox(height: 15),
          _buildViewOrderButton(width: double.infinity)
        ],
      ),
    );
  }

  Widget _buildPriceSummary(CartProvider cart) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kRadiusCard),
        boxShadow: const [kCardShadow],
      ),
      padding: const EdgeInsets.all(kCardPadding + 2),
      child: Column(
        children: [
          _priceRow('Subtotal', '\$${cart.subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 7),
          _priceRow('Delivery fee', '\$${cart.deliveryFee.toStringAsFixed(2)}'),
          const SizedBox(height: 7),
          _priceRow('Service fee (5%)', '\$${cart.platformFee.toStringAsFixed(2)}'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 9),
            child: Divider(color: colorG200, height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: titleMed),
              Text('\$${cart.total.toStringAsFixed(2)}', style: priceXL),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: bodySmall),
        Text(value, style: bodyMed),
      ],
    );
  }

  Widget _buildPlaceOrderButton(CartProvider cart) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorDark,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 46),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kRadiusBtn)),
            elevation: 0,
            textStyle: const TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w900,
                fontSize: 12.5),
          ),
          onPressed: () => _placeOrder(cart),
          child: Text('✓ Place Order — \$${cart.total.toStringAsFixed(2)}'),
        ),
        // const SizedBox(height: 8),
        // Consumer<OrderProvider>(
        //   builder: (context, orderProvider, _) {
        //     return ElevatedButton(
        //       style: ElevatedButton.styleFrom(
        //         backgroundColor: Colors.white,
        //         foregroundColor: colorDark,
        //         minimumSize: const Size(double.infinity, 46),
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(kRadiusBtn),
        //           side: const BorderSide(color: colorDark, width: 1.5),
        //         ),
        //         elevation: 0,
        //         textStyle: const TextStyle(
        //             fontFamily: 'Nunito',
        //             fontWeight: FontWeight.w900,
        //             fontSize: 12.5),
        //       ),
        //       onPressed: () => _openOrdersModal(),
        //       child: const Text('📦 See Orders'),
        //     );
        //   },
        // ),
      ],
    );
  }

  Widget _buildViewOrderButton({
    double width =double.infinity,
    double height=46}){
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          // foregroundColor: colorDark,
          fixedSize: Size(width, height),
          minimumSize: Size(width, height),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kRadiusBtn),
            side: const BorderSide(color: colorDark, width: 1.5),
          ),
          elevation: 0,
          // textStyle: const TextStyle(
          //     fontFamily: 'Nunito',
          //     color: colorDark,
          //     fontWeight: FontWeight.w900,
          //     fontSize: 12.5),
        ),
        onPressed: () => _openOrdersModal(),
        child: const Text(
          '📦 See Orders',
          style: TextStyle(
            color: colorDark
          ),
        ),
      )
    );
  }

  void _placeOrder(CartProvider cart) {
    final auth = context.read<AuthProvider>();
    final user = auth.currentUser;

    context.read<OrderProvider>().placeOrder(
      id: '#ORD-${DateTime.now().millisecondsSinceEpoch}',
      farmName: 'Psar Kaksekor',
      items: cart.items.toList(),
      total: cart.total,
      buyerName: user?.name ?? 'Guest',
      deliveryAddress: user?.location ?? 'Phnom Penh',
    );

    cart.clearCart();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🎉 Order placed successfully!')),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: sectionTitle);
  }

  Widget _buildBroweProductsButton(){
    return SizedBox(
      width: 200,
      height: 50,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: colorDark,
          side: const BorderSide(color: colorG200, width: 1.5),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kRadiusBtn)),
        ),
        onPressed: widget.onBrowseTap,
        child: const Text(
          'Browse Products',
          style: TextStyle(
              fontSize: 15.0
          ),
        ),
      ),
    );
  }
  void _openOrdersModal() {
    showBuyerOrders(
      context,
      context.read<OrderProvider>().buyerOrders,
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🛒', style: TextStyle(fontSize: 52)),
            const SizedBox(height: 14),
            Text('Your cart is empty', style: titleMed),
            const SizedBox(height: 6),
            Text(
              'Browse fresh produce and add\nsome items to get started.',
              style: bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                _buildBroweProductsButton(),
                SizedBox(height: 5),
                _buildViewOrderButton(height: 50, width: 200),

              ],
            ),

          ],
        ),
      ),
    );
  }
}