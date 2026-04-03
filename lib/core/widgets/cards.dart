import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// A transaction card widget displaying transaction details
class TransactionCard extends StatelessWidget {
  final String merchant;
  final String category;
  final String time;
  final double amount;
  final bool isIncome;
  final String iconData;
  final VoidCallback? onTap;

  const TransactionCard({
    super.key,
    required this.merchant,
    required this.category,
    required this.time,
    required this.amount,
    this.isIncome = false,
    this.iconData = 'payments',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getIconBackgroundColor(),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Icon(_getIcon(), color: _getIconColor(), size: 24),
            ),
            const SizedBox(width: 16),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    merchant,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$category • $time',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            // Amount
            Text(
              '${isIncome ? '+' : '-'}\$${amount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isIncome ? AppColors.secondary : AppColors.tertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (iconData) {
      case 'restaurant':
        return Icons.restaurant_outlined;
      case 'shopping_bag':
        return Icons.shopping_bag_outlined;
      case 'directions_car':
        return Icons.directions_car_outlined;
      case 'payments':
        return Icons.payments_outlined;
      case 'local_taxi':
        return Icons.local_taxi_outlined;
      default:
        return Icons.receipt_outlined;
    }
  }

  Color _getIconBackgroundColor() {
    switch (iconData) {
      case 'restaurant':
        return AppColors.primaryFixed;
      case 'shopping_bag':
        return AppColors.secondaryFixed;
      case 'directions_car':
        return AppColors.tertiaryFixed;
      case 'payments':
        return AppColors.primaryFixed;
      case 'local_taxi':
        return AppColors.secondaryFixed;
      default:
        return AppColors.surfaceContainerHighest;
    }
  }

  Color _getIconColor() {
    switch (iconData) {
      case 'restaurant':
        return AppColors.onPrimaryFixedVariant;
      case 'shopping_bag':
        return AppColors.onSecondaryFixedVariant;
      case 'directions_car':
        return AppColors.onTertiaryFixedVariant;
      default:
        return AppColors.onSurfaceVariant;
    }
  }
}

/// A budget category card showing progress
class BudgetCategoryCard extends StatelessWidget {
  final String title;
  final double spent;
  final double limit;
  final String iconData;
  final Color statusColor;
  final String statusText;
  final VoidCallback? onTap;

  const BudgetCategoryCard({
    super.key,
    required this.title,
    required this.spent,
    required this.limit,
    required this.iconData,
    required this.statusColor,
    required this.statusText,
    this.onTap,
  });

  double get percentage => (spent / limit).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getIconBackgroundColor(),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: Icon(_getIcon(), color: _getIconColor(), size: 24),
                ),
                IconButton(
                  onPressed: () {
                    // More options
                  },
                  icon: const Icon(Icons.more_horiz),
                  color: AppColors.outline,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Title and amounts
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${spent.toStringAsFixed(2)} of \$${limit.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: AppColors.surfaceContainerHigh,
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                minHeight: 12,
              ),
            ),
            const SizedBox(height: 12),
            // Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  statusText,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${(limit - spent).toStringAsFixed(2)} left',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (iconData) {
      case 'restaurant':
        return Icons.restaurant_outlined;
      case 'home':
        return Icons.home_outlined;
      case 'directions_car':
        return Icons.directions_car_outlined;
      case 'confirmation_number':
        return Icons.confirmation_number_outlined;
      default:
        return Icons.category_outlined;
    }
  }

  Color _getIconBackgroundColor() {
    switch (iconData) {
      case 'restaurant':
        return AppColors.tertiaryFixed;
      case 'home':
        return AppColors.secondaryFixed;
      case 'directions_car':
        return AppColors.errorContainer;
      case 'confirmation_number':
        return AppColors.primaryFixed;
      default:
        return AppColors.surfaceContainerHighest;
    }
  }

  Color _getIconColor() {
    switch (iconData) {
      case 'restaurant':
        return AppColors.onTertiaryFixedVariant;
      case 'home':
        return AppColors.onSecondaryContainer;
      case 'directions_car':
        return AppColors.onErrorContainer;
      case 'confirmation_number':
        return AppColors.onPrimaryFixedVariant;
      default:
        return AppColors.onSurfaceVariant;
    }
  }
}
