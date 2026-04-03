import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';
import 'auth_service.dart';

/// Service for reading and writing user profile documents in Firestore.
class UserService {
  UserService({required AuthService authService, FirebaseFirestore? firestore})
    : _authService = authService,
      _firestore = firestore ?? FirebaseFirestore.instance;

  final AuthService _authService;
  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _profileDoc(String uid) {
    return _firestore.collection('users').doc(uid);
  }

  Stream<UserModel?> streamCurrentUserProfile() {
    return _authService.authStateChanges().asyncExpand((user) {
      if (user == null) {
        return Stream<UserModel?>.value(null);
      }
      return _profileDoc(user.uid).snapshots().map((snapshot) {
        final data = snapshot.data();
        if (data == null) {
          return _defaultProfile(user);
        }
        return UserModel.fromMap(user.uid, data);
      });
    });
  }

  Future<UserModel?> getCurrentUserProfile() async {
    final user = _authService.currentUser;
    if (user == null) {
      return null;
    }

    final snapshot = await _profileDoc(user.uid).get();
    final data = snapshot.data();
    if (data == null) {
      return _defaultProfile(user);
    }
    return UserModel.fromMap(user.uid, data);
  }

  Future<void> ensureUserProfile() async {
    final user = _authService.currentUser;
    if (user == null) {
      return;
    }

    final profile = _defaultProfile(user);
    await _profileDoc(user.uid).set(profile.toMap(), SetOptions(merge: true));
  }

  Future<void> updateUserProfile(UserModel profile) {
    return _profileDoc(
      profile.uid,
    ).set(profile.toMap(), SetOptions(merge: true));
  }

  UserModel _defaultProfile(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? 'Finova User',
      isDarkMode: false,
      currency: 'USD',
    );
  }
}
