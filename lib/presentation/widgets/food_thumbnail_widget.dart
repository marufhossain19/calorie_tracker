import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Renders food thumbnails safely with memory caching ([cacheWidth], [cacheHeight])
/// whether the image is from bundled assets, local file storage, or fallback icons.
class FoodThumbnailWidget extends StatelessWidget {
  final String? imagePath;
  final double width;
  final double height;
  final double borderRadius;
  final IconData fallbackIcon;

  const FoodThumbnailWidget({
    super.key,
    required this.imagePath,
    this.width = 52,
    this.height = 52,
    this.borderRadius = 14,
    this.fallbackIcon = Icons.restaurant_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (imagePath != null && imagePath!.isNotEmpty) {
      // 1. Bundled Asset Image (e.g. from lib/presentation/assets/)
      if (imagePath!.startsWith('lib/') || imagePath!.startsWith('assets/')) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Image.asset(
            imagePath!,
            width: width,
            height: height,
            cacheWidth: (width * 3).round(),
            cacheHeight: (height * 3).round(),
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _buildFallback(isDark),
          ),
        );
      }

      // 2. Local File Image (from camera / gallery upload)
      if (!imagePath!.startsWith('preset:')) {
        final file = File(imagePath!);
        if (file.existsSync()) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Image.file(
              file,
              width: width,
              height: height,
              cacheWidth: (width * 3).round(),
              cacheHeight: (height * 3).round(),
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _buildFallback(isDark),
            ),
          );
        }
      }
    }

    // 3. Fallback Icon Badge
    return _buildFallback(isDark);
  }

  Widget _buildFallback(bool isDark) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B2810) : AppColors.primaryLight,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: isDark ? const Color(0xFFB5F52E).withValues(alpha: 0.3) : AppColors.primaryBorder,
          width: 1,
        ),
      ),
      child: Icon(
        fallbackIcon,
        color: isDark ? const Color(0xFFB5F52E) : AppColors.primary,
        size: width * 0.45,
      ),
    );
  }
}
