import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../core/constants/app_colors.dart';
import 'target_input_screen.dart';

class NameInputScreen extends StatefulWidget {
  const NameInputScreen({super.key});

  @override
  State<NameInputScreen> createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_formKey.currentState!.validate()) {
      final name = _controller.text.trim();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => TargetInputScreen(userName: name),
        ),
      );
    }
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
        // 2-step progress indicator bars in center (Step 1 active)
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 24,
              height: 5,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E232B) : const Color(0xFFE2E8F0),
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Vertically & Horizontally centered input block
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Lottie Animation: enter name.json
                          SizedBox(
                            width: 220,
                            height: 165,
                            child: Transform.scale(
                              scale: 1.4,
                              child: Lottie.asset(
                                'lib/presentation/assets/enter name.json',
                                fit: BoxFit.contain,
                                repeat: !isTest,
                                animate: !isTest,
                                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // 1. Title
                          Text(
                            "What's your name?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // 2. Subtitle
                          Text(
                            "This helps us personalize your daily calorie plan.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: textSecondary,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // 3. Clean Centered Text Input Field
                          Container(
                            width: double.infinity,
                            constraints: const BoxConstraints(maxWidth: 380),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _controller.text.trim().isNotEmpty
                                    ? AppColors.accent
                                    : cardBorder,
                                width: 1.5,
                              ),
                              boxShadow: isDark && _controller.text.trim().isNotEmpty
                                  ? [
                                      BoxShadow(
                                        color: AppColors.accent.withValues(alpha: 0.12),
                                        blurRadius: 16,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: TextFormField(
                              controller: _controller,
                              autofocus: true,
                              textCapitalization: TextCapitalization.words,
                              textAlign: TextAlign.start,
                              cursorColor: isDark ? AppColors.accent : const Color(0xFF4D7C0F),
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3,
                                color: textPrimary,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter your name',
                                hintStyle: TextStyle(
                                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) => _onContinue(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom full-width CTA button: "Continue"
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.onAccent,
                      elevation: isDark ? 4 : 0,
                      shadowColor: isDark ? AppColors.accent.withValues(alpha: 0.35) : Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
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
      ),
    );
  }
}
