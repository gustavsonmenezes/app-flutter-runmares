import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runmares/features/auth/data/firebase_auth_repository.dart';
import 'package:runmares/features/auth/domain/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => FirebaseAuthRepository(),
);
