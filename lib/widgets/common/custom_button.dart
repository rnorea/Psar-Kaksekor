import 'package:flutter/material.dart';
import 'package:phsar_kaksekor_app/core/constants/app_colors.dart';
import 'package:phsar_kaksekor_app/core/constants/app_constants.dart';

enum ButtonVariant { primary, secondary, actionPrimary, actionSecondary }

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = ButtonVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case ButtonVariant.secondary:
        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: colorAccent,
            minimumSize: const Size(double.infinity, 42),
            side: const BorderSide(color: colorG200, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kRadiusBtn),
            ),
            elevation: 0,
            textStyle: const TextStyle(
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          onPressed: onPressed,
          child: Text(label),
        );

      case ButtonVariant.actionPrimary:
        return Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorDark,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              textStyle: const TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w800,
                fontSize: 10.5,
              ),
            ),
            onPressed: onPressed,
            child: Text(label),
          ),
        );

      case ButtonVariant.actionSecondary:
        return Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorG100,
              foregroundColor: colorMid,
              padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              textStyle: const TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w800,
                fontSize: 10.5,
              ),
            ),
            onPressed: onPressed,
            child: Text(label),
          ),
        );

      case ButtonVariant.primary:
      default:
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorDark,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 46),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kRadiusBtn),
            ),
            elevation: 0,
            textStyle: const TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w900,
              fontSize: 12.5,
            ),
          ),
          onPressed: onPressed,
          child: Text(label),
        );
    }
  }
}