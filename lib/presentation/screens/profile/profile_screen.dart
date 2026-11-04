import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/utils/bmi_calculator.dart';
import '../../controllers/user_controller.dart';
import '../onboarding/target_input_screen.dart';
import 'widgets/height_selection_card.dart';
import 'widgets/height_wheel_picker.dart';
import 'widgets/weight_selection_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedFeet = 5;
  int selectedInches = 6;
  double selectedWeight = 65.0;

  late FixedExtentScrollController _feetController;
  late FixedExtentScrollController _inchesController;
  late FixedExtentScrollController _weightController;

  static const double _minWeight = 30.0;

  @override
  void initState() {
    super.initState();
    final userController = context.read<UserController>();
    final (feet, inches) = BmiCalculator.cmToFeetInches(userController.heightCm);

    selectedFeet = feet.clamp(3, 7);
    selectedInches = inches.clamp(0, 11);
    selectedWeight = double.parse(userController.weightKg.toStringAsFixed(1)).clamp(30.0, 200.0);

    final feetIndex = HeightWheelPicker.feetValues.indexOf(selectedFeet);
    final inchesIndex = HeightWheelPicker.inchesValues.indexOf(selectedInches);
    final weightIndex = (((selectedWeight * 10).round() - (_minWeight * 10).round())).clamp(0, 1700);

    _feetController = FixedExtentScrollController(initialItem: feetIndex >= 0 ? feetIndex : 2);
    _inchesController = FixedExtentScrollController(initialItem: inchesIndex >= 0 ? inchesIndex : 6);
    _weightController = FixedExtentScrollController(initialItem: weightIndex);
  }

  @override
  void dispose() {
    _feetController.dispose();
    _inchesController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _onFeetChanged(int newFeet) {
    setState(() {
      selectedFeet = newFeet;
    });
    final newCm = BmiCalculator.feetInchesToCm(selectedFeet, selectedInches);
    context.read<UserController>().updateHeightCm(newCm);
  }

  void _onInchesChanged(int newInches) {
    setState(() {
      selectedInches = newInches;
    });
    final newCm = BmiCalculator.feetInchesToCm(selectedFeet, selectedInches);
    context.read<UserController>().updateHeightCm(newCm);
  }

  void _onWeightChanged(double newWeight) {
    setState(() {
      selectedWeight = double.parse(newWeight.toStringAsFixed(1));
    });
    context.read<UserController>().updateWeightKg(selectedWeight);
  }

  void _showEditGoalDialog(BuildContext context, int currentGoal) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TargetInputScreen(
          isEditing: true,
          initialTarget: currentGoal,
        ),
      ),
    );
  }

  void _showEditNameDialog(BuildContext context, String currentName) {
    final controller = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (dialogCtx) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final cardBg = AppColors.card(isDark);
        final textPrimary = AppColors.textPrimary(isDark);

        return AlertDialog(
          backgroundColor: cardBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text('Edit Your Name', style: TextStyle(fontWeight: FontWeight.w800, color: textPrimary)),
          content: TextField(
            controller: controller,
            textCapitalization: TextCapitalization.words,
            style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700),
            decoration: InputDecoration(
              hintText: 'Enter name',
              filled: true,
              fillColor: isDark ? AppColors.elevated(isDark) : const Color(0xFFF1F5F9),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary(isDark))),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  context.read<UserController>().updateName(controller.text.trim());
                }
                Navigator.of(dialogCtx).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.onAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Save',
                style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.onAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userController = context.watch<UserController>();

    final bgColor = AppColors.background(isDark);
    final cardBg = AppColors.card(isDark);
    final cardBorder = AppColors.border(isDark);
    final textPrimary = AppColors.textPrimary(isDark);
    final textSecondary = AppColors.textSecondary(isDark);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.3,
            color: textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          child: Column(
            children: [
              // 1. Member Header Card: Avatar circle, username with inline edit pencil icon, and subtitle
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: cardBorder, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: isDark ? AppColors.accentDim : const Color(0xFFEFF8DE),
                            child: Icon(
                              Icons.person_rounded,
                              size: 32,
                              color: isDark ? AppColors.accent : const Color(0xFF4D7C0F),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  userController.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'CalTrack Member',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => _showEditNameDialog(context, userController.name),
                      icon: const Icon(Icons.edit_rounded, size: 14),
                      label: const Text('Edit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.onAccent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 2. Daily Calorie Target Card: Flame icon, "Daily Calorie Target", current value, and lime "✎ Edit" pill button
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: cardBorder, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.accentDim : const Color(0xFFEFF8DE),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.local_fire_department_rounded,
                            color: isDark ? AppColors.accent : const Color(0xFF4D7C0F),
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Daily Calorie Target',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: textSecondary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${userController.dailyGoal} kcal',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _showEditGoalDialog(context, userController.dailyGoal),
                      icon: const Icon(Icons.edit_rounded, size: 14),
                      label: const Text('Edit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.onAccent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 3. Your Height Card: Dual vertical wheel/drum pickers side-by-side
              HeightSelectionCard(
                selectedFeet: selectedFeet,
                selectedInches: selectedInches,
                feetController: _feetController,
                inchesController: _inchesController,
                onFeetChanged: _onFeetChanged,
                onInchesChanged: _onInchesChanged,
                isDark: isDark,
              ),
              const SizedBox(height: 16),

              // 4. Your Weight Card: Header with "Your Weight" and "Metric (kg)" badge
              WeightSelectionCard(
                selectedWeight: selectedWeight,
                controller: _weightController,
                onWeightChanged: _onWeightChanged,
                isDark: isDark,
              ),
              const SizedBox(height: 16),

              // 5. Redesigned Colorful Current BMI Card with 4-Zone Spectrum Scale
              _buildColorfulBmiCard(userController, isDark),
              const SizedBox(height: 16),

              // 6. Theme Mode Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: cardBorder, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                          color: isDark ? AppColors.accent : const Color(0xFF4D7C0F),
                          size: 22,
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Theme Mode',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: textPrimary,
                              ),
                            ),
                            Text(
                              isDark ? 'Deep Black Dark Mode' : 'Daylight White Mode',
                              style: TextStyle(
                                fontSize: 12,
                                color: textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Switch(
                      value: isDark,
                      activeThumbColor: AppColors.accent,
                      activeTrackColor: isDark ? AppColors.accentDim : const Color(0xFFEFF8DE),
                      onChanged: (val) {
                        ServiceLocator.themeController.toggleTheme(val);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 5. Redesigned Colorful Current BMI Card
  Widget _buildColorfulBmiCard(UserController controller, bool isDark) {
    final bmi = controller.bmi;
    final category = controller.bmiCategory;
    final cardBg = AppColors.card(isDark);
    final cardBorder = AppColors.border(isDark);
    final textSecondary = AppColors.textSecondary(isDark);

    // Dynamic color for BMI readout
    Color bmiColor;
    switch (category) {
      case BmiCategory.underweight:
        bmiColor = AppColors.bmiUnderweight;
        break;
      case BmiCategory.normal:
        bmiColor = AppColors.bmiHealthy;
        break;
      case BmiCategory.overweight:
        bmiColor = AppColors.bmiOverweight;
        break;
      case BmiCategory.obese:
        bmiColor = AppColors.bmiObese;
        break;
    }

    // Scale from 10.0 to 40.0
    final double clampedBmi = bmi.clamp(10.0, 40.0);
    final double pointerPercent = (clampedBmi - 10.0) / (40.0 - 10.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cardBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: bmiColor.withValues(alpha: isDark ? 0.08 : 0.04),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Current BMI title & Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current BMI',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      bmi.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                        color: bmiColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Healthy: 18.5 – 24.9',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Category status badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: bmiColor.withValues(alpha: isDark ? 0.15 : 0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: bmiColor.withValues(alpha: 0.4), width: 1),
                ),
                child: Text(
                  category.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: bmiColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 4-Zone Colorful Spectrum Scale Bar with Floating Tooltip & Thumb Pointer
          LayoutBuilder(
            builder: (context, constraints) {
              final totalWidth = constraints.maxWidth;
              final pointerX = (totalWidth * pointerPercent).clamp(12.0, totalWidth - 12.0);

              return Column(
                children: [
                  // Floating Value Tooltip
                  SizedBox(
                    height: 26,
                    child: Stack(
                      children: [
                        Positioned(
                          left: (pointerX - 22).clamp(0.0, totalWidth - 44.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: bmiColor,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: bmiColor.withValues(alpha: 0.4),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              bmi.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),

                  // 4-Segment Spectrum Bar + Thumb Pointer Stack
                  SizedBox(
                    height: 18,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        // Horizontal 4-Segment Gradient Bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: SizedBox(
                            height: 10,
                            width: totalWidth,
                            child: Row(
                              children: [
                                // Zone 1 (Underweight <18.5): Cyan-Blue (#06B6D4 to #38BDF8)
                                Expanded(
                                  flex: 85,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Color(0xFF06B6D4), Color(0xFF38BDF8)],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 2),
                                // Zone 2 (Healthy 18.5–24.9): Lime-Emerald (#10B981 to #B8F624)
                                Expanded(
                                  flex: 65,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Color(0xFF10B981), Color(0xFFB8F624)],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 2),
                                // Zone 3 (Overweight 25.0–29.9): Amber-Orange (#F59E0B to #FB923C)
                                Expanded(
                                  flex: 50,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Color(0xFFF59E0B), Color(0xFFFB923C)],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 2),
                                // Zone 4 (Obese 30.0+): Coral-Rose (#F43F5E to #E11D48)
                                Expanded(
                                  flex: 100,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Color(0xFFF43F5E), Color(0xFFE11D48)],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Animated Circular Thumb Pointer
                        Positioned(
                          left: pointerX - 9,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: bmiColor, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Threshold Markers: 10, 18.5, 25, 30, 40
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const ['10', '18.5', '25', '30', '40'].map((mark) {
                        return Text(
                          mark,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF94A3B8),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 18),

          // 4-Column Category Legend below
          Row(
            children: [
              _BmiLegendColumn(title: 'Underweight', range: '<18.5', color: AppColors.bmiUnderweight),
              _BmiLegendColumn(title: 'Healthy', range: '18.5–24.9', color: AppColors.bmiHealthy),
              _BmiLegendColumn(title: 'Overweight', range: '25–29.9', color: AppColors.bmiOverweight),
              _BmiLegendColumn(title: 'Obese', range: '30+', color: AppColors.bmiObese),
            ],
          ),
        ],
      ),
    );
  }
}

class _BmiLegendColumn extends StatelessWidget {
  final String title;
  final String range;
  final Color color;

  const _BmiLegendColumn({
    required this.title,
    required this.range,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Color(0xFF94A3B8),
            ),
          ),
          Text(
            range,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}
