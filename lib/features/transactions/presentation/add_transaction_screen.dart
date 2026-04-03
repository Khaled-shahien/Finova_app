import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../models/transaction_model.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/transaction_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_formatter.dart';

/// Add transaction page with editorial layout matching design assets.
class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isExpense = true;
  bool _isSaving = false;
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Food';

  final List<Map<String, dynamic>> _categories = const [
    {
      'name': 'Food',
      'icon': Icons.restaurant,
      'bg': AppColors.primaryFixed,
      'fg': AppColors.primary,
    },
    {
      'name': 'Shopping',
      'icon': Icons.shopping_bag,
      'bg': AppColors.secondaryContainer,
      'fg': AppColors.onSecondaryContainer,
    },
    {
      'name': 'Transport',
      'icon': Icons.directions_car,
      'bg': AppColors.tertiaryFixed,
      'fg': AppColors.onTertiaryFixedVariant,
    },
    {
      'name': 'Housing',
      'icon': Icons.home_work,
      'bg': AppColors.surfaceContainerHigh,
      'fg': AppColors.outline,
    },
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
            children: [
              _buildTopBar(context),
              const SizedBox(height: 26),
              _buildTypeSwitch(),
              const SizedBox(height: 36),
              _buildAmount(),
              const SizedBox(height: 44),
              _buildCategoryHeader(),
              const SizedBox(height: 14),
              _buildCategoryGrid(),
              const SizedBox(height: 22),
              _buildDetailsCard(),
              const SizedBox(height: 16),
              _buildAttachReceipt(),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              AppColors.surface.withValues(alpha: 0.94),
              AppColors.surface,
            ],
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isSaving ? null : _saveTransaction,
            icon: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check_circle, fill: 1),
            label: const Text('Save Transaction'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
              return;
            }
            context.go(RouteNames.home);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        Text(
          'New Transaction',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const Spacer(),
        const CircleAvatar(
          radius: 21,
          backgroundColor: AppColors.surfaceContainerHigh,
          child: Icon(Icons.person, color: AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildTypeSwitch() {
    return Center(
      child: Container(
        width: 420,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildTypeButton(label: 'Expense', selected: _isExpense),
            ),
            Expanded(
              child: _buildTypeButton(label: 'Income', selected: !_isExpense),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton({required String label, required bool selected}) {
    return GestureDetector(
      onTap: () {
        setState(() => _isExpense = label == 'Expense');
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.surfaceContainerLowest
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected ? AppColors.primary : AppColors.outline,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildAmount() {
    return Column(
      children: [
        const Text(
          'ENTER AMOUNT',
          style: TextStyle(
            letterSpacing: 4,
            fontSize: 12,
            color: AppColors.outline,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 28),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                '\$',
                style: TextStyle(
                  fontSize: 64,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 84,
                  fontWeight: FontWeight.w800,
                  color: AppColors.surfaceContainerHighest,
                  height: 1,
                ),
                decoration: const InputDecoration(
                  hintText: '0.00',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                validator: (value) {
                  final amount = double.tryParse(value ?? '');
                  if (amount == null || amount <= 0) {
                    return 'Enter a valid amount.';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Category',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
        ),
        TextButton(onPressed: () {}, child: const Text('See All')),
      ],
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (context, index) {
        final item = _categories[index];
        final selected = _selectedCategory == item['name'];
        return InkWell(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          onTap: () {
            setState(() => _selectedCategory = item['name'] as String);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: selected
                  ? Border.all(color: AppColors.primary, width: 1.5)
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: item['bg'] as Color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: item['fg'] as Color,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  item['name'] as String,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        children: [
          _buildDateRow(),
          const SizedBox(height: 20),
          _buildNotesRow(),
        ],
      ),
    );
  }

  Widget _buildDateRow() {
    return InkWell(
      onTap: _selectDate,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.calendar_today_outlined,
              color: AppColors.outline,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TRANSACTION DATE',
                  style: TextStyle(
                    letterSpacing: 2,
                    color: AppColors.outline,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatLongDate(_selectedDate),
                  style: const TextStyle(
                    fontSize: 22,
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

  Widget _buildNotesRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.notes_outlined, color: AppColors.outline),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ADD NOTES',
                style: TextStyle(
                  letterSpacing: 2,
                  color: AppColors.outline,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: _notesController,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'What was this for?',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttachReceipt() {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: AppColors.outlineVariant,
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add_a_photo_outlined, color: AppColors.outline),
            SizedBox(width: 10),
            Text(
              'Attach Receipt',
              style: TextStyle(
                color: AppColors.outline,
                fontWeight: FontWeight.w500,
                fontSize: 19,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatLongDate(DateTime date) => DateFormatter.longDate(date);

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _saveTransaction() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final userId = AuthService.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please sign in first.')));
      context.go(RouteNames.auth);
      return;
    }

    setState(() => _isSaving = true);
    try {
      await TransactionService.instance.addTransaction(
        TransactionModel(
          id: '',
          userId: userId,
          title: _selectedCategory,
          category: _selectedCategory,
          amount: double.parse(_amountController.text.trim()),
          isExpense: _isExpense,
          date: _selectedDate,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          icon: _iconForCategory(_selectedCategory),
        ),
      );

      if (!mounted) {
        return;
      }
      context.go(RouteNames.transactions);
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save transaction.')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  String _iconForCategory(String category) {
    switch (category) {
      case 'Food':
        return 'restaurant';
      case 'Shopping':
        return 'shopping_bag';
      case 'Transport':
        return 'directions_car';
      case 'Housing':
        return 'home';
      default:
        return 'payments';
    }
  }
}
