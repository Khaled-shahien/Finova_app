import 'package:cloud_firestore/cloud_firestore.dart';

/// Immutable budget entity for monthly category planning.
class BudgetModel {
  const BudgetModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.limitAmount,
    required this.spentAmount,
    required this.icon,
    required this.updatedAt,
  });

  final String id;
  final String userId;
  final String name;
  final double limitAmount;
  final double spentAmount;
  final String icon;
  final DateTime updatedAt;

  double get remainingAmount => limitAmount - spentAmount;
  double get progress => limitAmount == 0 ? 0 : (spentAmount / limitAmount);

  factory BudgetModel.fromMap(String id, Map<String, dynamic> map) {
    return BudgetModel(
      id: id,
      userId: (map['userId'] as String?) ?? '',
      name: (map['name'] as String?) ?? 'General',
      limitAmount: (map['limitAmount'] as num?)?.toDouble() ?? 0,
      spentAmount: (map['spentAmount'] as num?)?.toDouble() ?? 0,
      icon: (map['icon'] as String?) ?? 'category',
      updatedAt: _parseDate(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'name': name,
      'limitAmount': limitAmount,
      'spentAmount': spentAmount,
      'icon': icon,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
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
