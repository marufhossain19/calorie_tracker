import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/daily_log_entity.dart';
import '../../controllers/calorie_tracker_controller.dart';
import '../../controllers/user_controller.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  late DateTime _selectedWeekStart;
  late DateTime _selectedMonth;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedWeekStart = now.subtract(Duration(days: now.weekday - 1));
    _selectedMonth = DateTime(now.year, now.month, 1);
    _selectedDay = DateTime(now.year, now.month, now.day);
  }

  void _previousWeek(DateTime appStartDate) {
    final candidate = _selectedWeekStart.subtract(const Duration(days: 7));
    if (candidate.isAfter(appStartDate.subtract(const Duration(days: 7)))) {
      setState(() => _selectedWeekStart = candidate);
    }
  }

  void _nextWeek() {
    final now = DateTime.now();
    final thisWeekStart = now.subtract(Duration(days: now.weekday - 1));
    if (_selectedWeekStart.isBefore(thisWeekStart)) {
      setState(() => _selectedWeekStart = _selectedWeekStart.add(const Duration(days: 7)));
    }
  }

  void _previousMonth(DateTime appStartDate) {
    final prev = DateTime(_selectedMonth.year, _selectedMonth.month - 1, 1);
    if (prev.isAfter(DateTime(appStartDate.year, appStartDate.month - 1, 1))) {
      setState(() => _selectedMonth = prev);
    }
  }

  void _nextMonth() {
    final now = DateTime.now();
    final thisMonth = DateTime(now.year, now.month, 1);
    if (_selectedMonth.isBefore(thisMonth)) {
      setState(() => _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userController = context.watch<UserController>();
    final trackerController = context.watch<CalorieTrackerController>();

    final appStartDate = userController.appStartDate;
    final now = DateTime.now();
    final thisWeekStart = now.subtract(Duration(days: now.weekday - 1));
    final thisMonth = DateTime(now.year, now.month, 1);

    final canGoBackWeek = _selectedWeekStart.isAfter(appStartDate);
    final canGoForwardWeek = _selectedWeekStart.isBefore(thisWeekStart);

    final canGoBackMonth = _selectedMonth.isAfter(DateTime(appStartDate.year, appStartDate.month, 1));
    final canGoForwardMonth = _selectedMonth.isBefore(thisMonth);

    // Fetch week logs
    final weekEnd = _selectedWeekStart.add(const Duration(days: 6));
    final weekLogs = trackerController.getLogsForRange(_selectedWeekStart, weekEnd);

    // Fetch month logs
    final monthEnd = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
    final monthLogs = trackerController.getLogsForRange(_selectedMonth, monthEnd);

    final bgColor = AppColors.background(isDark);
    final textPrimary = AppColors.textPrimary(isDark);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Analytics',
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
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top 7-Day Selector Card (Mon 2 to Sun 8 with active day inside pill border & solid lime circle)
              _buildTopWeekSelectorCard(isDark, weekLogs),
              const SizedBox(height: 18),

              // 2. Weekly Calories Bar Chart Card with Navigation, Target Line, and Summary Strip
              _buildWeeklyBarChartCard(
                isDark: isDark,
                weekLogs: weekLogs,
                target: userController.dailyGoal,
                canGoBack: canGoBackWeek,
                canGoForward: canGoForwardWeek,
                onPrevious: () => _previousWeek(appStartDate),
                onNext: _nextWeek,
              ),
              const SizedBox(height: 18),

              // 3. Monthly Activity Heatmap Calendar with Strict Shading Rules
              _buildMonthlyHeatmapCard(
                isDark: isDark,
                monthLogs: monthLogs,
                target: userController.dailyGoal,
                canGoBack: canGoBackMonth,
                canGoForward: canGoForwardMonth,
                onPrevious: () => _previousMonth(appStartDate),
                onNext: _nextMonth,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 1. Top 7-Day Selector Card
  Widget _buildTopWeekSelectorCard(bool isDark, List<DailyLogEntity> logs) {
    const dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final cardBg = AppColors.card(isDark);
    final cardBorder = AppColors.border(isDark);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cardBorder, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (index) {
          final dayDate = _selectedWeekStart.add(Duration(days: index));
          final isSelected = dayDate.year == _selectedDay.year &&
              dayDate.month == _selectedDay.month &&
              dayDate.day == _selectedDay.day;

          return InkWell(
            onTap: () {
              setState(() => _selectedDay = dayDate);
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark ? AppColors.accentDim : const Color(0xFFEFF8DE))
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(22),
                border: isSelected
                    ? Border.all(color: AppColors.accent, width: 1.5)
                    : null,
              ),
              child: Column(
                children: [
                  Text(
                    dayLabels[index],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? (isDark ? AppColors.accent : const Color(0xFF4D7C0F))
                          : AppColors.textSecondary(isDark),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.accent
                          : (isDark ? AppColors.elevated(isDark) : const Color(0xFFF1F5F9)),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${dayDate.day}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: isSelected
                              ? AppColors.onAccent
                              : AppColors.textPrimary(isDark),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // 2. Weekly Calories Bar Chart Card
  // 2. Weekly Calories Bar Chart Card (Clean Style matching Image 4)
  Widget _buildWeeklyBarChartCard({
    required bool isDark,
    required List<DailyLogEntity> weekLogs,
    required int target,
    required bool canGoBack,
    required bool canGoForward,
    required VoidCallback onPrevious,
    required VoidCallback onNext,
  }) {
    final startDay = _selectedWeekStart.day;
    final endDay = _selectedWeekStart.add(const Duration(days: 6)).day;
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final monthLabel = months[_selectedWeekStart.month - 1];

    final cardBg = AppColors.card(isDark);
    final cardBorder = AppColors.border(isDark);
    final textPrimary = AppColors.textPrimary(isDark);
    final textSecondary = AppColors.textSecondary(isDark);
    final elevatedBg = isDark ? AppColors.elevated(isDark) : const Color(0xFFF1F5F9);

    final now = DateTime.now();
    final maxCal = weekLogs.fold(target, (max, l) => l.totalCalories > max ? l.totalCalories : max);
    final chartCeiling = (maxCal * 1.25).ceil();

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Title, Date Range Subtitle, and Circular < > Navigation Arrows
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weekly Calories',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.3,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '$startDay - $endDay $monthLabel ${_selectedWeekStart.year}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textSecondary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  InkWell(
                    onTap: canGoBack ? onPrevious : null,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: elevatedBg,
                      ),
                      child: Icon(
                        Icons.chevron_left_rounded,
                        size: 20,
                        color: canGoBack ? textPrimary : textSecondary.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: canGoForward ? onNext : null,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: elevatedBg,
                      ),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        size: 20,
                        color: canGoForward ? textPrimary : textSecondary.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Bar Chart with Lime Target Line and "Goal 2000" Pill
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                // Horizontal dashed lime target guideline with "Goal 2000" pill attached
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 30 + (130 * (target / chartCeiling)).clamp(0.0, 140.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomPaint(
                          painter: _DashedLinePainter(
                            color: AppColors.accent.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E2B0E) : const Color(0xFFEFF8DE),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? AppColors.accent.withValues(alpha: 0.8) : const Color(0xFF4D7C0F),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'Goal $target',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: isDark ? AppColors.accent : const Color(0xFF4D7C0F),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 7-Day Vertical Bars (M, T, W, T, F, S, S)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(7, (index) {
                    final dayDate = _selectedWeekStart.add(Duration(days: index));
                    final log = weekLogs.firstWhere(
                      (l) => l.date.day == dayDate.day,
                      orElse: () => DailyLogEntity(date: dayDate, totalCalories: 0, dailyGoal: target),
                    );
                    final ratio = chartCeiling > 0 ? (log.totalCalories / chartCeiling).clamp(0.0, 1.0) : 0.0;
                    final isToday = dayDate.day == now.day &&
                        dayDate.month == now.month &&
                        dayDate.year == now.year;
                    const dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (log.totalCalories > 0)
                          Text(
                            '${log.totalCalories}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: textPrimary,
                            ),
                          )
                        else
                          const SizedBox(height: 14),
                        const SizedBox(height: 6),
                        if (log.totalCalories > 0)
                          Container(
                            width: 26,
                            height: (130 * ratio).clamp(8.0, 130.0),
                            decoration: const BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                            ),
                          )
                        else
                          Container(
                            width: 26,
                            height: 10,
                            decoration: BoxDecoration(
                              color: elevatedBg,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        const SizedBox(height: 10),
                        Text(
                          dayLabels[index],
                          style: TextStyle(
                            fontSize: isToday ? 15 : 13,
                            fontWeight: isToday ? FontWeight.w900 : FontWeight.w700,
                            color: isToday
                                ? (isDark ? AppColors.accent : const Color(0xFF4D7C0F))
                                : textSecondary,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 3. Monthly Activity Heatmap Calendar with STRICT SHADING RULE
  Widget _buildMonthlyHeatmapCard({
    required bool isDark,
    required List<DailyLogEntity> monthLogs,
    required int target,
    required bool canGoBack,
    required bool canGoForward,
    required VoidCallback onPrevious,
    required VoidCallback onNext,
  }) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final monthTitle = '${months[_selectedMonth.month - 1]} ${_selectedMonth.year}';
    final daysInMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0).day;
    final firstWeekday = _selectedMonth.weekday; // 1 = Mon, 7 = Sun

    final cardBg = AppColors.card(isDark);
    final cardBorder = AppColors.border(isDark);
    final textPrimary = AppColors.textPrimary(isDark);
    final textSecondary = AppColors.textSecondary(isDark);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month Header with Navigation Arrows
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monthly Activity',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    monthTitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: textSecondary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left_rounded, color: canGoBack ? textPrimary : textSecondary.withValues(alpha: 0.4)),
                    onPressed: canGoBack ? onPrevious : null,
                    splashRadius: 18,
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right_rounded, color: canGoForward ? textPrimary : textSecondary.withValues(alpha: 0.4)),
                    onPressed: canGoForward ? onNext : null,
                    splashRadius: 18,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Day of week labels: M T W T F S S
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((day) {
              return SizedBox(
                width: 32,
                child: Text(
                  day,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: textSecondary,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),

          // 7-Column Calendar Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: (firstWeekday - 1) + daysInMonth,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            itemBuilder: (context, index) {
              if (index < firstWeekday - 1) {
                return const SizedBox.shrink();
              }
              final dayNum = index - (firstWeekday - 1) + 1;
              final log = monthLogs.firstWhere(
                (l) => l.date.day == dayNum,
                orElse: () => DailyLogEntity(
                  date: DateTime(_selectedMonth.year, _selectedMonth.month, dayNum),
                  totalCalories: 0,
                  dailyGoal: target,
                ),
              );

              final (tileColor, textColor) = _getHeatmapShading(log.totalCalories, target, isDark);

              return Tooltip(
                message: '$dayNum ${_selectedMonth.month}: ${log.totalCalories} kcal',
                child: Container(
                  decoration: BoxDecoration(
                    color: tileColor,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: cardBorder,
                      width: 0.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$dayNum',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // 4-Step Legend at bottom (0%, <50%, 85%, Target Hit)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _legendItem('0%', isDark ? const Color(0xFF10141B) : const Color(0xFFF1F5F9), textSecondary),
              _legendItem('<50%', isDark ? const Color(0xFF1B381A) : const Color(0xFFD9F99D), textSecondary),
              _legendItem('85%', isDark ? const Color(0xFF184E18) : const Color(0xFF84CC16), textSecondary),
              _legendItem(
                'Target Hit',
                isDark ? const Color(0xFF14380C) : const Color(0xFF365314),
                isDark ? AppColors.accent : Colors.white,
                isDarkText: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color color, Color textColor, {bool isDarkText = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 13,
          height: 13,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(
              color: isDarkText ? AppColors.accent.withValues(alpha: 0.4) : Colors.black.withValues(alpha: 0.08),
              width: 0.5,
            ),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ],
    );
  }

  // STRICT SHADING RULE:
  // - Days where target is completed (100%+): rendered in darkest/deepest theme shade:
  //   Dark Mode: rich deep forest emerald #14380C with bright lime text #B8F624
  //   White Mode: #365314 with white text
  // - Partially completed (50%-95%): intermediate shade
  // - Low (1%-49%): light shade
  // - Unlogged (0%): base subtle surface shade
  (Color, Color) _getHeatmapShading(int calories, int target, bool isDark) {
    if (calories == 0) {
      final baseBg = isDark ? const Color(0xFF171C26) : const Color(0xFFF1F5F9);
      final text = isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8);
      return (baseBg, text);
    }

    final ratio = calories / target;

    if (ratio < 0.50) {
      // 1% - 49%
      final bg = isDark ? const Color(0xFF1B381A) : const Color(0xFFD9F99D);
      final text = isDark ? const Color(0xFFA3E635) : const Color(0xFF365314);
      return (bg, text);
    } else if (ratio < 1.0) {
      // 50% - 95%
      final bg = isDark ? const Color(0xFF184E18) : const Color(0xFF84CC16);
      final text = isDark ? const Color(0xFFD9F99D) : Colors.white;
      return (bg, text);
    } else {
      // 100%+ Target Hit (Strictly Darkest/Deepest Shade)
      final bg = isDark ? const Color(0xFF14380C) : const Color(0xFF365314);
      final text = isDark ? AppColors.accent : Colors.white;
      return (bg, text);
    }
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;

  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 4.0;
    const dashSpace = 4.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
