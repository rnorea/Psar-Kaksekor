import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import 'package:phsar_kaksekor_app/models/order_model.dart';
import '../common/status_badge.dart';
import '../common/progress_tracker.dart';

class OrderCardSeller extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onAdvance;
  final VoidCallback? onCancel;
  final VoidCallback? onMessage;
  final VoidCallback? onRestock;

  const OrderCardSeller({
    super.key,
    required this.order,
    this.onAdvance,
    this.onCancel,
    this.onMessage,
    this.onRestock,
  });

  @override
  Widget build(BuildContext context) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'ID: ${order.id.substring(0, 8)}...',
                        style: titleSmall.copyWith(fontSize: 12),
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
                  Text(order.buyerName, style: metaText),
                ],
              ),
              StatusBadge(status: order.status),
            ],
          ),
          const SizedBox(height: 6),
          Text(order.itemsSummary, style: const TextStyle(fontSize: 10, color: colorG600)),
          const SizedBox(height: 4),
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
          ProgressTracker(currentStep: order.status.step),
          const SizedBox(height: 8),
          Row(children: _buildActions()),
        ],
      ),
    );
  }

  List<Widget> _buildActions() {
    switch (order.status) {
      case OrderStatus.pending:
        return [
          _ActionBtn(label: '✓ Confirm Order', isPrimary: true, onTap: onAdvance),
          const SizedBox(width: 7),
          _ActionBtn(label: '✕ Cancel', isDanger: true, onTap: onCancel),
        ];
      case OrderStatus.confirmed:
        return [
          _ActionBtn(label: '🚚 Mark as Shipped', isPrimary: true, onTap: onAdvance),
          const SizedBox(width: 7),
          _ActionBtn(label: '✉ Message', onTap: onMessage),
        ];
      case OrderStatus.onWay:
        return [
          _ActionBtn(label: '📦 Mark Delivered', isPrimary: true, onTap: onAdvance),
          const SizedBox(width: 7),
          _ActionBtn(label: '✉ Message', onTap: onMessage),
        ];
      case OrderStatus.delivered:
        return [
          _ActionBtn(label: '↻ Restock', onTap: onRestock),
        ];
    }
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final bool isDanger;
  final VoidCallback? onTap;

  const _ActionBtn({
    required this.label,
    this.isPrimary = false,
    this.isDanger = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: isPrimary ? colorDark : isDanger ? deleteBg : colorG100,
            borderRadius: BorderRadius.circular(kRadiusSmall),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
              fontSize: 10,
              color: isPrimary ? Colors.white : isDanger ? colorRed : colorTextMid,
            ),
          ),
        ),
      ),
    );
  }
}