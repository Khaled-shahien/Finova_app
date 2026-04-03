import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../core/models/transaction_model.dart';
import '../../core/services/transaction_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_bar.dart';

/// Analytics screen based on live transaction data.
class AnalyticsInsightsScreen extends StatefulWidget {
  const AnalyticsInsightsScreen({super.key});

  @override
  State<AnalyticsInsightsScreen> createState() =>
      _AnalyticsInsightsScreenState();
}

class _AnalyticsInsightsScreenState extends State<AnalyticsInsightsScreen> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EditorialAppBar(title: 'Insights'),
      body: StreamBuilder<List<TransactionModel>>(
        stream: TransactionService.instance.streamTransactions(),
        builder: (context, snapshot) {
          final expenses = (snapshot.data ?? const <TransactionModel>[])
              .where((tx) => tx.isExpense)
              .toList();
          final categories = _groupByCategory(expenses);

          if (categories.isEmpty) {
            return const Center(child: Text('No expense data yet'));
          }

          final sorted = categories.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              SizedBox(
                height: 280,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 76,
                    pieTouchData: PieTouchData(
                      touchCallback: (event, response) {
                        setState(() {
                          _touchedIndex =
                              response?.touchedSection?.touchedSectionIndex ??
                              -1;
                        });
                      },
                    ),
                    sections: List<PieChartSectionData>.generate(
                      sorted.length,
                      (index) {
                        final entry = sorted[index];
                        final touched = index == _touchedIndex;
                        return PieChartSectionData(
                          value: entry.value,
                          color: _colorForIndex(index),
                          title: touched ? entry.key : '',
                          radius: touched ? 76 : 64,
                          titleStyle: Theme.of(
                            context,
                          ).textTheme.labelSmall?.copyWith(color: Colors.white),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              ...sorted.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return ListTile(
                  dense: true,
                  leading: CircleAvatar(backgroundColor: _colorForIndex(index)),
                  title: Text(item.key),
                  trailing: Text('\$${item.value.toStringAsFixed(2)}'),
                );
              }),
            ],
          );
        },
      ),
    );
  }

  Map<String, double> _groupByCategory(List<TransactionModel> transactions) {
    final grouped = <String, double>{};
    for (final tx in transactions) {
      grouped.update(
        tx.category,
        (value) => value + tx.amount,
        ifAbsent: () => tx.amount,
      );
    }
    return grouped;
  }

  Color _colorForIndex(int index) {
    const palette = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.tertiary,
      AppColors.primaryContainer,
      AppColors.secondaryContainer,
    ];
    return palette[index % palette.length];
  }
}
