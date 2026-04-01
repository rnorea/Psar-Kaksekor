import 'package:flutter/material.dart';
import 'package:phsar_kaksekor_app/core/constants/app_colors.dart';
import 'package:phsar_kaksekor_app/core/constants/app_constants.dart';

class ActionRow extends StatelessWidget {
  final String icon;      // emoji string
  final Color iconBg;
  final String label;
  final bool isDanger;
  final bool isLast;
  final VoidCallback? onTap;

  const ActionRow({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.label,
    this.isDanger = false,
    this.isLast = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: kRowPaddingV),
        decoration: isLast
            ? null
            : const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: colorG100, width: 1),
          ),
        ),
        child: Row(
          children: [
            // icon container
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(icon, style: const TextStyle(fontSize: 14)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: isDanger ? colorRed : colorTextDark,
                ),
              ),
            ),
            if (!isDanger)
              const Text('›', style: TextStyle(fontSize: 11, color: colorG400)),
          ],
        ),
      ),
    );
  }
}