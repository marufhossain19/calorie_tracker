import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calorie_tracker/core/di/service_locator.dart';
import 'package:calorie_tracker/main.dart';
import 'package:calorie_tracker/presentation/widgets/intake_food_sheet.dart';

void main() {
  setUp(() {
    ServiceLocator.init();
  });

  testWidgets('Complete Onboarding, Intake Flow, and Navigation test starting from zero', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const CalorieTrackerApp());
    await tester.pumpAndSettle();

    // 1. Initial Launch: GetStartedScreen
    expect(find.text('Track Your Daily Calories\nWith Precision'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);

    // Tap "Get Started"
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    // 2. NameInputScreen
    expect(find.text("What's your name?"), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), 'Helal');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // 3. TargetInputScreen (Wheel Picker)
    expect(find.text('Set Your Daily Target'), findsOneWidget);
    expect(find.textContaining('2000'), findsWidgets);
    await tester.tap(find.text('Start Tracking'));
    await tester.pumpAndSettle();

    // 4. Main Navigation -> HomeScreen starts at 0 consumed calories
    expect(find.text('CalTrack'), findsOneWidget);
    expect(find.text('Welcome, Helal 👋'), findsOneWidget);
    expect(find.text('Today Calories'), findsOneWidget);
    expect(find.text('Consumed'), findsOneWidget);
    expect(find.text('Daily Goal'), findsOneWidget);
    expect(find.text("Today's Meals"), findsOneWidget);
    expect(find.text('No meals intaken today'), findsOneWidget);

    // Test the Home "+ Add Food" intake button (referring to intaking food item)
    final homeAddFoodBtn = find.widgetWithText(ElevatedButton, 'Add Food').first;
    expect(homeAddFoodBtn, findsOneWidget);
    await tester.tap(homeAddFoodBtn);
    await tester.pumpAndSettle();

    // IntakeFoodSheet opens with food catalog items
    expect(find.byType(IntakeFoodSheet), findsOneWidget);
    expect(find.text('Intake Food'), findsOneWidget);
    expect(find.text('Boiled Egg'), findsOneWidget);
    expect(find.text('Rice (Cooked)'), findsOneWidget);
    expect(find.text('Biriyani'), findsOneWidget);

    // Tap "Boiled Egg" (78 kcal) to intake
    await tester.tap(find.text('Boiled Egg').first);
    await tester.pumpAndSettle();

    // Verify Boiled Egg appears in Today's Meals on Home Screen
    expect(find.text('Boiled Egg'), findsWidgets);
    expect(find.text('78 kcal'), findsWidgets);

    // Let the intake confirmation SnackBar dismiss before navigation
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // 5. Navigate to Food tab
    await tester.tap(find.text('Food'));
    await tester.pumpAndSettle();

    expect(find.text('Food Items'), findsOneWidget);
    expect(find.text('Boiled Egg'), findsWidgets);

    // Add a custom food item via "Add Food Item"
    await tester.tap(find.text('Add Food Item').first);
    await tester.pumpAndSettle();

    expect(find.text('Add Food Item'), findsWidgets);
    final textFields = find.byType(TextFormField);
    await tester.enterText(textFields.first, 'Grilled Salmon');
    await tester.enterText(textFields.last, '340');

    // Submit Add Food
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add Food Item').last);
    await tester.pumpAndSettle();

    // Verify item is added to Food Items
    expect(find.text('Grilled Salmon'), findsWidgets);
    expect(find.text('340 kcal'), findsWidgets);

    // Tap food item to view FoodDetailScreen
    await tester.tap(find.text('Grilled Salmon').first);
    await tester.pumpAndSettle();

    expect(find.text('Tags & Attributes'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_rounded), findsWidgets);
    await tester.tap(find.byIcon(Icons.arrow_back_rounded).first);
    await tester.pumpAndSettle();

    // 6. Navigate to Analytics tab
    await tester.tap(find.text('Analytics'));
    await tester.pumpAndSettle();

    expect(find.text('Weekly Calories'), findsOneWidget);
    expect(find.text('Monthly Activity'), findsOneWidget);
    expect(find.text('Target Hit'), findsWidgets);

    // 7. Navigate to Profile tab
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('Your Height'), findsOneWidget);
    expect(find.text('Your Weight'), findsOneWidget);
    expect(find.text('Current BMI'), findsOneWidget);
    expect(find.text('Theme Mode'), findsOneWidget);
  });
}
