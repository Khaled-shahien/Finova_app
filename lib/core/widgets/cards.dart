import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A transaction card widget displaying transaction details.
class TransactionCard extends StatelessWidget {
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

  final String merchant;
  final String category;
  final String time;
  final double amount;
  final bool isIncome;
  final String iconData;
  final VoidCallback? onTap;

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
