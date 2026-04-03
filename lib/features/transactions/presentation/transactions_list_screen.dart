import 'package:flutter/material.dart';

import '../../../models/transaction_model.dart';
import '../../../core/services/transaction_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/cards.dart';

/// Shows all transactions loaded from Firestore.
class TransactionsListScreen extends StatefulWidget {
  const TransactionsListScreen({super.key});

  @override
  State<TransactionsListScreen> createState() => _TransactionsListScreenState();
}

class _TransactionsListScreenState extends State<TransactionsListScreen> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: StreamBuilder<List<TransactionModel>>(
          stream: TransactionService.instance.streamTransactions(),
          builder: (context, snapshot) {
            final data = snapshot.data ?? const <TransactionModel>[];
            final filters = _buildFilters(data);
            final visible = _filterTransactions(data);
            final grouped = _groupTransactionsByDate(visible);

            return Column(
              children: [
                const _TransactionsBrandBar(),
                const _LedgerHeading(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Search merchant or category...',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                SizedBox(
                  height: 46,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: filters.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final filter = filters[index];
                      final selected = filter == _selectedFilter;
                      return ChoiceChip(
                        label: Text(filter),
                        selected: selected,
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: selected
                              ? AppColors.onPrimary
                              : AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        onSelected: (_) {
                          setState(() => _selectedFilter = filter);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: visible.isEmpty
                      ? const Center(child: Text('No transactions found'))
                      : ListView(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                          children: grouped.entries.map((entry) {
                            final dayTransactions = entry.value;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 12,
                                    bottom: 8,
                                  ),
                                  child: Text(
                                    DateFormatter.ledgerHeader(entry.key),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          color: AppColors.onSurfaceVariant,
                                          letterSpacing: 1.8,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ),
                                ...dayTransactions.map((tx) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: TransactionCard(
                                      merchant: tx.title,
                                      category: tx.category,
                                      time: DateFormatter.time(tx.date),
                                      amount: tx.amount,
                                      isIncome: !tx.isExpense,
                                      iconData: tx.icon,
                                    ),
                                  );
                                }),
                              ],
                            );
                          }).toList(),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<String> _buildFilters(List<TransactionModel> data) {
    final categories = data.map((tx) => tx.category).toSet().toList()..sort();
    return ['All', ...categories];
  }

  List<TransactionModel> _filterTransactions(List<TransactionModel> source) {
    final search = _searchController.text.trim().toLowerCase();

    return source.where((tx) {
      final matchesFilter =
          _selectedFilter == 'All' || tx.category == _selectedFilter;
      if (!matchesFilter) {
        return false;
      }
      if (search.isEmpty) {
        return true;
      }
      return tx.title.toLowerCase().contains(search) ||
          tx.category.toLowerCase().contains(search);
    }).toList();
  }

  Map<DateTime, List<TransactionModel>> _groupTransactionsByDate(
    List<TransactionModel> source,
  ) {
    final groups = <DateTime, List<TransactionModel>>{};
    for (final tx in source) {
      final key = DateTime(tx.date.year, tx.date.month, tx.date.day);
      groups.update(key, (value) => [...value, tx], ifAbsent: () => [tx]);
    }

    final entries = groups.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));
    return {for (final entry in entries) entry.key: entry.value};
  }
}

class _TransactionsBrandBar extends StatelessWidget {
  const _TransactionsBrandBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 2),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primaryFixed,
            child: Icon(Icons.person, color: AppColors.primary),
          ),
          const SizedBox(width: 10),
          Text(
            'The Financial Atelier',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const Spacer(),
          IconButton(onPressed: () {}, icon: const Icon(Icons.tune)),
        ],
      ),
    );
  }
}

class _LedgerHeading extends StatelessWidget {
  const _LedgerHeading();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LEDGER',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              letterSpacing: 2.8,
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Transactions',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
