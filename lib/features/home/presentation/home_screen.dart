import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../models/transaction_model.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/services/transaction_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/cards.dart';
import '../data/home_repository.dart';

/// Main dashboard screen with balance and recent activity.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final HomeRepository _homeRepository = HomeRepository(
    TransactionService.instance,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<HomeDashboardData>(
        stream: _homeRepository.streamDashboardData(),
        builder: (context, snapshot) {
          final dashboard =
              snapshot.data ??
              const HomeDashboardData(
                transactions: <TransactionModel>[],
                totalIncome: 0,
                totalExpense: 0,
                netBalance: 0,
                weeklyExpense: <double>[0, 0, 0, 0, 0, 0, 0],
              );

          return RefreshIndicator(
            onRefresh: () async {
              await Future<void>.delayed(const Duration(milliseconds: 250));
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 26),
              children: [
                _HomeHeader(onProfileTap: () => context.go(RouteNames.profile)),
                const SizedBox(height: 18),
                _BalanceCard(balance: dashboard.netBalance),
                const SizedBox(height: 14),
                _MonthlySummaryCard(
                  income: dashboard.totalIncome,
                  expenses: dashboard.totalExpense,
                ),
                const SizedBox(height: 14),
                _WeeklySpendingCard(values: dashboard.weeklyExpense),
                const SizedBox(height: 14),
                _QuickActionsRow(
                  onAddExpense: () => context.go(RouteNames.addTransaction),
                  onAddIncome: () => context.go(RouteNames.addTransaction),
                ),
                const SizedBox(height: 20),
                _RecentSectionHeader(
                  onViewAllTap: () => context.go(RouteNames.transactions),
                ),
                const SizedBox(height: 10),
                _RecentTransactionsList(
                  transactions: dashboard.transactions
                      .take(AppConstants.dashboardRecentTransactionLimit)
                      .toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.onProfileTap});

  final VoidCallback onProfileTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Morning',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Text(
                'Khaled',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: onProfileTap,
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: const CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primaryFixed,
            child: Icon(Icons.person, color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.balance});

  final double balance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryContainer],
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.onPrimary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -28,
            bottom: -38,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: AppColors.onPrimary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Balance',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.onPrimary.withValues(alpha: 0.8),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${AppConstants.defaultCurrencySymbol}${balance.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.onPrimary.withValues(alpha: 0.17),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  '+12.5% Since last month',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MonthlySummaryCard extends StatelessWidget {
  const _MonthlySummaryCard({required this.income, required this.expenses});

  final double income;
  final double expenses;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Summary',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  label: 'Income',
                  value: income,
                  color: AppColors.secondary,
                  icon: Icons.north_east,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SummaryMetric(
                  label: 'Expenses',
                  value: expenses,
                  color: AppColors.tertiary,
                  icon: Icons.south_east,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final double value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodySmall),
                Text(
                  '${AppConstants.defaultCurrencySymbol}${value.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklySpendingCard extends StatelessWidget {
  const _WeeklySpendingCard({required this.values});

  final List<double> values;

  @override
  Widget build(BuildContext context) {
    final maxValue = values.fold<double>(
      0,
      (max, item) => item > max ? item : max,
    );
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Spending',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 96,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(labels.length, (index) {
                final value = index < values.length ? values[index] : 0;
                final ratio = maxValue == 0
                    ? 0.15
                    : (value / maxValue).clamp(0.15, 1.0);
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 350),
                          height: 72 * ratio,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(
                              alpha: 0.22 + ratio * 0.7,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          labels[index],
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow({
    required this.onAddExpense,
    required this.onAddIncome,
  });

  final VoidCallback onAddExpense;
  final VoidCallback onAddIncome;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionCard(
            title: 'Add Expense',
            subtitle: 'Track spending',
            icon: Icons.remove_circle_outline,
            color: AppColors.tertiary,
            onTap: onAddExpense,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickActionCard(
            title: 'Add Income',
            subtitle: 'Log earnings',
            icon: Icons.add_circle_outline,
            color: AppColors.secondary,
            onTap: onAddIncome,
          ),
        ),
      ],
    );
  }
}

class _RecentSectionHeader extends StatelessWidget {
  const _RecentSectionHeader({required this.onViewAllTap});

  final VoidCallback onViewAllTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Recent Activity',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        TextButton(onPressed: onViewAllTap, child: const Text('View All')),
      ],
    );
  }
}

class _RecentTransactionsList extends StatelessWidget {
  const _RecentTransactionsList({required this.transactions});

  final List<TransactionModel> transactions;

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: const Text(
          'No transactions yet. Start by adding your first one.',
        ),
      );
    }

    return Column(
      children: transactions
          .map(
            (tx) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TransactionCard(
                merchant: tx.title,
                category: tx.category,
                time: DateFormatter.time(tx.date),
                amount: tx.amount,
                isIncome: !tx.isExpense,
                iconData: tx.icon,
              ),
            ),
          )
          .toList(),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
