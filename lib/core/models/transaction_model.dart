import 'package:cloud_firestore/cloud_firestore.dart';

/// Immutable transaction entity stored in Firestore.
class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.category,
    required this.amount,
    required this.isExpense,
    required this.date,
    this.notes,
    this.icon = 'payments',
  });

  final String id;
  final String userId;
  final String title;
  final String category;
  final double amount;
  final bool isExpense;
  final DateTime date;
  final String? notes;
  final String icon;

  factory TransactionModel.fromMap(String id, Map<String, dynamic> map) {
    return TransactionModel(
      id: id,
      userId: (map['userId'] as String?) ?? '',
      title: (map['title'] as String?) ?? 'Untitled',
      category: (map['category'] as String?) ?? 'Other',
      amount: (map['amount'] as num?)?.toDouble() ?? 0,
      isExpense: (map['isExpense'] as bool?) ?? true,
      date: _parseDate(map['date']),
      notes: map['notes'] as String?,
      icon: (map['icon'] as String?) ?? 'payments',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'title': title,
      'category': category,
      'amount': amount,
      'isExpense': isExpense,
      'date': Timestamp.fromDate(date),
      'notes': notes,
      'icon': icon,
    };
  }

  TransactionModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? category,
    double? amount,
    bool? isExpense,
    DateTime? date,
    String? notes,
    String? icon,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      isExpense: isExpense ?? this.isExpense,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      icon: icon ?? this.icon,
    );
  }

  static DateTime _parseDate(dynamic raw) {
    if (raw is Timestamp) {
      return raw.toDate();
    }
    if (raw is DateTime) {
      return raw;
    }
    return DateTime.now();
  }
}
