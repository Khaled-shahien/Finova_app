import 'package:flutter/material.dart';

import '../../core/models/transaction_model.dart';
import '../../core/services/transaction_service.dart';
import '../../core/widgets/app_bar.dart';
import '../../core/widgets/cards.dart';

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
      appBar: const EditorialAppBar(title: 'Transactions'),
      body: StreamBuilder<List<TransactionModel>>(
        stream: TransactionService.instance.streamTransactions(),
        builder: (context, snapshot) {
          final data = snapshot.data ?? const <TransactionModel>[];
          final filters = _buildFilters(data);
          final visible = _filterTransactions(data);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'Search title or category',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              SizedBox(
                height: 46,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final filter = filters[index];
                    final selected = filter == _selectedFilter;
                    return ChoiceChip(
                      label: Text(filter),
                      selected: selected,
                      onSelected: (_) {
                        setState(() => _selectedFilter = filter);
                      },
                    );
                  },
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemCount: filters.length,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: visible.isEmpty
                    ? const Center(child: Text('No transactions found'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: visible.length,
                        itemBuilder: (context, index) {
                          final tx = visible[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: TransactionCard(
                              merchant: tx.title,
                              category: tx.category,
                              time: _formatDate(tx.date),
                              amount: tx.amount,
                              isIncome: !tx.isExpense,
                              iconData: tx.icon,
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
