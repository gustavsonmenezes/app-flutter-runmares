import 'package:runmares/features/auth/domain/auth_failure.dart';

AuthFailure authFailureFromFirebaseCode(String code) {
  return switch (code) {
    'invalid-email' => AuthFailure.invalidEmail,
    'user-not-found' ||
    'wrong-password' ||
    'invalid-credential' => AuthFailure.wrongCredentials,
    'email-already-in-use' => AuthFailure.emailAlreadyInUse,
    'weak-password' => AuthFailure.weakPassword,
    'network-request-failed' => AuthFailure.network,
    'too-many-requests' => AuthFailure.tooManyRequests,
    _ => AuthFailure.unknown,
  };
}
