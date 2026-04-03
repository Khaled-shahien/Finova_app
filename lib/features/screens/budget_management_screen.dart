import 'package:flutter/material.dart';

import '../../core/models/budget_model.dart';
import '../../core/services/budget_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_bar.dart';
import '../../core/widgets/cards.dart';

/// Budget screen with fixed sliver layout.
class BudgetManagementScreen extends StatelessWidget {
  const BudgetManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EditorialAppBar(title: 'Budgets'),
      body: StreamBuilder<List<BudgetModel>>(
        stream: BudgetService.instance.streamBudgets(),
        builder: (context, snapshot) {
          final budgets = snapshot.data ?? const <BudgetModel>[];
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                  child: Text(
                    'Monthly Budget Overview',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (budgets.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text('No budgets created yet')),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final budget = budgets[index];
                      return BudgetCategoryCard(
                        title: budget.name,
                        spent: budget.spentAmount,
                        limit: budget.limitAmount,
                        iconData: budget.icon,
                        statusColor: budget.progress > 1
                            ? AppColors.error
                            : AppColors.secondary,
                        statusText: budget.progress > 1
                            ? 'Exceeded'
                            : 'On Track',
                      );
                    }, childCount: budgets.length),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 420,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.35,
                        ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
