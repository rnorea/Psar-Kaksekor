import 'package:flutter/material.dart';
import 'package:phsar_kaksekor_app/core/constants/app_colors.dart';
import 'package:phsar_kaksekor_app/core/constants/app_constants.dart';

class _StepConfig {
  final String icon;
  final String label;
  const _StepConfig(this.icon, this.label);
}

const _steps = [
  _StepConfig('📋', 'Ordered'),
  _StepConfig('✅', 'Confirmed'),
  _StepConfig('🚚', 'On the Way'),
  _StepConfig('📦', 'Delivered'),
];

/// [currentStep] is 0-based index of the active step (0 = Ordered … 3 = Delivered).
class ProgressTracker extends StatelessWidget {
  final int currentStep;

  const ProgressTracker({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    // Fill width fraction: 0 / 3  1/3  2/3  3/3
    final fillFraction = currentStep / (_steps.length - 1);

    return LayoutBuilder(builder: (context, constraints) {
      final totalWidth = constraints.maxWidth;

      return SizedBox(
        height: 50,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // ── connector base line ──────────────────────────
            Positioned(
              top: 11,
              left: 11,
              right: 11,
              child: Container(height: 2, color: colorG200),
            ),
            // ── fill line ────────────────────────────────────
            Positioned(
              top: 11,
              left: 11,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: (totalWidth - 22) * fillFraction,
                height: 2,
                color: colorLight,
              ),
            ),
            // ── dots + labels ─────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(_steps.length, (i) {
                final isDone   = i < currentStep;
                final isActive = i == currentStep;

                final dot = AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: kProgressDotSize,
                  height: kProgressDotSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone
                        ? colorLight
                        : isActive
                        ? colorDark
                        : Colors.white,
                    border: isDone || isActive
                        ? null
                        : Border.all(color: colorG200, width: 2),
                    boxShadow: isActive
                        ? [
                      BoxShadow(
                        color: colorLight.withOpacity(0.25),
                        spreadRadius: 3,
                      )
                    ]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    isDone ? '✓' : _steps[i].icon,
                    style: TextStyle(
                      fontSize: 10,
                      color: isDone || isActive ? Colors.white : colorG400,
                    ),
                  ),
                );

                final label = Text(
                  _steps[i].label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    fontFamily: 'DM Sans',
                    fontWeight: isActive ? FontWeight.w800 : FontWeight.w700,
                    fontSize: 8,
                    color: isDone
                        ? colorLight
                        : isActive
                        ? colorDark
                        : colorG400,
                  ),
                );

                return SizedBox(
                  width: 44,
                  child: Column(
                    children: [dot, const SizedBox(height: 4), label],
                  ),
                );
              }),
            ),
          ],
        ),
      );
    });
  }
}