import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'analytics/analytics_screen.dart';
import 'food/food_screen.dart';
import 'home/home_screen.dart';
import 'profile/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => MainNavigationScreenState();
}

class MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  void setIndex(int index) {
    if (index >= 0 && index < _screens.length) {
      setState(() => _currentIndex = index);
    }
  }

  final List<Widget> _screens = const [
    HomeScreen(),
    FoodScreen(),
    AnalyticsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final navBg = isDark ? AppColors.backgroundDark : AppColors.cardLight;
    final navBorder = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: navBg,
          border: Border(
            top: BorderSide(color: navBorder, width: 1),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  label: 'Home',
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  isDark: isDark,
                ),
                _buildNavItem(
                  index: 1,
                  label: 'Food',
                  icon: Icons.restaurant_outlined,
                  activeIcon: Icons.restaurant_rounded,
                  isDark: isDark,
                ),
                _buildNavItem(
                  index: 2,
                  label: 'Analytics',
                  icon: Icons.bar_chart_outlined,
                  activeIcon: Icons.bar_chart_rounded,
                  isDark: isDark,
                ),
                _buildNavItem(
                  index: 3,
                  label: 'Profile',
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData icon,
    required IconData activeIcon,
    required bool isDark,
  }) {
    final isSelected = _currentIndex == index;
    final currentIcon = isSelected ? activeIcon : icon;

    // Dark Mode:
    // - NO background pill/container fill
    // - Active: icon and text colored #B8F624 (AppColors.accent)
    // - Inactive: #64748B (AppColors.mutedDark)
    //
    // Light Mode:
    // - NO background pill/container fill (same style as dark mode)
    // - Active: icon and text colored solid black (#0F172A)
    // - Inactive: #64748B (AppColors.mutedLight)

    Color iconColor;
    Color labelColor;
    const pillColor = Colors.transparent;

    if (isDark) {
      if (isSelected) {
        iconColor = AppColors.accent;
        labelColor = AppColors.accent;
      } else {
        iconColor = AppColors.mutedDark;
        labelColor = AppColors.mutedDark;
      }
    } else {
      if (isSelected) {
        iconColor = const Color(0xFF0F172A);
        labelColor = const Color(0xFF0F172A);
      } else {
        iconColor = const Color(0xFF64748B);
        labelColor = const Color(0xFF64748B);
      }
    }

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _currentIndex = index),
        borderRadius: BorderRadius.circular(16),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                decoration: BoxDecoration(
                  color: pillColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  currentIcon,
                  size: 22,
                  color: iconColor,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  letterSpacing: -0.2,
                  color: labelColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
