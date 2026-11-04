import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';

class AddFoodSheet extends StatefulWidget {
  final Function(String name, int calories) onAdd;

  const AddFoodSheet({
    super.key,
    required this.onAdd,
  });

  @override
  State<AddFoodSheet> createState() => _AddFoodSheetState();
}

class _AddFoodSheetState extends State<AddFoodSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();

  final List<Map<String, dynamic>> _quickSuggestions = [
    {'name': 'Avocado Toast', 'calories': 350, 'emoji': '🥑'},
    {'name': 'Grilled Chicken', 'calories': 330, 'emoji': '🍗'},
    {'name': 'Greek Salad', 'calories': 220, 'emoji': '🥗'},
    {'name': 'Boiled Egg (1 pc)', 'calories': 78, 'emoji': '🥚'},
    {'name': 'Oatmeal Bowl', 'calories': 280, 'emoji': '🥣'},
    {'name': 'Apple & PB', 'calories': 190, 'emoji': '🍎'},
    {'name': 'Latte Coffee', 'calories': 140, 'emoji': '☕'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final calories = int.parse(_caloriesController.text.trim());
      widget.onAdd(name, calories);
      Navigator.of(context).pop();
    }
  }

  void _selectSuggestion(String name, int calories) {
    setState(() {
      _nameController.text = name;
      _caloriesController.text = calories.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottomInset),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: 44,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF25292D) : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.restaurant_rounded,
                      color: isDark ? AppColors.accent : const Color(0xFF4D7C0F),
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Add Food Item',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                  splashRadius: 20,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Enter the meal name and calorie count below.',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 18),
            // Form
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Food Name Field
                  Text(
                    'Food Name',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                    decoration: InputDecoration(
                      hintText: 'e.g. Avocado Salad',
                      hintStyle: TextStyle(
                        color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.fastfood_outlined,
                        color: isDark ? AppColors.accent : const Color(0xFF4D7C0F),
                        size: 20,
                      ),
                      filled: true,
                      fillColor: isDark ? AppColors.elevated(isDark) : AppColors.backgroundLight,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        borderSide: BorderSide(color: AppColors.accent, width: 1.5),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Please enter a food name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  // Calorie Field
                  Text(
                    'Calories (kcal)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _caloriesController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: TextStyle(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                    decoration: InputDecoration(
                      hintText: 'e.g. 350',
                      hintStyle: TextStyle(
                        color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.local_fire_department_outlined,
                        color: isDark ? AppColors.accent : const Color(0xFF4D7C0F),
                        size: 20,
                      ),
                      suffixText: 'kcal',
                      suffixStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      filled: true,
                      fillColor: isDark ? AppColors.elevated(isDark) : AppColors.backgroundLight,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        borderSide: BorderSide(color: AppColors.accent, width: 1.5),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Please enter calorie amount';
                      }
                      final parsed = int.tryParse(val.trim());
                      if (parsed == null || parsed <= 0) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  // Quick Suggestions
                  Text(
                    'Quick Suggestions',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _quickSuggestions.map((item) {
                      return InkWell(
                        onTap: () => _selectSuggestion(item['name'], item['calories']),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.accentDim : const Color(0xFFEFF8DE),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark ? AppColors.accent.withValues(alpha: 0.3) : const Color(0xFFD4EDB0),
                            ),
                          ),
                          child: Text(
                            '${item['emoji']} ${item['name']} • ${item['calories']} kcal',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.accent : const Color(0xFF4D7C0F),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.onAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text(
                        'Add Food',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.onAccent),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
