import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';

class PaymentOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentOption({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? colorPale : Colors.white,
            border: Border.all(
              color: isSelected ? colorAccent : colorG200,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w700,
              fontSize: 10,
              color: isSelected ? colorAccent : colorG600,
            ),
          ),
        ),
      ),
    );
  }
}