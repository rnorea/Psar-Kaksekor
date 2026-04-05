import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:phsar_kaksekor_app/core/constants/app_colors.dart';
import 'package:phsar_kaksekor_app/core/constants/app_text_styles.dart';
import 'package:phsar_kaksekor_app/core/constants/app_constants.dart';
import 'package:phsar_kaksekor_app/providers/cart_provider.dart';
import 'package:phsar_kaksekor_app/providers/order_provider.dart';
import 'package:phsar_kaksekor_app/widgets/buyer/cart_item.dart';
import 'package:phsar_kaksekor_app/widgets/buyer/payment_option.dart';
import 'package:phsar_kaksekor_app/widgets/common/custom_button.dart';
import 'package:phsar_kaksekor_app/widgets/common/toast_message.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

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
          Text('🛒 My Cart', style: titleLarge),
          if (cart.itemCount > 0)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
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
          // Cart items list
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cart.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: kListGap),
            itemBuilder: (_, i) => CartItemWidget(
              item: cart.items[i],
              onDelete: () =>
                  context.read<CartProvider>().removeItem(cart.items[i].productId),
            ),
          ),
          const SizedBox(height: kSectionGap),

          // Payment method
          Text('Payment Method', style: sectionTitle),
          const SizedBox(height: 9),
          Row(
            children: _paymentMethods.map((method) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: method != _paymentMethods.last ? 7 : 0,
                  ),
                  child: PaymentOption(
                    label: method['label']!,
                    isSelected: _selectedPayment == method['value'],
                    onSelect: (_) =>
                        setState(() => _selectedPayment = method['value']!),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: kSectionGap),

          // Price summary
          _buildPriceSummary(cart),
          const SizedBox(height: kSectionGap),

          // Place order button
          _buildPlaceOrderButton(cart),
          const SizedBox(height: 80),
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
          _priceRow('Subtotal', '\$${cart.subtotal.toStringAsFixed(2)}', false),
          const SizedBox(height: 7),
          _priceRow('Delivery fee', '\$0.50', false),
          const SizedBox(height: 7),
          _priceRow(
              'Service fee (5%)', '\$${cart.fee.toStringAsFixed(2)}', false),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 9),
            child: Divider(color: colorG200, height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: titleMed),
              Text(
                '\$${cart.total.toStringAsFixed(2)}',
                style: priceXL,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value, bool isBold) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: bodySmall),
        Text(
          value,
          style: isBold ? titleSmall : bodyMed,
        ),
      ],
    );
  }

  Widget _buildPlaceOrderButton(CartProvider cart) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorDark,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 46),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kRadiusBtn)),
        elevation: 0,
        textStyle: const TextStyle(
            fontFamily: 'Nunito', fontWeight: FontWeight.w900, fontSize: 12.5),
      ),
      onPressed: () => _placeOrder(cart),
      child: Text('✓ Place Order — \$${cart.total.toStringAsFixed(2)}'),
    );
  }

  void _placeOrder(CartProvider cart) {
    context
        .read<OrderProvider>()
        .placeOrder(cart.items, _selectedPayment);
    cart.clearCart();
    showToast(context, '🎉 Order placed successfully!');
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
            const SizedBox(height: 20),
            SizedBox(
              width: 160,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorAccent,
                  side: const BorderSide(color: colorG200, width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kRadiusBtn)),
                ),
                onPressed: () {
                  // Switch bottom nav to Browse tab (index 1)
                  // Parent BuyerHomeScreen handles this via IndexedStack
                },
                child: const Text('Browse Products'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
