import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'height_wheel_picker.dart';

/// Selection card for user height featuring two independent vertical scrolling wheels.
class HeightSelectionCard extends StatelessWidget {
  final int selectedFeet;
  final int selectedInches;
  final FixedExtentScrollController feetController;
  final FixedExtentScrollController inchesController;
  final ValueChanged<int> onFeetChanged;
  final ValueChanged<int> onInchesChanged;
  final bool isDark;

  const HeightSelectionCard({
    super.key,
    required this.selectedFeet,
    required this.selectedInches,
    required this.feetController,
    required this.inchesController,
    required this.onFeetChanged,
    required this.onInchesChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = AppColors.card(isDark);
    final cardBorder = AppColors.border(isDark);
    final titleColor = AppColors.textPrimary(isDark);

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
          Text(
            'Your Height',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 12),
          // Two Independent Scrolling Wheels (Feet & Inches)
          HeightWheelPicker(
            selectedFeet: selectedFeet,
            selectedInches: selectedInches,
            feetController: feetController,
            inchesController: inchesController,
            onFeetChanged: onFeetChanged,
            onInchesChanged: onInchesChanged,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}
