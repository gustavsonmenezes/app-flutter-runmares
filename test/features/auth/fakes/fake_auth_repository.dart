import 'dart:async';

import 'package:runmares/features/auth/domain/auth_failure.dart';
import 'package:runmares/features/auth/domain/auth_repository.dart';
import 'package:runmares/features/auth/domain/auth_user.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({AuthUser? initialUser}) : _user = initialUser;

  final StreamController<AuthUser?> _changes =
      StreamController<AuthUser?>.broadcast();
  AuthUser? _user;

  AuthFailure? failure;

  @override
  AuthUser? get currentUser => _user;

  @override
  Stream<AuthUser?> authStateChanges() => _changes.stream;

  @override
  Future<void> signIn({required String email, required String password}) async {
    _authenticate(email);
  }

  @override
  Future<void> signUp({required String email, required String password}) async {
    _authenticate(email);
  }

  @override
  Future<void> signOut() async {
    _user = null;
    _changes.add(null);
  }

  void dispose() => _changes.close();

  void _authenticate(String email) {
    final error = failure;
    if (error != null) throw AuthException(error);

    _user = AuthUser(uid: 'user-1', email: email);
    _changes.add(_user);
  }
}
