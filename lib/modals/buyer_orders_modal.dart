import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import 'package:phsar_kaksekor_app/models/order_model.dart';
import '../widgets/buyer/order_card_buyer.dart';
import '../widgets/common/bottom_sheet_handle.dart';

class BuyerOrdersModal extends StatefulWidget {
  final List<OrderModel> orders;

  const BuyerOrdersModal({
    super.key,
    required this.orders,
  });

  @override
  State<BuyerOrdersModal> createState() => _BuyerOrdersModalState();
}

class _BuyerOrdersModalState extends State<BuyerOrdersModal> {
  String _filter = 'all';

  List<OrderModel> get _filtered {
    switch (_filter) {
      case 'active':
        return widget.orders.where((o) => o.status.isActive).toList();
      case 'delivered':
        return widget.orders.where((o) => o.status == OrderStatus.delivered).toList();
      default:
        return widget.orders;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(kRadiusModal)),
      ),
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.88),
      child: Column(
        children: [
          const BottomSheetHandle(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('📦 My Orders',
                  style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w900, fontSize: 15, color: colorTextDark),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 26, height: 26,
                    decoration: BoxDecoration(color: colorG100, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: const Text('✕', style: TextStyle(fontSize: 13, color: colorG600)),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: colorG100, height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  // Filter tabs
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterTab(label: 'All (${widget.orders.length})', value: 'all', selected: _filter, onTap: (v) => setState(() => _filter = v)),
                        const SizedBox(width: 5),
                        _FilterTab(label: 'Active', value: 'active', selected: _filter, onTap: (v) => setState(() => _filter = v)),
                        const SizedBox(width: 5),
                        _FilterTab(label: 'Delivered', value: 'delivered', selected: _filter, onTap: (v) => setState(() => _filter = v)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._filtered.map((order) => OrderCardBuyer(order: order)),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showBuyerOrders(BuildContext context, List<OrderModel> orders) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BuyerOrdersModal(orders: orders),
  );
}

class _FilterTab extends StatelessWidget {
  final String label;
  final String value;
  final String selected;
  final ValueChanged<String> onTap;

  const _FilterTab({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = selected == value;
    return GestureDetector(
      onTap: () => onTap(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? colorDark : colorG100,
          borderRadius: BorderRadius.circular(kRadiusBadge),
        ),
        child: Text(label,
          style: TextStyle(
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w700,
            fontSize: 10,
            color: isActive ? Colors.white : colorG600,
          ),
        ),
      ),
    );
  }
}