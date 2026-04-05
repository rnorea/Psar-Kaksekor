import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:phsar_kaksekor_app/core/constants/app_colors.dart';
import 'package:phsar_kaksekor_app/core/constants/app_text_styles.dart';
import 'package:phsar_kaksekor_app/core/constants/app_constants.dart';
import 'package:phsar_kaksekor_app/providers/order_provider.dart';
import 'package:phsar_kaksekor_app/widgets/buyer/order_card_buyer.dart';
import 'package:phsar_kaksekor_app/widgets/common/bottom_sheet_handle.dart';

class BuyerOrdersModal extends StatefulWidget {
  const BuyerOrdersModal({super.key});

  @override
  State<BuyerOrdersModal> createState() => _BuyerOrdersModalState();
}

class _BuyerOrdersModalState extends State<BuyerOrdersModal> {
  String _selectedTab = 'All';
  final List<String> _tabs = ['All', 'Active', 'Delivered'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: colorOff,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(kRadiusModal),
          topRight: Radius.circular(kRadiusModal),
        ),
      ),
      child: Column(
        children: [
          const BottomSheetHandle(),
          _buildModalHeader(),
          _buildFilterTabs(),
          const SizedBox(height: kSectionGap),
          Expanded(child: _buildOrdersList()),
        ],
      ),
    );
  }

  Widget _buildModalHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 4, 15, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('📦 My Orders', style: titleXL),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: colorG100,
                borderRadius: BorderRadius.circular(kRadiusSmall),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.close, size: 14, color: colorG600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: SizedBox(
        height: 32,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding:
              const EdgeInsets.symmetric(horizontal: kScreenPadding),
          itemCount: _tabs.length,
          separatorBuilder: (_, __) => const SizedBox(width: 7),
          itemBuilder: (_, i) {
            final tab = _tabs[i];
            final isActive = tab == _selectedTab;
            return GestureDetector(
              onTap: () => setState(() => _selectedTab = tab),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: isActive ? colorDark : colorG100,
                  borderRadius: BorderRadius.circular(kRadiusChip),
                ),
                child: Text(
                  tab,
                  style: TextStyle(
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                    color: isActive ? Colors.white : colorG600,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrdersList() {
    return Consumer<OrderProvider>(
      builder: (context, provider, _) {
        final orders = switch (_selectedTab) {
          'Active' => provider.activeOrders,
          'Delivered' => provider.deliveredOrders,
          _ => provider.buyerOrders,
        };

        if (orders.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: kScreenPadding),
          itemCount: orders.length,
          separatorBuilder: (_, __) => const SizedBox(height: kListGap),
          itemBuilder: (_, i) => OrderCardBuyer(order: orders[i]),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    final messages = {
      'Active': ('📭', 'No active orders', 'Your current orders will appear here'),
      'Delivered': ('📦', 'No delivered orders', 'Completed orders will appear here'),
      'All': ('🛍️', 'No orders yet', 'Start shopping to see your orders here'),
    };

    final (emoji, title, sub) = messages[_selectedTab]!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 42)),
            const SizedBox(height: 12),
            Text(title, style: titleMed),
            const SizedBox(height: 4),
            Text(sub, style: metaText, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
