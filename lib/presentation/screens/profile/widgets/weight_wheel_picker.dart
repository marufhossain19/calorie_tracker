import 'package:flutter/material.dart';
import 'wheel_picker_column.dart';

/// A single centered vertical scrolling wheel picker for weight in kilograms (0.1 kg step).
class WeightWheelPicker extends StatelessWidget {
  final double selectedWeight;
  final FixedExtentScrollController controller;
  final ValueChanged<double> onWeightChanged;
  final double minWeight;
  final double maxWeight;
  final double step;
  final bool isDark;

  const WeightWheelPicker({
    super.key,
    required this.selectedWeight,
    required this.controller,
    required this.onWeightChanged,
    this.minWeight = 30.0,
    this.maxWeight = 200.0,
    this.step = 0.1,
    required this.isDark,
  });

  int get _itemCount => (((maxWeight - minWeight) / step).round() + 1);

  double _weightForIndex(int index) {
    final tenths = (minWeight * 10).round() + index;
    return tenths / 10.0;
  }

  int _indexForWeight(double weight) {
    final tenths = (weight * 10).round() - (minWeight * 10).round();
    return tenths.clamp(0, _itemCount - 1);
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _indexForWeight(selectedWeight);

    return Center(
      child: SizedBox(
        width: 180,
        child: WheelPickerColumn(
          controller: controller,
          itemCount: _itemCount,
          selectedIndex: currentIndex,
          onSelectedItemChanged: (index) {
            final weight = _weightForIndex(index);
            onWeightChanged(weight);
          },
          labelBuilder: (index) {
            final weight = _weightForIndex(index);
            return '${weight.toStringAsFixed(1)} kg';
          },
          capsuleWidth: 140,
          capsuleMargin: EdgeInsets.zero,
          isDark: isDark,
        ),
      ),
    );
  }
}

