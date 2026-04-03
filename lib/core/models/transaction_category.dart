import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Comprehensive transaction categories with associated metadata.
///
/// Each category provides consistent icon, color, and label information
/// used throughout the application UI.
enum TransactionCategory {
  /// Food & dining expenses
  food,

  /// Shopping and retail purchases
  shopping,

  /// Transportation costs
  transport,

  /// Housing and utilities
  housing,

  /// Entertainment and leisure
  entertainment,

  /// Bills and payments
  bills,

  /// Income sources
  income,

  /// Investment contributions
  investment,

  /// Healthcare expenses
  health,

  /// Education costs
  education,

  /// Personal care
  personalCare,

  /// Other miscellaneous
  other;

  /// Display name for the category.
  String get displayName {
    switch (this) {
      case TransactionCategory.food:
        return 'Food';
      case TransactionCategory.shopping:
        return 'Shopping';
      case TransactionCategory.transport:
        return 'Transport';
      case TransactionCategory.housing:
        return 'Housing';
      case TransactionCategory.entertainment:
        return 'Entertainment';
      case TransactionCategory.bills:
        return 'Bills';
      case TransactionCategory.income:
        return 'Income';
      case TransactionCategory.investment:
        return 'Investment';
      case TransactionCategory.health:
        return 'Health';
      case TransactionCategory.education:
        return 'Education';
      case TransactionCategory.personalCare:
        return 'Personal Care';
      case TransactionCategory.other:
        return 'Other';
    }
  }

  /// Material icon representing the category.
  IconData get icon {
    switch (this) {
      case TransactionCategory.food:
        return Icons.restaurant;
      case TransactionCategory.shopping:
        return Icons.shopping_bag;
      case TransactionCategory.transport:
        return Icons.directions_car;
      case TransactionCategory.housing:
        return Icons.home_work;
      case TransactionCategory.entertainment:
        return Icons.movie;
      case TransactionCategory.bills:
        return Icons.receipt_long;
      case TransactionCategory.income:
        return Icons.attach_money;
      case TransactionCategory.investment:
        return Icons.trending_up;
      case TransactionCategory.health:
        return Icons.medical_services;
      case TransactionCategory.education:
        return Icons.school;
      case TransactionCategory.personalCare:
        return Icons.spa;
      case TransactionCategory.other:
        return Icons.category;
    }
  }

  /// Background color for category badges and chips.
  Color get backgroundColor {
    switch (this) {
      case TransactionCategory.food:
        return AppColors.primaryFixed;
      case TransactionCategory.shopping:
        return AppColors.secondaryContainer;
      case TransactionCategory.transport:
        return AppColors.tertiaryFixed;
      case TransactionCategory.housing:
        return AppColors.surfaceContainerHigh;
      case TransactionCategory.entertainment:
        return AppColors.primaryFixed;
      case TransactionCategory.bills:
        return AppColors.surfaceContainerHighest;
      case TransactionCategory.income:
        return AppColors.secondaryContainer;
      case TransactionCategory.investment:
        return AppColors.primaryFixed;
      case TransactionCategory.health:
        return AppColors.tertiaryFixed;
      case TransactionCategory.education:
        return AppColors.secondaryFixed;
      case TransactionCategory.personalCare:
        return AppColors.tertiaryFixed;
      case TransactionCategory.other:
        return AppColors.surfaceContainerHighest;
    }
  }

  /// Foreground/icon color for the category.
  Color get foregroundColor {
    switch (this) {
      case TransactionCategory.food:
        return AppColors.primary;
      case TransactionCategory.shopping:
        return AppColors.onSecondaryContainer;
      case TransactionCategory.transport:
        return AppColors.onTertiaryFixedVariant;
      case TransactionCategory.housing:
        return AppColors.outline;
      case TransactionCategory.entertainment:
        return AppColors.primary;
      case TransactionCategory.bills:
        return AppColors.onSurfaceVariant;
      case TransactionCategory.income:
        return AppColors.onSecondaryContainer;
      case TransactionCategory.investment:
        return AppColors.primary;
      case TransactionCategory.health:
        return AppColors.onTertiaryFixedVariant;
      case TransactionCategory.education:
        return AppColors.onSecondaryFixedVariant;
      case TransactionCategory.personalCare:
        return AppColors.onTertiaryFixedVariant;
      case TransactionCategory.other:
        return AppColors.onSurfaceVariant;
    }
  }

  /// Key string used for serialization to Firestore.
  String get key {
    switch (this) {
      case TransactionCategory.food:
        return 'food';
      case TransactionCategory.shopping:
        return 'shopping';
      case TransactionCategory.transport:
        return 'transport';
      case TransactionCategory.housing:
        return 'housing';
      case TransactionCategory.entertainment:
        return 'entertainment';
      case TransactionCategory.bills:
        return 'bills';
      case TransactionCategory.income:
        return 'income';
      case TransactionCategory.investment:
        return 'investment';
      case TransactionCategory.health:
        return 'health';
      case TransactionCategory.education:
        return 'education';
      case TransactionCategory.personalCare:
        return 'personal_care';
      case TransactionCategory.other:
        return 'other';
    }
  }

  /// Create category from string key (for deserialization).
  static TransactionCategory fromKey(String key) {
    switch (key.toLowerCase()) {
      case 'food':
        return TransactionCategory.food;
      case 'shopping':
        return TransactionCategory.shopping;
      case 'transport':
        return TransactionCategory.transport;
      case 'housing':
        return TransactionCategory.housing;
      case 'entertainment':
        return TransactionCategory.entertainment;
      case 'bills':
        return TransactionCategory.bills;
      case 'income':
        return TransactionCategory.income;
      case 'investment':
        return TransactionCategory.investment;
      case 'health':
        return TransactionCategory.health;
      case 'education':
        return TransactionCategory.education;
      case 'personal_care':
      case 'personalcare':
        return TransactionCategory.personalCare;
      default:
        return TransactionCategory.other;
    }
  }
}
