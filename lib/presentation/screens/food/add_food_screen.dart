import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../controllers/calorie_tracker_controller.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  String? _selectedImagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
      );
      if (picked != null) {
        setState(() {
          _selectedImagePath = picked.path;
        });
      }
    } catch (_) {
      // Gracefully handle web/desktop or permission fallbacks
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final calories = int.parse(_caloriesController.text.trim());
      final tracker = context.read<CalorieTrackerController>();

      // 1. Add to food items list so it appears in FoodScreen and IntakeFoodSheet
      tracker.addCatalogItem(
        name: name,
        calories: calories,
        imagePath: _selectedImagePath,
        servingSize: '1 serving',
      );

      // 2. Also log meal intake for today
      tracker.addFood(
        name,
        calories,
        imagePath: _selectedImagePath,
        servingSize: '1 serving',
        tags: ['Nutritious', 'Logged'],
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Add Food Item',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.3,
            color: textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Food Name Input
                Text(
                  'Food Name *',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: cardBorder, width: 1),
                  ),
                  child: TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'e.g. Grilled Chicken',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                      prefixIcon: Icon(Icons.restaurant_menu_rounded, color: textSecondary, size: 20),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Please enter a food name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 22),

                // 2. Calorie Amount Input with quick increment chips (+50, +100, +250)
                Text(
                  'Calorie Amount (kcal) *',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: cardBorder, width: 1),
                  ),
                  child: TextFormField(
                    controller: _caloriesController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'e.g. 450',
                      hintStyle: TextStyle(
                        fontSize: 15,
                        color: textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                      prefixIcon: Icon(Icons.local_fire_department_rounded, color: textSecondary, size: 20),
                      suffixText: 'kcal',
                      suffixStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: textSecondary,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Please enter calorie amount';
                      }
                      final n = int.tryParse(val.trim());
                      if (n == null || n <= 0) {
                        return 'Enter a valid calorie number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 22),

                // 3. Choose Image from Gallery Dropzone (Positioned after inputting calories)
                Text(
                  'Food Photo (Gallery)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _pickImage,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _selectedImagePath != null ? AppColors.accent : cardBorder,
                        width: 1.5,
                      ),
                    ),
                    child: _selectedImagePath != null
                        ? Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: _selectedImagePath!.startsWith('lib/')
                                    ? Image.asset(
                                        _selectedImagePath!,
                                        width: 64,
                                        height: 64,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(_selectedImagePath!),
                                        width: 64,
                                        height: 64,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Photo Selected',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Tap to change photo',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.accentDim : const Color(0xFFEFF8DE),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Change',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? AppColors.accent : const Color(0xFF4D7C0F),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.accentDim : const Color(0xFFEFF8DE),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.add_photo_alternate_rounded,
                                  color: isDark ? AppColors.accent : const Color(0xFF4D7C0F),
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Choose a Photo',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Select from device gallery • JPG, PNG',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 32),

                // Bottom full-width CTA button: "Add Food Item"
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _submit,
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
                      'Add Food Item',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: AppColors.onAccent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
