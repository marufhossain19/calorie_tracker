import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'weight_wheel_picker.dart';

/// Selection card for user weight featuring a single centered vertical scrolling wheel.
class WeightSelectionCard extends StatelessWidget {
  final double selectedWeight;
  final FixedExtentScrollController controller;
  final ValueChanged<double> onWeightChanged;
  final bool isDark;

  const WeightSelectionCard({
    super.key,
    required this.selectedWeight,
    required this.controller,
    required this.onWeightChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = AppColors.card(isDark);
    final cardBorder = AppColors.border(isDark);
    final titleColor = AppColors.textPrimary(isDark);
    final unitColor = isDark ? AppColors.accent : const Color(0xFF4D7C0F);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cardBorder, width: 1),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.04),
                  blurRadius: 18,
                  spreadRadius: 0.5,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Weight',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                  color: titleColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.accentDim : const Color(0xFFEFF8DE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Metric (kg)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: unitColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Single Centered Vertical Scrolling Wheel
          WeightWheelPicker(
            selectedWeight: selectedWeight,
            controller: controller,
            onWeightChanged: onWeightChanged,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}
