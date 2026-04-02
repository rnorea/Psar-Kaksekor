import 'package:flutter/material.dart';
import '../../core/constants/app_text_styles.dart';

class StatCard extends StatelessWidget {
  final String value;
  final String label;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.09),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
        borderRadius: BorderRadius.circular(11),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: statVal),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 9,
              color: Colors.white.withOpacity(0.45),
            ),
          ),
        ],
      ),
    );
  }
}