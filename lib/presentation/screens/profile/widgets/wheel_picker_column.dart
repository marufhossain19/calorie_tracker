import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A reusable vertical wheel picker column utilizing [CupertinoPicker.builder]
/// with smooth momentum scrolling, automatic snapping, magnification, and
/// a rounded dark-grey selection highlight capsule.
class WheelPickerColumn extends StatelessWidget {
  final FixedExtentScrollController controller;
  final int itemCount;
  final int selectedIndex;
  final ValueChanged<int> onSelectedItemChanged;
  final String Function(int index) labelBuilder;
  final double itemExtent;
  final double height;
  final double? capsuleWidth;
  final EdgeInsetsGeometry? capsuleMargin;
  final bool isDark;

  const WheelPickerColumn({
    super.key,
    required this.controller,
    required this.itemCount,
    required this.selectedIndex,
    required this.onSelectedItemChanged,
    required this.labelBuilder,
    this.itemExtent = 40.0,
    this.height = 190.0,
    this.capsuleWidth,
    this.capsuleMargin = const EdgeInsets.symmetric(horizontal: 8),
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Subtle dark-grey rounded rectangle matching the reference UI (#24272C)
    final capsuleColor = isDark ? const Color(0xFF24272C) : const Color(0xFFE9ECEF);
    final activeTextColor = isDark ? Colors.white : const Color(0xFF1E242B);
    final inactiveTextColor = isDark
        ? Colors.white.withValues(alpha: 0.35)
        : const Color(0xFF1E242B).withValues(alpha: 0.35);

    return SizedBox(
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Center Selection Highlight Capsule
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              height: itemExtent,
              width: capsuleWidth,
              margin: capsuleMargin,
              decoration: BoxDecoration(
                color: capsuleColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // 2. Interactive Cupertino Picker with natural momentum and snapping
          CupertinoPicker.builder(
            scrollController: controller,
            itemExtent: itemExtent,
            childCount: itemCount,
            useMagnifier: true,
            magnification: 1.15,
            squeeze: 1.05,
            diameterRatio: 1.35,
            selectionOverlay: const SizedBox.shrink(),
            onSelectedItemChanged: onSelectedItemChanged,
            itemBuilder: (context, index) {
              if (index < 0 || index >= itemCount) return null;
              final isSelected = index == selectedIndex;

              return Center(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeInOut,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    letterSpacing: -0.2,
                    color: isSelected ? activeTextColor : inactiveTextColor,
                  ),
                  child: Text(labelBuilder(index)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

