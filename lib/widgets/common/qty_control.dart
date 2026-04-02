import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_constants.dart';

class QtyControl extends StatelessWidget {
  final int qty;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const QtyControl({
    super.key,
    required this.qty,
    required this.onChanged,
    this.min = 1,
    this.max = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorG100,
        borderRadius: BorderRadius.circular(kRadiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QtyBtn(
            label: '−',
            onTap: qty > min ? () => onChanged(qty - 1) : null,
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 30),
            alignment: Alignment.center,
            child: Text('$qty', style: qtyVal),
          ),
          _QtyBtn(
            label: '+',
            onTap: qty < max ? () => onChanged(qty + 1) : null,
          ),
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _QtyBtn({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: onTap != null ? colorAccent : colorG400,
          ),
        ),
      ),
    );
  }
}