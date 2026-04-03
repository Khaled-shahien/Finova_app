import '../../../core/constants/app_constants.dart';
import '../../../core/services/transaction_service.dart';
import '../../../models/transaction_model.dart';

/// Aggregate payload used by the dashboard UI.
class HomeDashboardData {
  const HomeDashboardData({
    required this.transactions,
    required this.totalIncome,
    required this.totalExpense,
    required this.netBalance,
    required this.weeklyExpense,
  });

  final List<TransactionModel> transactions;
  final double totalIncome;
  final double totalExpense;
  final double netBalance;
  final List<double> weeklyExpense;
}

/// Repository that computes home-screen aggregates from transaction streams.
class HomeRepository {
  const HomeRepository(this._transactionService);

  final TransactionService _transactionService;

  Stream<HomeDashboardData> streamDashboardData() {
    return _transactionService.streamTransactions().map((transactions) {
      final income = transactions
          .where((tx) => !tx.isExpense)
          .fold<double>(0, (sum, tx) => sum + tx.amount);
      final expense = transactions
          .where((tx) => tx.isExpense)
          .fold<double>(0, (sum, tx) => sum + tx.amount);

      return HomeDashboardData(
        transactions: transactions,
        totalIncome: income,
        totalExpense: expense,
        netBalance: income - expense,
        weeklyExpense: _computeWeeklyExpense(transactions),
      );
    });
  }

  Stream<List<TransactionModel>> streamRecentTransactions() {
    return _transactionService.streamRecentTransactions(
      limit: AppConstants.dashboardRecentTransactionLimit,
    );
  }

  List<double> _computeWeeklyExpense(List<TransactionModel> transactions) {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));
    final buckets = List<double>.filled(7, 0);

    for (final tx in transactions) {
      if (!tx.isExpense) {
        continue;
      }

      final txDate = DateTime(tx.date.year, tx.date.month, tx.date.day);
      final startDate = DateTime(start.year, start.month, start.day);
      final dayIndex = txDate.difference(startDate).inDays;

      if (dayIndex >= 0 && dayIndex < 7) {
        buckets[dayIndex] += tx.amount;
      }
    }

    return buckets;
  }
}
