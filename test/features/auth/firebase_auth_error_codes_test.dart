import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/features/auth/data/firebase_auth_error_codes.dart';
import 'package:runmares/features/auth/domain/auth_failure.dart';

void main() {
  test('maps wrong credentials codes to a single failure', () {
    for (final code in [
      'user-not-found',
      'wrong-password',
      'invalid-credential',
    ]) {
      expect(authFailureFromFirebaseCode(code), AuthFailure.wrongCredentials);
    }
  });

  test('maps the other known codes', () {
    expect(
      authFailureFromFirebaseCode('invalid-email'),
      AuthFailure.invalidEmail,
    );
    expect(
      authFailureFromFirebaseCode('email-already-in-use'),
      AuthFailure.emailAlreadyInUse,
    );
    expect(
      authFailureFromFirebaseCode('weak-password'),
      AuthFailure.weakPassword,
    );
    expect(
      authFailureFromFirebaseCode('network-request-failed'),
      AuthFailure.network,
    );
    expect(
      authFailureFromFirebaseCode('too-many-requests'),
      AuthFailure.tooManyRequests,
    );
  });

  test('falls back to unknown', () {
    expect(authFailureFromFirebaseCode('something-new'), AuthFailure.unknown);
  });
}
