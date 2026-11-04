import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../controllers/calorie_tracker_controller.dart';
import '../../controllers/user_controller.dart';
import '../main_navigation_screen.dart';
import '../profile/widgets/wheel_picker_column.dart';

class TargetInputScreen extends StatefulWidget {
  final String? userName;
  final int? initialTarget;
  final bool isEditing;

  const TargetInputScreen({
    super.key,
    this.userName,
    this.initialTarget,
    this.isEditing = false,
  });

  @override
  State<TargetInputScreen> createState() => _TargetInputScreenState();
}

class _TargetInputScreenState extends State<TargetInputScreen> {
  late int _targetCalories;
  late final FixedExtentScrollController _wheelController;

  static const int _minCalories = 1000;
  static const int _maxCalories = 5000;
  static const int _step = 50;

  final List<int> _quickPresets = [1500, 1800, 2000, 2200];

  int get _itemCount => ((_maxCalories - _minCalories) ~/ _step) + 1;

  int _calorieForIndex(int index) => _minCalories + (index * _step);

  int _indexForCalorie(int calories) {
    final idx = (calories - _minCalories) ~/ _step;
    return idx.clamp(0, _itemCount - 1);
  }

  @override
  void initState() {
    super.initState();
    _targetCalories = widget.initialTarget ?? 2000;
    final initialIndex = _indexForCalorie(_targetCalories);
    _wheelController = FixedExtentScrollController(initialItem: initialIndex);
  }

  @override
  void dispose() {
    _wheelController.dispose();
    super.dispose();
  }

  void _onFinish() {
    if (widget.isEditing) {
      context.read<UserController>().updateDailyGoal(_targetCalories);
      context.read<CalorieTrackerController>().updateDailyGoal(_targetCalories);
      Navigator.of(context).pop();
      return;
    }

    context.read<UserController>().completeOnboarding(
          name: widget.userName ?? 'User',
          dailyGoal: _targetCalories,
        );
    context.read<CalorieTrackerController>().updateDailyGoal(_targetCalories);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      (route) => false,
    );
  }

  void _selectPreset(int preset) {
    setState(() {
      _targetCalories = preset;
    });
    final targetIndex = _indexForCalorie(preset);
    _wheelController.animateToItem(
      targetIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = AppColors.background(isDark);
    final cardBg = AppColors.card(isDark);
    final cardBorder = AppColors.border(isDark);
    final textPrimary = AppColors.textPrimary(isDark);
    final textSecondary = AppColors.textSecondary(isDark);
    final currentWheelIndex = _indexForCalorie(_targetCalories);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // Top bar title or 2-step progress indicator
        title: widget.isEditing
            ? Text(
                'Update Daily Goal',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: textPrimary,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 24,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 32,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text(
                widget.isEditing ? 'Update Daily Target' : 'Set Your Daily Target',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.isEditing
                    ? 'Adjust your daily calorie consumption target.'
                    : 'This helps us personalize your daily calorie plan.',
                style: TextStyle(
                  fontSize: 14,
                  color: textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // Main Card with Vertical Wheel/Drum Picker
              Container(
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
                      : null,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Daily Target',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                            color: textPrimary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.accentDim : const Color(0xFFEFF8DE),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.accent.withValues(alpha: 0.3)
                                  : const Color(0xFFD4EDB0),
                            ),
                          ),
                          child: Text(
                            '$_targetCalories kcal',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: isDark ? AppColors.accent : const Color(0xFF4D7C0F),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Vertical Scrolling Wheel Picker
                    Center(
                      child: SizedBox(
                        width: 190,
                        child: WheelPickerColumn(
                          controller: _wheelController,
                          itemCount: _itemCount,
                          selectedIndex: currentWheelIndex,
                          itemExtent: 42.0,
                          height: 190.0,
                          capsuleWidth: 150.0,
                          capsuleMargin: EdgeInsets.zero,
                          isDark: isDark,
                          onSelectedItemChanged: (index) {
                            setState(() {
                              _targetCalories = _calorieForIndex(index);
                            });
                          },
                          labelBuilder: (index) => '${_calorieForIndex(index)} kcal',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Quick Presets pill buttons (1500 kcal, 1800 kcal, 2000 kcal, 2200 kcal)
              Text(
                'Quick Presets',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: _quickPresets.map((preset) {
                  final isSelected = _targetCalories == preset;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: InkWell(
                        onTap: () => _selectPreset(preset),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.accent
                                : (isDark ? cardBg : Colors.white),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected ? AppColors.accent : cardBorder,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '$preset',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: isSelected
                                    ? AppColors.onAccent
                                    : textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const Spacer(),

              // Bottom full-width CTA button: "Start Tracking"
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _onFinish,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.onAccent,
                    elevation: isDark ? 4 : 0,
                    shadowColor: isDark ? AppColors.accent.withValues(alpha: 0.35) : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    widget.isEditing ? 'Save Goal' : 'Start Tracking',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: AppColors.onAccent,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
