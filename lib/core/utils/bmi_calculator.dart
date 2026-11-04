import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum BmiCategory {
  underweight('Underweight', AppColors.bmiUnderweight),
  normal('Healthy', AppColors.bmiHealthy),
  overweight('Overweight', AppColors.bmiOverweight),
  obese('Obese', AppColors.bmiObese);

  final String label;
  final Color color;

  const BmiCategory(this.label, this.color);
}

class BmiCalculator {
  BmiCalculator._();

  /// Calculates BMI given height in cm and weight in kg
  static double calculate({
    required double heightCm,
    required double weightKg,
  }) {
    if (heightCm <= 0 || weightKg <= 0) return 0.0;
    final heightMeters = heightCm / 100.0;
    final bmi = weightKg / (heightMeters * heightMeters);
    return double.parse(bmi.toStringAsFixed(1));
  }

  /// Convert feet and inches to cm
  static double feetInchesToCm(int feet, int inches) {
    final totalInches = (feet * 12) + inches;
    return totalInches * 2.54;
  }

  /// Convert cm to feet and inches [feet, inches]
  static (int, int) cmToFeetInches(double cm) {
    final totalInches = (cm / 2.54).round();
    final feet = totalInches ~/ 12;
    final inches = totalInches % 12;
    return (feet, inches);
  }

  /// Convert lbs to kg
  static double lbsToKg(double lbs) => lbs * 0.45359237;

  /// Convert kg to lbs
  static double kgToLbs(double kg) => kg / 0.45359237;

  static BmiCategory getCategory(double bmi) {
    if (bmi < 18.5) return BmiCategory.underweight;
    if (bmi < 25.0) return BmiCategory.normal;
    if (bmi < 30.0) return BmiCategory.overweight;
    return BmiCategory.obese;
  }
}
