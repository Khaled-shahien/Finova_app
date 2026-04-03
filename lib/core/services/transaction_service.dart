import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/transaction_model.dart';
import '../errors/app_exceptions.dart';
import 'auth_service.dart';

/// CRUD and streams for user transactions.
class TransactionService {
  TransactionService._();

  static final TransactionService instance = TransactionService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _collectionForUser(String uid) {
    return _firestore.collection('users').doc(uid).collection('transactions');
  }

  Stream<List<TransactionModel>> streamTransactions({String? userId}) {
    final uid = userId ?? AuthService.instance.currentUser?.uid;
    if (uid == null) {
      return Stream<List<TransactionModel>>.value(const []);
    }

    return _collectionForUser(uid)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TransactionModel.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Stream<List<TransactionModel>> streamRecentTransactions({
    String? userId,
    int limit = 5,
  }) {
    final uid = userId ?? AuthService.instance.currentUser?.uid;
    if (uid == null) {
      return Stream<List<TransactionModel>>.value(const []);
    }

    return _collectionForUser(uid)
        .orderBy('date', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TransactionModel.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    final uid = AuthService.instance.currentUser?.uid;
    if (uid == null) {
      throw const UnauthenticatedException();
    }

    final payload = transaction.copyWith(userId: uid);
    try {
      await _collectionForUser(uid).add(payload.toMap());
    } on FirebaseException catch (error) {
      throw FirebaseOperationException.fromFirestore(error);
    }
  }
}
