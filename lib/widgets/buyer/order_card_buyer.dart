import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import 'package:phsar_kaksekor_app/models/order_model.dart';
import '../common/status_badge.dart';
import '../common/progress_tracker.dart';
import 'package:flutter/services.dart';

class OrderCardBuyer extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onContact;
  final VoidCallback? onCancel;
  final VoidCallback? onReorder;
  final VoidCallback? onReview;

  const OrderCardBuyer({
    super.key,
    required this.order,
    this.onContact,
    this.onCancel,
    this.onReorder,
    this.onReview,
  });

  @override
  Widget build(BuildContext context) {
    final isDelivered = order.status == OrderStatus.delivered;

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
                  Text(order.farmName, style: metaText),
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
          Row(
            children: isDelivered
                ? [
              _ActionBtn(label: '↻ Reorder', isPrimary: true, onTap: onReorder),
              const SizedBox(width: 7),
              _ActionBtn(label: '⭐ Review', onTap: onReview),
            ]
                : [
              _ActionBtn(label: '✉ Contact Seller', onTap: onContact),
              const SizedBox(width: 7),
              _ActionBtn(label: '✕ Cancel', isDanger: true, onTap: onCancel),
            ],
          ),
        ],
      ),
    );
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