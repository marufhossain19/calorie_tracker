import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:calorie_tracker/core/di/service_locator.dart';
import 'package:calorie_tracker/core/theme/theme_controller.dart';
import 'package:calorie_tracker/presentation/controllers/calorie_tracker_controller.dart';
import 'package:calorie_tracker/presentation/controllers/user_controller.dart';
import 'package:calorie_tracker/presentation/screens/home/home_screen.dart';

void main() {
  setUp(() {
    ServiceLocator.init();
  });

  testWidgets('Screen disposal test: controller handles disposal correctly', (WidgetTester tester) async {
    final controller = ServiceLocator.createCalorieTrackerController();
    expect(controller.isDisposed, false);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeController>.value(value: ServiceLocator.themeController),
          ChangeNotifierProvider<UserController>.value(value: ServiceLocator.userController),
          ChangeNotifierProvider<CalorieTrackerController>.value(value: controller),
        ],
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    expect(find.text('CalTrack'), findsOneWidget);
    controller.dispose();
    expect(controller.isDisposed, true);
  });
}
