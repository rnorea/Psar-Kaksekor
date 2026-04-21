import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:phsar_kaksekor_app/core/constants/app_colors.dart';
import 'package:phsar_kaksekor_app/core/constants/app_constants.dart';
import 'package:phsar_kaksekor_app/models/order_model.dart';
import 'package:phsar_kaksekor_app/providers/order_provider.dart';
import 'package:phsar_kaksekor_app/widgets/common/bottom_sheet_handle.dart';
import 'package:phsar_kaksekor_app/widgets/common/status_badge.dart';
import 'package:phsar_kaksekor_app/widgets/common/progress_tracker.dart';

class SellerOrdersModal extends StatefulWidget {
  const SellerOrdersModal({super.key});

  @override
  State<SellerOrdersModal> createState() => _SellerOrdersModalState();
}

class _SellerOrdersModalState extends State<SellerOrdersModal> {
  int _selectedTab = 0;

  List<OrderModel> _filteredOrders(List<OrderModel> all) {
    switch (_selectedTab) {
      case 1:
        return all
            .where((o) => o.status == OrderStatus.pending)
            .toList();
      case 2:
        return all
            .where((o) => o.status == OrderStatus.confirmed)
            .toList();
      case 3:
        return all
            .where((o) => o.status == OrderStatus.onWay)
            .toList();
      case 4:
        return all
            .where((o) => o.status == OrderStatus.delivered)
            .toList();
      default:
        return all;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrderProvider>().sellerOrders;
    final filtered = _filteredOrders(orders);

    // Tab counts
    final counts = [
      orders.length,
      orders.where((o) => o.status == OrderStatus.pending).length,
      orders.where((o) => o.status == OrderStatus.confirmed).length,
      orders.where((o) => o.status == OrderStatus.onWay).length,
      orders.where((o) => o.status == OrderStatus.delivered).length,
    ];

    final tabLabels = [
      'All',
      'Pending',
      'Confirmed',
      'On the Way',
      'Delivered',
    ];

    return Container(
      decoration: const BoxDecoration(
        color: colorOff,
        borderRadius: BorderRadius.vertical(top: Radius.circular(kRadiusModal)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      child: Column(
        children: [
          // ── Handle ────────────────────────────────────────────────────────
          const BottomSheetHandle(),

          // ── Header ────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 4, 14, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '📋 Manage Orders',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: colorTextDark,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: colorG100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '✕',
                      style: TextStyle(
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: colorG600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Filter tabs ───────────────────────────────────────────────────
          SizedBox(
            height: 34,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: tabLabels.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (context, i) {
                final isActive = _selectedTab == i;
                final label =
                    '${tabLabels[i]}${counts[i] > 0 ? ' (${counts[i]})' : ''}';
                return GestureDetector(
                  onTap: () => setState(() => _selectedTab = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isActive ? colorDark : colorG100,
                      borderRadius: BorderRadius.circular(kRadiusChip),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      label,
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

          const SizedBox(height: 10),

          // ── Order list ────────────────────────────────────────────────────
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('📭', style: TextStyle(fontSize: 32)),
                        const SizedBox(height: 10),
                        Text(
                          'No orders here',
                          style: TextStyle(
                            fontFamily: 'DM Sans',
                            fontSize: 12,
                            color: colorG400,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 24),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return _OrderCardSeller(order: filtered[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Order card for seller ─────────────────────────────────────────────────────

class _OrderCardSeller extends StatelessWidget {
  final OrderModel order;

  const _OrderCardSeller({required this.order});

  int get _step {
    switch (order.status) {
      case OrderStatus.pending:
        return 0;
      case OrderStatus.confirmed:
        return 1;
      case OrderStatus.onWay:
        return 2;
      case OrderStatus.delivered:
        return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemsSummary =
        order.items.map((i) => '${i.quantity}× ${i.name}').join(', ');

    final dateStr =
        '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year} · ${order.buyerName}';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kRadiusCard),
        boxShadow: const [kCardShadow],
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top: order ID + status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
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
                  Text(
                    dateStr,
                    style: const TextStyle(
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w400,
                      fontSize: 9.5,
                      color: colorG400,
                    ),
                  ),
                ],
              ),
              StatusBadge(status: order.status),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            itemsSummary,
            style: const TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 10,
              color: colorG600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            '📍 ${order.deliveryAddress}',
            style: const TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 9.5,
              color: colorG400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            'Total: \$${order.total.toStringAsFixed(2)}',
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
              fontSize: 11.5,
              color: colorDark,
            ),
          ),
          const SizedBox(height: 12),

          // Progress tracker
          ProgressTracker(currentStep: _step),
          const SizedBox(height: 10),

          // Action buttons
          _buildActions(context),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final provider = context.read<OrderProvider>();

    Widget primaryBtn(String label, VoidCallback onTap) => _CardBtn(
          label: label,
          color: colorDark,
          textColor: Colors.white,
          onTap: onTap,
        );

    Widget ghostBtn(String label, VoidCallback onTap) => _CardBtn(
          label: label,
          color: colorG100,
          textColor: colorMid,
          onTap: onTap,
        );

    Widget redBtn(String label, VoidCallback onTap) => _CardBtn(
          label: label,
          color: deleteBg,
          textColor: colorRed,
          onTap: onTap,
        );

    void advance() => provider.advanceOrder(order.id);
    void cancel() => provider.cancelOrder(order.id);

    switch (order.status) {
      case OrderStatus.pending:
        return Row(children: [
          Expanded(child: primaryBtn('✓ Confirm Order', advance)),
          const SizedBox(width: 6),
          Expanded(child: redBtn('✕ Cancel', cancel)),
        ]);
      case OrderStatus.confirmed:
        return Row(children: [
          Expanded(child: primaryBtn('🚚 Mark as Shipped', advance)),
          const SizedBox(width: 6),
          Expanded(child: ghostBtn('✉ Message', () {})),
        ]);
      case OrderStatus.onWay:
        return Row(children: [
          Expanded(child: primaryBtn('📦 Mark Delivered', advance)),
          const SizedBox(width: 6),
          Expanded(child: ghostBtn('✉ Message', () {})),
        ]);
      case OrderStatus.delivered:
        return Row(children: [
          Expanded(child: ghostBtn('↻ Restock', () {})),
        ]);
    }
  }
}

class _CardBtn extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const _CardBtn({
    required this.label,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(kRadiusSmall),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w800,
            fontSize: 10,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
