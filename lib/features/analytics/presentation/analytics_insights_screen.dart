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
            final monthlyIncome = [
              2800.0,
              3200.0,
              3000.0,
              3600.0,
              3400.0,
              3900.0,
            ];
            final monthlyExpense = [
              2100.0,
              2400.0,
              2300.0,
              2600.0,
              2550.0,
              2700.0,
            ];

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
                const SizedBox(height: 14),
                _TrendsCard(
                  incomeValues: monthlyIncome,
                  expenseValues: monthlyExpense,
                ),
                const SizedBox(height: 14),
                _DetailedBreakdownCard(sorted: sorted),
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

class _TrendsCard extends StatelessWidget {
  const _TrendsCard({required this.incomeValues, required this.expenseValues});

  final List<double> incomeValues;
  final List<double> expenseValues;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Spending Trends',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          const Text(
            'Comparison between Income & Expenses',
            style: TextStyle(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                minY: 0,
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 1000,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => const FlLine(
                    color: AppColors.outlineVariant,
                    strokeWidth: 0.6,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const labels = [
                          'Jan',
                          'Feb',
                          'Mar',
                          'Apr',
                          'May',
                          'Jun',
                        ];
                        if (value < 0 || value > 5) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            labels[value.toInt()],
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.outline,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      incomeValues.length,
                      (i) => FlSpot(i.toDouble(), incomeValues[i]),
                    ),
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                  ),
                  LineChartBarData(
                    spots: List.generate(
                      expenseValues.length,
                      (i) => FlSpot(i.toDouble(), expenseValues[i]),
                    ),
                    isCurved: true,
                    color: AppColors.tertiary,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailedBreakdownCard extends StatelessWidget {
  const _DetailedBreakdownCard({required this.sorted});

  final List<MapEntry<String, double>> sorted;

  @override
  Widget build(BuildContext context) {
    final items = sorted.isEmpty
        ? const [
            MapEntry<String, double>('Food & Dining', 1240),
            MapEntry<String, double>('Entertainment', 450),
            MapEntry<String, double>('Transportation', 890),
          ]
        : sorted.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detailed Breakdown',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          ...items.map((entry) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.receipt_long,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const Text(
                          'Monthly category total',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${entry.value.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
