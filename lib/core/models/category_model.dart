import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Transaction and budget categories with visual metadata.
enum TransactionCategory {
  food,
  shopping,
  transport,
  housing,
  entertainment,
  income,
  general,
}

extension TransactionCategoryX on TransactionCategory {
  static const List<TransactionCategory> expenseCategories = [
    TransactionCategory.food,
    TransactionCategory.shopping,
    TransactionCategory.transport,
    TransactionCategory.housing,
    TransactionCategory.entertainment,
  ];

  String get label => switch (this) {
    TransactionCategory.food => 'Food',
    TransactionCategory.shopping => 'Shopping',
    TransactionCategory.transport => 'Transport',
    TransactionCategory.housing => 'Housing',
    TransactionCategory.entertainment => 'Entertainment',
    TransactionCategory.income => 'Income',
    TransactionCategory.general => 'General',
  };

  String get iconKey => switch (this) {
    TransactionCategory.food => 'restaurant',
    TransactionCategory.shopping => 'shopping_bag',
    TransactionCategory.transport => 'directions_car',
    TransactionCategory.housing => 'home',
    TransactionCategory.entertainment => 'confirmation_number',
    TransactionCategory.income => 'payments',
    TransactionCategory.general => 'payments',
  };

  IconData get icon => switch (this) {
    TransactionCategory.food => Icons.restaurant_outlined,
    TransactionCategory.shopping => Icons.shopping_bag_outlined,
    TransactionCategory.transport => Icons.directions_car_outlined,
    TransactionCategory.housing => Icons.home_outlined,
    TransactionCategory.entertainment => Icons.confirmation_number_outlined,
    TransactionCategory.income => Icons.payments_outlined,
    TransactionCategory.general => Icons.receipt_outlined,
  };

  Color get backgroundColor => switch (this) {
    TransactionCategory.food => AppColors.primaryFixed,
    TransactionCategory.shopping => AppColors.secondaryContainer,
    TransactionCategory.transport => AppColors.tertiaryFixed,
    TransactionCategory.housing => AppColors.surfaceContainerHigh,
    TransactionCategory.entertainment => AppColors.tertiaryContainer.withValues(
      alpha: 0.18,
    ),
    TransactionCategory.income => AppColors.secondaryFixed,
    TransactionCategory.general => AppColors.surfaceContainerHighest,
  };

  Color get foregroundColor => switch (this) {
    TransactionCategory.food => AppColors.onPrimaryFixedVariant,
    TransactionCategory.shopping => AppColors.onSecondaryContainer,
    TransactionCategory.transport => AppColors.onTertiaryFixedVariant,
    TransactionCategory.housing => AppColors.outline,
    TransactionCategory.entertainment => AppColors.tertiary,
    TransactionCategory.income => AppColors.onSecondaryFixedVariant,
    TransactionCategory.general => AppColors.onSurfaceVariant,
  };

  static TransactionCategory fromLabel(String label) {
    return TransactionCategory.values.firstWhere(
      (category) => category.label.toLowerCase() == label.toLowerCase(),
      orElse: () => TransactionCategory.general,
    );
  }

  static TransactionCategory fromIconKey(String iconKey) {
    return TransactionCategory.values.firstWhere(
      (category) => category.iconKey == iconKey,
      orElse: () => TransactionCategory.general,
    );
  }
}
