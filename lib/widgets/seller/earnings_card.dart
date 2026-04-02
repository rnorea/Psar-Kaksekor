import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class EarningsCard extends StatelessWidget {
  final String value;
  final String label;

  const EarningsCard({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: colorPale,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w900,
                fontSize: 14,
                color: colorDark,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 8.5,
                color: colorG600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}