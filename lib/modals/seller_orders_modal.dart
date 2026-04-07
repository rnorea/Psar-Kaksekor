import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import 'package:phsar_kaksekor_app/models/order_model.dart';
import '../widgets/seller/order_card_seller.dart';
import '../widgets/common/bottom_sheet_handle.dart';

class SellerOrdersModal extends StatefulWidget {
  final List<OrderModel> orders;
  final ValueChanged<String> onAdvance;
  final ValueChanged<String> onCancel;

  const SellerOrdersModal({
    super.key,
    required this.orders,
    required this.onAdvance,
    required this.onCancel,
  });

  @override
  State<SellerOrdersModal> createState() => _SellerOrdersModalState();
}

class _SellerOrdersModalState extends State<SellerOrdersModal> {
  String _filter = 'all';

  List<OrderModel> get _filtered {
    if (_filter == 'all') return widget.orders;
    final statusMap = {
      'pending':   OrderStatus.pending,
      'confirmed': OrderStatus.confirmed,
      'shipping':  OrderStatus.onWay,
      'delivered': OrderStatus.delivered,
    };
    return widget.orders.where((o) => o.status == statusMap[_filter]).toList();
  }

  int _count(String filter) {
    if (filter == 'all') return widget.orders.length;
    final statusMap = {
      'pending':   OrderStatus.pending,
      'confirmed': OrderStatus.confirmed,
      'shipping':  OrderStatus.onWay,
      'delivered': OrderStatus.delivered,
    };
    return widget.orders.where((o) => o.status == statusMap[filter]).length;
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
                const Text('📋 Manage Orders',
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterTab(label: 'All (${_count('all')})', value: 'all', selected: _filter, onTap: (v) => setState(() => _filter = v)),
                        const SizedBox(width: 5),
                        _FilterTab(label: 'Pending (${_count('pending')})', value: 'pending', selected: _filter, onTap: (v) => setState(() => _filter = v)),
                        const SizedBox(width: 5),
                        _FilterTab(label: 'Confirmed (${_count('confirmed')})', value: 'confirmed', selected: _filter, onTap: (v) => setState(() => _filter = v)),
                        const SizedBox(width: 5),
                        _FilterTab(label: 'On the Way (${_count('shipping')})', value: 'shipping', selected: _filter, onTap: (v) => setState(() => _filter = v)),
                        const SizedBox(width: 5),
                        _FilterTab(label: 'Delivered (${_count('delivered')})', value: 'delivered', selected: _filter, onTap: (v) => setState(() => _filter = v)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._filtered.map((order) => OrderCardSeller(
                    order: order,
                    onAdvance: () => widget.onAdvance(order.id),
                    onCancel: () => widget.onCancel(order.id),
                    onMessage: () {},
                    onRestock: () {},
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showSellerOrders(
    BuildContext context,
    List<OrderModel> orders, {
      required ValueChanged<String> onAdvance,
      required ValueChanged<String> onCancel,
    }) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => SellerOrdersModal(
      orders: orders,
      onAdvance: onAdvance,
      onCancel: onCancel,
    ),
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