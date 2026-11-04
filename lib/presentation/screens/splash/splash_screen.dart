import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/user_controller.dart';
import '../main_navigation_screen.dart';
import '../onboarding/get_started_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // 0ms - 450ms (Badge Entrance & Ignition)
  late final Animation<double> _badgeScaleAnimation;
  late final Animation<double> _badgeOpacityAnimation;
  late final Animation<double> _glowOpacityAnimation;
  late final Animation<double> _flamePulseAnimation;

  // 200ms - 550ms (Wordmark Reveal)
  late final Animation<double> _textSlideAnimation;
  late final Animation<double> _textOpacityAnimation;

  // 700ms - 900ms (Exit Cross-Fade)
  late final Animation<double> _exitFadeAnimation;
  late final Animation<double> _exitScaleAnimation;
  late final Animation<double> _destinationFadeAnimation;

  bool _isNavigated = false;

  @override
  void initState() {
    super.initState();

    final isTest =
        WidgetsBinding.instance.runtimeType.toString().contains('Test');
    final duration = isTest
        ? const Duration(milliseconds: 50)
        : const Duration(milliseconds: 900);

    _controller = AnimationController(vsync: this, duration: duration);

    // 0ms - 450ms: Badge entrance (scale: 0.75 -> 1.0, opacity: 0 -> 1)
    final badgeCurve = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.50, curve: Cubic(0.22, 1.0, 0.36, 1.0)),
    );
    _badgeScaleAnimation =
        Tween<double>(begin: 0.75, end: 1.0).animate(badgeCurve);
    _badgeOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.40, curve: Curves.easeOut),
      ),
    );
    _glowOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.50, curve: Curves.easeOut),
      ),
    );

    // Inner flame ignition pulse: scale(0.85) -> scale(1.06) -> scale(1.0)
    _flamePulseAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.85, end: 1.06)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 65,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.06, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 35,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.50),
      ),
    );

    // 200ms - 550ms: Wordmark reveal (translateY 14 -> 0, opacity 0 -> 1)
    final textCurve = CurvedAnimation(
      parent: _controller,
      curve:
          const Interval(0.222, 0.611, curve: Cubic(0.16, 1.0, 0.3, 1.0)),
    );
    _textSlideAnimation =
        Tween<double>(begin: 14.0, end: 0.0).animate(textCurve);
    _textOpacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(textCurve);

    // 700ms - 900ms: Seamless Exit Transition
    final exitCurve = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.778, 1.0, curve: Curves.easeInOut),
    );
    _exitFadeAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(exitCurve);
    _exitScaleAnimation =
        Tween<double>(begin: 1.0, end: 1.03).animate(exitCurve);
    _destinationFadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(exitCurve);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToDestination();
      }
    });

    _controller.forward();
  }

  void _navigateToDestination() {
    if (_isNavigated || !mounted) return;
    _isNavigated = true;

    final userController = Provider.of<UserController>(context, listen: false);
    final targetScreen = !userController.isOnboarded
        ? const GetStartedScreen()
        : const MainNavigationScreen();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
        transitionDuration: Duration.zero,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context, listen: false);
    final targetScreen = !userController.isOnboarded
        ? const GetStartedScreen()
        : const MainNavigationScreen();

    return Scaffold(
      backgroundColor: const Color(0xFF05070A),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Destination screen pre-mounted and fading in smoothly from 700ms to 900ms
          AnimatedBuilder(
            animation: _destinationFadeAnimation,
            builder: (context, child) {
              if (_destinationFadeAnimation.value == 0.0) {
                return const SizedBox.shrink();
              }
              return Opacity(
                opacity: _destinationFadeAnimation.value,
                child: child,
              );
            },
            child: targetScreen,
          ),

          // Splash view content with exit crossfade & scale
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              if (_exitFadeAnimation.value == 0.0) {
                return const SizedBox.shrink();
              }
              return Opacity(
                opacity: _exitFadeAnimation.value,
                child: Transform.scale(
                  scale: _exitScaleAnimation.value,
                  child: child,
                ),
              );
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Center Emblem Container
                Center(
                  child: _buildCenterEmblem(),
                ),

                // Bottom Branding Lockup (Positioned 56px from bottom matching Image 2)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 56,
                  child: _buildBottomBranding(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterEmblem() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Opacity(
          opacity: _badgeOpacityAnimation.value,
          child: Transform.scale(
            scale: _badgeScaleAnimation.value,
            child: SizedBox(
              width: 260,
              height: 260,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Soft ambient radial glow behind the circle
                  Opacity(
                    opacity: _glowOpacityAnimation.value,
                    child: Container(
                      width: 260,
                      height: 260,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Color(0x35B8F624), // rgba(184, 246, 36, 0.21)
                            Colors.transparent,
                          ],
                          stops: [0.0, 0.70],
                        ),
                      ),
                    ),
                  ),

                  // Circular dark surface badge matching reference
                  Container(
                    width: 156,
                    height: 156,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF131714),
                      border: Border.all(
                        color:
                            const Color(0xFFB8F624).withValues(alpha: 0.14),
                        width: 1.0,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Transform.scale(
                      scale: _flamePulseAnimation.value,
                      child: Image.asset(
                        'lib/presentation/assets/flame_icon_lime.png',
                        width: 104,
                        height: 104,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomBranding() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _textOpacityAnimation.value,
          child: Transform.translate(
            offset: Offset(0, _textSlideAnimation.value),
            child: child,
          ),
        );
      },
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'CalTrack',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.6,
              color: Colors.white,
              height: 1.15,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Track Your Daily Calories',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.2,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}

