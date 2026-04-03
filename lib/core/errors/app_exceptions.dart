import 'package:firebase_auth/firebase_auth.dart';

/// Base exception for known, user-facing application failures.
class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Exception thrown when an operation requires an authenticated user.
class UnauthenticatedException extends AppException {
  const UnauthenticatedException()
    : super('Please sign in to continue this action.');
}

/// Exception thrown when a Firebase request fails.
class FirebaseOperationException extends AppException {
  const FirebaseOperationException(super.message);

  factory FirebaseOperationException.fromAuth(FirebaseAuthException error) {
    return FirebaseOperationException(
      error.message ?? 'Authentication failed.',
    );
  }

  factory FirebaseOperationException.fromFirestore(FirebaseException error) {
    return FirebaseOperationException(error.message ?? 'Request failed.');
  }
}
