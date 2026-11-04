import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CalorieGaugeWidget extends StatelessWidget {
  final int totalCalories;
  final int dailyGoal;

  const CalorieGaugeWidget({
    super.key,
    required this.totalCalories,
    required this.dailyGoal,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final double progress = dailyGoal > 0
        ? (totalCalories / dailyGoal).clamp(0.0, 1.0)
        : 0.0;
    final int remaining = dailyGoal - totalCalories > 0 ? dailyGoal - totalCalories : 0;

    final cardBg = AppColors.card(isDark);
    final cardBorder = AppColors.border(isDark);
    final textPrimary = AppColors.textPrimary(isDark);
    final textSecondary = AppColors.textSecondary(isDark);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cardBorder, width: 1),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Column(
        children: [
          // Card Header: "Today Calories" on left, target badge ("2000 kcal") on right
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today Calories',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                  color: textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.accentDim : const Color(0xFFEFF8DE),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? AppColors.accent.withValues(alpha: 0.3)
                        : const Color(0xFFD4EDB0),
                    width: 1,
                  ),
                ),
                child: Text(
                  '$dailyGoal kcal',
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

          // 180-degree Semi-Circular Gauge
          SizedBox(
            width: 300,
            height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // CustomPainter for track, tick marks, active arc, tip dot, and dynamic outer pill
                CustomPaint(
                  size: const Size(300, 180),
                  painter: _SemiCircularGaugePainter(
                    progress: progress,
                    isDark: isDark,
                  ),
                ),

                // Center text inside the arch (NO flame icon)
                Positioned(
                  bottom: 14,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Remaining',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$remaining',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                          color: textPrimary,
                        ),
                      ),
                      Text(
                        'kcal remaining',
                        style: TextStyle(
                          fontSize: 11,
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
        ],
      ),
    );
  }
}

class _SemiCircularGaugePainter extends CustomPainter {
  final double progress;
  final bool isDark;

  _SemiCircularGaugePainter({
    required this.progress,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Math:
    // Center of arc: cx = 150, cy = 160
    // Main arc radius R_arc = 104, stroke-width = 14
    // Start angle: 180 deg (pi) on left, sweeping -pi to 0 deg on right
    // or standard: start at pi, sweep clockwise pi
    final cx = size.width / 2;
    final cy = size.height - 18;
    const rArc = 104.0;
    const strokeWidth = 14.0;
    const rOuter = 138.0;

    const startAngle = math.pi;
    const sweepTotal = math.pi;

    final center = Offset(cx, cy);
    final arcRect = Rect.fromCircle(center: center, radius: rArc);

    // 1. Background Track
    final trackColor = isDark ? const Color(0xFF171C26) : const Color(0xFFF1F5F9);
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(arcRect, startAngle, sweepTotal, false, trackPaint);

    // 2. 33 Inner Radial Tick Marks
    final tickColor = isDark
        ? const Color(0xFF25292D).withValues(alpha: 0.6)
        : const Color(0xFFCBD5E1).withValues(alpha: 0.8);
    final tickPaint = Paint()
      ..color = tickColor
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    const tickCount = 33;
    for (int i = 0; i < tickCount; i++) {
      final angle = startAngle + (i / (tickCount - 1)) * sweepTotal;
      const innerR = rArc - 18;
      const outerR = rArc - 11;
      final p1 = Offset(cx + innerR * math.cos(angle), cy + innerR * math.sin(angle));
      final p2 = Offset(cx + outerR * math.cos(angle), cy + outerR * math.sin(angle));
      canvas.drawLine(p1, p2, tickPaint);
    }

    // 3. Active Progress Arc
    final activeSweep = sweepTotal * progress.clamp(0.0, 1.0);
    final accentColor = AppColors.accent;

    if (activeSweep > 0) {
      final activePaint = Paint()
        ..color = accentColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(arcRect, startAngle, activeSweep, false, activePaint);

      // 4. Dot at the Arc Tip
      final currentAngle = startAngle + activeSweep;
      final tipCenter = Offset(
        cx + rArc * math.cos(currentAngle),
        cy + rArc * math.sin(currentAngle),
      );

      // Outer white halo
      canvas.drawCircle(
        tipCenter,
        strokeWidth / 2 + 1.5,
        Paint()..color = isDark ? Colors.black : Colors.white,
      );

      // Inner lime dot
      canvas.drawCircle(
        tipCenter,
        strokeWidth / 2 - 1.5,
        Paint()..color = accentColor,
      );
    }

    // 5. Dynamic Outer Percentage Pill
    // Math: rad = math.pi * (1 - progressRatio)
    // In our coordinate space with startAngle = pi, sweeping clockwise to 2*pi:
    // angle = pi + pi * progress
    final currentAngle = startAngle + activeSweep;
    final pillX = cx + rOuter * math.cos(currentAngle);
    final pillY = cy + rOuter * math.sin(currentAngle);

    final percentageText = '${(progress * 100).round()}%';

    // Draw the pill background
    final pillBg = isDark ? const Color(0xFF10141B) : Colors.white;
    final pillBorder = isDark ? AppColors.accent.withValues(alpha: 0.4) : const Color(0xFFCBD5E1);

    const pillWidth = 38.0;
    const pillHeight = 22.0;
    final pillRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(pillX, pillY), width: pillWidth, height: pillHeight),
      const Radius.circular(11),
    );

    // Pill shadow
    canvas.drawRRect(
      pillRect,
      Paint()
        ..color = Colors.black.withValues(alpha: isDark ? 0.35 : 0.08)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // Pill fill
    canvas.drawRRect(pillRect, Paint()..color = pillBg);

    // Pill border
    canvas.drawRRect(
      pillRect,
      Paint()
        ..color = pillBorder
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // Text inside percentage pill
    final textPainter = TextPainter(
      text: TextSpan(
        text: percentageText,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: isDark ? AppColors.accent : const Color(0xFF4D7C0F),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(pillX - textPainter.width / 2, pillY - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _SemiCircularGaugePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isDark != isDark;
  }
}
