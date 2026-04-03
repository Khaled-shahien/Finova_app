import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../models/budget_model.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/services/budget_service.dart';
import '../../../core/theme/app_theme.dart';

/// Budget management screen aligned with design assets.
class BudgetManagementScreen extends StatelessWidget {
  const BudgetManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: StreamBuilder<List<BudgetModel>>(
          stream: BudgetService.instance.streamBudgets(),
          builder: (context, snapshot) {
            final budgets = snapshot.data ?? const <BudgetModel>[];
            final cards = budgets.isEmpty ? _fallbackBudgets : budgets;
            return ListView(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 116),
              children: [
                _topBar(),
                const SizedBox(height: 18),
                _overview(),
                const SizedBox(height: 20),
                ...cards.map((budget) => _budgetCard(budget, context)),
                _addCategoryCard(),
                const SizedBox(height: 16),
                _forecastCard(context),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _topBar() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.primaryFixed,
          child: Icon(Icons.person, color: AppColors.primary),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Text(
            'The Financial Atelier',
            style: TextStyle(fontSize: 26 / 2, fontWeight: FontWeight.w800),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications),
          color: AppColors.outline,
        ),
      ],
    );
  }

  Widget _overview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'MONTHLY OVERVIEW',
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 3,
            color: AppColors.outline,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 6),
        Text(
          '\$2,450.00',
          style: TextStyle(fontSize: 60 / 2 * 2, fontWeight: FontWeight.w800),
        ),
        SizedBox(height: 2),
        Row(
          children: [
            Icon(Icons.arrow_upward, size: 14, color: AppColors.secondary),
            SizedBox(width: 4),
            Text(
              '12%',
              style: TextStyle(
                color: AppColors.secondary,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 6),
            Text(
              'Remaining budget for October',
              style: TextStyle(
                color: AppColors.onSurfaceVariant,
                fontSize: 20 / 2,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _budgetCard(BudgetModel budget, BuildContext context) {
    final over = budget.progress > 1;
    final statusText = over
        ? 'EXCEEDED'
        : (budget.progress > 0.7 ? 'GETTING CLOSE' : 'GOOD STANDING');
    final statusColor = over
        ? AppColors.error
        : (budget.progress > 0.7
              ? const Color(0xFFE4A900)
              : AppColors.secondary);

    final remaining = budget.limitAmount - budget.spentAmount;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.topRight,
            child: Icon(
              Icons.more_horiz,
              color: AppColors.outlineVariant,
              size: 20,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _categoryBg(budget.icon),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _categoryIcon(budget.icon),
                  color: _categoryFg(budget.icon),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            budget.name,
            style: const TextStyle(
              fontSize: 30 / 2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '\$${budget.spentAmount.toStringAsFixed(2)} of \$${budget.limitAmount.toStringAsFixed(2)}',
            style: const TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 24 / 2,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: LinearProgressIndicator(
              value: budget.progress.clamp(0, 1),
              backgroundColor: AppColors.surfaceContainerHigh,
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                statusText,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              ),
              const Spacer(),
              Text(
                over
                    ? '-\$${remaining.abs().toStringAsFixed(2)} over'
                    : '\$${remaining.toStringAsFixed(2)} left',
                style: TextStyle(
                  color: over ? AppColors.error : AppColors.onSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: 26 / 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _addCategoryCard() {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 14),
      padding: const EdgeInsets.fromLTRB(18, 26, 18, 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.5),
          width: 1.5,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.dashboard_customize,
            color: AppColors.outline,
            size: 34,
          ),
          const SizedBox(height: 10),
          const Text(
            'Build Your Ledger',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            'Define a new category to start\ntracking your spending with\neditorial precision.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 15),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Add New Category'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _forecastCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'The Spending Forecast',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          const Text(
            'Based on your current habits, you are on track to save \$450 more than last month. Consider moving these funds to your "High-Yield Savings" budget.',
            style: TextStyle(color: AppColors.onSurfaceVariant, height: 1.35),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => context.go(RouteNames.insights),
            iconAlignment: IconAlignment.end,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('View Detailed Analytics'),
          ),
        ],
      ),
    );
  }

  static final List<BudgetModel> _fallbackBudgets = [
    BudgetModel(
      id: '1',
      userId: 'sample',
      name: 'Food & Dining',
      limitAmount: 800,
      spentAmount: 640,
      icon: 'restaurant',
      updatedAt: DateTime(2026, 1, 1),
    ),
    BudgetModel(
      id: '2',
      userId: 'sample',
      name: 'Rent & Utilities',
      limitAmount: 2500,
      spentAmount: 1200,
      icon: 'home',
      updatedAt: DateTime(2026, 1, 1),
    ),
    BudgetModel(
      id: '3',
      userId: 'sample',
      name: 'Transport',
      limitAmount: 300,
      spentAmount: 350,
      icon: 'directions_car',
      updatedAt: DateTime(2026, 1, 1),
    ),
    BudgetModel(
      id: '4',
      userId: 'sample',
      name: 'Entertainment',
      limitAmount: 400,
      spentAmount: 120,
      icon: 'confirmation_number',
      updatedAt: DateTime(2026, 1, 1),
    ),
  ];

  static Color _categoryBg(String icon) {
    switch (icon) {
      case 'restaurant':
        return AppColors.tertiaryContainer.withValues(alpha: 0.3);
      case 'home':
        return AppColors.secondaryContainer;
      case 'directions_car':
        return AppColors.errorContainer;
      default:
        return AppColors.primaryFixed;
    }
  }

  static Color _categoryFg(String icon) {
    switch (icon) {
      case 'restaurant':
        return AppColors.onTertiaryFixedVariant;
      case 'home':
        return AppColors.onSecondaryContainer;
      case 'directions_car':
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }

  static IconData _categoryIcon(String icon) {
    switch (icon) {
      case 'restaurant':
        return Icons.restaurant;
      case 'home':
        return Icons.home;
      case 'directions_car':
        return Icons.directions_car;
      default:
        return Icons.confirmation_number;
    }
  }
}
