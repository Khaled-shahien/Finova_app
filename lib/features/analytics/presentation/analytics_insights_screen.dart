import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/services/transaction_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/transaction_model.dart';

/// Analytics and insight screen aligned with design assets.
class AnalyticsInsightsScreen extends StatefulWidget {
  const AnalyticsInsightsScreen({super.key});

  @override
  State<AnalyticsInsightsScreen> createState() =>
      _AnalyticsInsightsScreenState();
}

class _AnalyticsInsightsScreenState extends State<AnalyticsInsightsScreen> {
  bool _isMonthly = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: StreamBuilder<List<TransactionModel>>(
          stream: TransactionService.instance.streamTransactions(),
          builder: (context, snapshot) {
            final expenses = (snapshot.data ?? const <TransactionModel>[])
                .where((tx) => tx.isExpense)
                .toList();
            final grouped = _groupByCategory(expenses);
            final sorted = grouped.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));
            final totalSpent = expenses.fold<double>(
              0,
              (sum, tx) => sum + tx.amount,
            );

            return ListView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
              children: [
                const _AnalyticsTopBar(),
                const SizedBox(height: 16),
                _RangeToggle(
                  isMonthly: _isMonthly,
                  onChanged: (value) => setState(() => _isMonthly = value),
                ),
                const SizedBox(height: 18),
                _DonutCard(sorted: sorted, totalSpent: totalSpent),
                const SizedBox(height: 14),
                _InsightCard(
                  bg: AppColors.tertiaryContainer.withValues(alpha: 0.16),
                  iconColor: AppColors.tertiary,
                  icon: Icons.restaurant,
                  badgeText: sorted.isEmpty
                      ? 'No data'
                      : '${_toPercent(sorted.first.value, sorted)}% share',
                  badgeColor: AppColors.tertiary,
                  title: sorted.isEmpty
                      ? 'Add expenses to generate category insights.'
                      : 'Top category: ${sorted.first.key}',
                  subtitle: sorted.isEmpty
                      ? 'Insights refresh automatically from your transactions.'
                      : 'You spent \$${sorted.first.value.toStringAsFixed(2)} on ${sorted.first.key.toLowerCase()}.',
                ),
                const SizedBox(height: 14),
                _InsightCard(
                  bg: AppColors.secondaryContainer.withValues(alpha: 0.2),
                  iconColor: AppColors.secondary,
                  icon: Icons.savings,
                  badgeText: 'On Track',
                  badgeColor: AppColors.secondary,
                  title: 'Savings goal reached 85% this month.',
                  subtitle: 'Keep this pace to hit your target by August.',
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Map<String, double> _groupByCategory(List<TransactionModel> items) {
    final result = <String, double>{};
    for (final tx in items) {
      result.update(
        tx.category,
        (value) => value + tx.amount,
        ifAbsent: () => tx.amount,
      );
    }
    return result;
  }

  static int _toPercent(double value, List<MapEntry<String, double>> all) {
    final total = all.fold<double>(0, (sum, item) => sum + item.value);
    if (total <= 0) {
      return 0;
    }
    return ((value / total) * 100).round();
  }
}

class _AnalyticsTopBar extends StatelessWidget {
  const _AnalyticsTopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.primaryFixed,
          child: Icon(Icons.person, color: AppColors.primary),
        ),
        const SizedBox(width: 10),
        const Text(
          'The Financial Atelier',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications, color: AppColors.primary),
        ),
      ],
    );
  }
}

class _RangeToggle extends StatelessWidget {
  const _RangeToggle({required this.isMonthly, required this.onChanged});

  final bool isMonthly;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 240,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Row(
          children: [
            _ToggleButton(
              label: 'Monthly',
              active: isMonthly,
              onTap: () => onChanged(true),
            ),
            _ToggleButton(
              label: 'Weekly',
              active: !isMonthly,
              onTap: () => onChanged(false),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.full),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: active
                ? AppColors.surfaceContainerLowest
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: active ? AppColors.primary : AppColors.onSurface,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _DonutCard extends StatelessWidget {
  const _DonutCard({required this.sorted, required this.totalSpent});

  final List<MapEntry<String, double>> sorted;
  final double totalSpent;

  @override
  Widget build(BuildContext context) {
    final sections = sorted.isEmpty
        ? <PieChartSectionData>[
            PieChartSectionData(value: 45, color: AppColors.primaryContainer),
            PieChartSectionData(value: 32, color: AppColors.secondary),
            PieChartSectionData(value: 23, color: AppColors.tertiary),
          ]
        : List<PieChartSectionData>.generate(sorted.length, (index) {
            final colors = [
              AppColors.primaryContainer,
              AppColors.secondary,
              AppColors.tertiary,
              AppColors.primary,
            ];
            return PieChartSectionData(
              value: sorted[index].value,
              color: colors[index % colors.length],
              radius: 58,
            );
          });

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        children: [
          Row(
            children: const [
              Text(
                'Category Spending',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
              ),
              Spacer(),
              Icon(Icons.more_horiz, color: AppColors.outline),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 210,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    centerSpaceRadius: 56,
                    sectionsSpace: 0,
                    sections: sections,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'TOTAL SPENT',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 1.8,
                        color: AppColors.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '\$${totalSpent.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.bg,
    required this.iconColor,
    required this.icon,
    required this.badgeText,
    required this.badgeColor,
    required this.title,
    required this.subtitle,
  });

  final Color bg;
  final Color iconColor;
  final IconData icon;
  final String badgeText;
  final Color badgeColor;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: iconColor,
                child: Icon(icon, color: AppColors.onPrimary),
              ),
              const Spacer(),
              Text(
                badgeText,
                style: TextStyle(
                  color: badgeColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
