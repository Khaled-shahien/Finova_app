import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// A customizable bottom navigation bar following the editorial design system
class EditorialBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const EditorialBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.8),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 32,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, icon: 'home', label: 'Home', index: 0),
              _buildNavItem(
                context,
                icon: 'receipt_long',
                label: 'History',
                index: 1,
              ),
              _buildAddButton(context),
              _buildNavItem(
                context,
                icon: 'insights',
                label: 'Insight',
                index: 3,
              ),
              _buildNavItem(
                context,
                icon: 'account_balance_wallet',
                label: 'Budget',
                index: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required String icon,
    required String label,
    required int index,
  }) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.full),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIconData(icon),
              color: isSelected ? AppColors.primary : Colors.grey.shade400,
              size: 24,
              fill: isSelected ? 1 : 0,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 1.5,
                color: isSelected ? AppColors.primary : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    final isCenterActive = currentIndex == 2;

    return GestureDetector(
      onTap: () => onTap(2),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: isCenterActive
              ? const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryContainer],
                )
              : null,
          color: isCenterActive ? null : AppColors.surfaceContainerHighest,
          shape: BoxShape.circle,
          boxShadow: isCenterActive
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Icon(
          Icons.add,
          color: isCenterActive
              ? AppColors.onPrimary
              : AppColors.onSurfaceVariant,
          size: 28,
          fill: isCenterActive ? 1 : 0,
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    // Using Material Symbols outlined icons
    switch (iconName) {
      case 'home':
        return Icons.home_outlined;
      case 'receipt_long':
        return Icons.receipt_long_outlined;
      case 'insights':
        return Icons.insights_outlined;
      case 'account_balance_wallet':
        return Icons.account_balance_wallet_outlined;
      default:
        return Icons.circle_outlined;
    }
  }
}
