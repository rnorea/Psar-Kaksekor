import 'package:flutter/material.dart';
import 'package:phsar_kaksekor_app/core/constants/app_colors.dart';
import 'package:phsar_kaksekor_app/core/constants/app_constants.dart';
import 'package:phsar_kaksekor_app/models/order_model.dart';

class StatusBadge extends StatelessWidget {
  final OrderStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final config = _statusConfig(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: config.bg,
        borderRadius: BorderRadius.circular(kRadiusBadge),
      ),
      child: Text(
        config.label,
        style: TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w800,
          fontSize: 9,
          color: config.text,
        ),
      ),
    );
  }
}

class _BadgeConfig {
  final Color bg;
  final Color text;
  final String label;
  const _BadgeConfig(this.bg, this.text, this.label);
}

_BadgeConfig _statusConfig(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return const _BadgeConfig(statusPendingBg, statusPendingText, 'Pending');
    case OrderStatus.confirmed:
      return const _BadgeConfig(statusConfirmedBg, statusConfirmedText, 'Confirmed');
    case OrderStatus.onWay:
      return const _BadgeConfig(statusOnWayBg, statusOnWayText, 'On the Way');
    case OrderStatus.delivered:
      return const _BadgeConfig(statusDeliveredBg, statusDeliveredText, 'Delivered');
  }
}