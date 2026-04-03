import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/budget_model.dart';
import '../errors/app_exceptions.dart';
import 'auth_service.dart';

/// CRUD and streams for user budgets.
class BudgetService {
  BudgetService._();

  static final BudgetService instance = BudgetService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _collectionForUser(String uid) {
    return _firestore.collection('users').doc(uid).collection('budgets');
  }

  Stream<List<BudgetModel>> streamBudgets({String? userId}) {
    final uid = userId ?? AuthService.instance.currentUser?.uid;
    if (uid == null) {
      return Stream<List<BudgetModel>>.value(const []);
    }

    return _collectionForUser(uid)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => BudgetModel.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> upsertBudget(BudgetModel budget) async {
    final uid = AuthService.instance.currentUser?.uid;
    if (uid == null) {
      throw const UnauthenticatedException();
    }

    final collection = _collectionForUser(uid);
    final data = budget.toMap();

    try {
      if (budget.id.isEmpty) {
        await collection.add(data);
        return;
      }

      await collection.doc(budget.id).set(data, SetOptions(merge: true));
    } on FirebaseException catch (error) {
      throw FirebaseOperationException.fromFirestore(error);
    }
  }
}
