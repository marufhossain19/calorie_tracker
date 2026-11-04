import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../core/constants/app_colors.dart';
import 'name_input_screen.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entryController;
  late final Animation<double> _emblemScale;
  late final Animation<double> _emblemFade;
  late final Animation<Offset> _contentSlide;
  late final Animation<double> _contentFade;
  late final Animation<Offset> _buttonSlide;
  late final Animation<double> _buttonFade;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _emblemScale = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutBack),
      ),
    );
    _emblemFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );

    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.35, 0.85, curve: Curves.easeOutCubic),
      ),
    );
    _contentFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.35, 0.85, curve: Curves.easeOut),
      ),
    );

    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOutCubic),
      ),
    );
    _buttonFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTest = WidgetsBinding.instance.runtimeType.toString().contains('Test');

    final bgColor = AppColors.background(isDark);
    final cardBg = AppColors.card(isDark);
    final cardBorder = AppColors.border(isDark);
    final textPrimary = AppColors.textPrimary(isDark);
    final textSecondary = AppColors.textSecondary(isDark);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const Spacer(),

              // Circular emblem container with Walking Avocado Lottie animation + splash entry animation
              Center(
                child: FadeTransition(
                  opacity: _emblemFade,
                  child: ScaleTransition(
                    scale: _emblemScale,
                    child: Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        color: cardBg,
                        shape: BoxShape.circle,
                        border: Border.all(color: cardBorder, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withValues(alpha: isDark ? 0.20 : 0.12),
                            blurRadius: 44,
                            spreadRadius: 6,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Lottie.asset(
                          'lib/presentation/assets/Walking Avocado.json',
                          fit: BoxFit.contain,
                          repeat: !isTest,
                          animate: !isTest,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.eco_rounded,
                            size: 96,
                            color: isDark ? AppColors.accent : const Color(0xFF4D7C0F),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Animated Headline and Subtitle
              FadeTransition(
                opacity: _contentFade,
                child: SlideTransition(
                  position: _contentSlide,
                  child: Column(
                    children: [
                      // Headline: "Track Your Daily Calories With Precision"
                      Text(
                        'Track Your Daily Calories\nWith Precision',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          height: 1.25,
                          letterSpacing: -0.5,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Subtitle: "Monitor your meals, achieve healthy targets, and stay energized every single day."
                      Text(
                        'Monitor your meals, achieve healthy targets, and stay energized every single day.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),

              // Bottom full-width primary CTA button: "Get Started →" with entrance animation
              FadeTransition(
                opacity: _buttonFade,
                child: SlideTransition(
                  position: _buttonSlide,
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const NameInputScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.onAccent,
                        elevation: isDark ? 4 : 0,
                        shadowColor: isDark ? AppColors.accent.withValues(alpha: 0.35) : Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Get Started',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: AppColors.onAccent,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: AppColors.onAccent,
                            size: 20,
                          ),
                        ],
                      ),
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
