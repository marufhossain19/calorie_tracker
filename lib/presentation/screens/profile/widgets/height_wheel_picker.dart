import 'package:flutter/material.dart';
import 'wheel_picker_column.dart';

/// Two independent vertical scrolling wheel pickers for Feet and Inches.
class HeightWheelPicker extends StatelessWidget {
  final int selectedFeet;
  final int selectedInches;
  final FixedExtentScrollController feetController;
  final FixedExtentScrollController inchesController;
  final ValueChanged<int> onFeetChanged;
  final ValueChanged<int> onInchesChanged;
  final bool isDark;

  static const List<int> feetValues = [3, 4, 5, 6, 7];
  static const List<int> inchesValues = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

  const HeightWheelPicker({
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
    final feetIndex = feetValues.indexOf(selectedFeet).clamp(0, feetValues.length - 1);
    final inchesIndex = inchesValues.indexOf(selectedInches).clamp(0, inchesValues.length - 1);

    return Row(
      children: [
        // Feet Picker (Left Column)
        Expanded(
          child: WheelPickerColumn(
            controller: feetController,
            itemCount: feetValues.length,
            selectedIndex: feetIndex,
            onSelectedItemChanged: (index) {
              onFeetChanged(feetValues[index]);
            },
            labelBuilder: (index) => '${feetValues[index]} ft',
            capsuleMargin: const EdgeInsets.symmetric(horizontal: 14),
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 8),
        // Inches Picker (Right Column)
        Expanded(
          child: WheelPickerColumn(
            controller: inchesController,
            itemCount: inchesValues.length,
            selectedIndex: inchesIndex,
            onSelectedItemChanged: (index) {
              onInchesChanged(inchesValues[index]);
            },
            labelBuilder: (index) => '${inchesValues[index]} in',
            capsuleMargin: const EdgeInsets.symmetric(horizontal: 14),
            isDark: isDark,
          ),
        ),
      ],
    );
  }
}

