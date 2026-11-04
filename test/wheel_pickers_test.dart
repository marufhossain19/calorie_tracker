import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calorie_tracker/core/di/service_locator.dart';
import 'package:calorie_tracker/presentation/screens/profile/widgets/height_selection_card.dart';
import 'package:calorie_tracker/presentation/screens/profile/widgets/height_wheel_picker.dart';
import 'package:calorie_tracker/presentation/screens/profile/widgets/weight_selection_card.dart';
import 'package:calorie_tracker/presentation/screens/profile/widgets/weight_wheel_picker.dart';

void main() {
  setUp(() {
    ServiceLocator.init();
  });

  group('Premium Animated Wheel Pickers Widget Tests', () {
    testWidgets('HeightSelectionCard renders dual wheels with default 5 ft and 6 in', (tester) async {
      int feet = 5;
      int inches = 6;
      final feetController = FixedExtentScrollController(initialItem: 2); // 5 ft is index 2
      final inchesController = FixedExtentScrollController(initialItem: 6); // 6 in is index 6

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HeightSelectionCard(
              selectedFeet: feet,
              selectedInches: inches,
              feetController: feetController,
              inchesController: inchesController,
              onFeetChanged: (val) => feet = val,
              onInchesChanged: (val) => inches = val,
              isDark: true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check header and no toggle/stepper presence
      expect(find.text('Your Height'), findsOneWidget);
      expect(find.text('Imperial'), findsNothing);
      expect(find.text('Metric'), findsNothing);
      expect(find.byIcon(Icons.add_rounded), findsNothing);
      expect(find.byIcon(Icons.remove_rounded), findsNothing);

      // Check height wheel presence
      expect(find.byType(HeightWheelPicker), findsOneWidget);
      expect(find.text('5 ft'), findsOneWidget);
      expect(find.text('6 in'), findsOneWidget);

      feetController.dispose();
      inchesController.dispose();
    });

    testWidgets('WeightSelectionCard renders centered wheel with 65.0 kg default', (tester) async {
      double weight = 65.0;
      // 30.0 to 200.0, index for 65.0 is (650 - 300) = 350
      final weightController = FixedExtentScrollController(initialItem: 350);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeightSelectionCard(
              selectedWeight: weight,
              controller: weightController,
              onWeightChanged: (val) => weight = val,
              isDark: true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check header and metric label
      expect(find.text('Your Weight'), findsOneWidget);
      expect(find.text('Metric (kg)'), findsOneWidget);
      expect(find.byIcon(Icons.add_rounded), findsNothing);
      expect(find.byIcon(Icons.remove_rounded), findsNothing);

      // Check weight wheel presence
      expect(find.byType(WeightWheelPicker), findsOneWidget);
      expect(find.text('65.0 kg'), findsOneWidget);

      weightController.dispose();
    });
  });
}

