import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';

class LinkedAccountChip extends StatelessWidget {
  final String label;
  final bool isConnected;
  final VoidCallback onTap;

  const LinkedAccountChip({
    super.key,
    required this.label,
    required this.isConnected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isConnected ? colorPale : Colors.white,
          border: Border.all(
            color: isConnected ? colorAccent : colorG200,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(kRadiusSmall),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w700,
            fontSize: 9.5,
            color: isConnected ? colorAccent : colorG600,
          ),
        ),
      ),
    );
  }
}