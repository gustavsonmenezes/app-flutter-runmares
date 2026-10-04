import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runmares/features/auth/data/auth_repository_provider.dart';
import 'package:runmares/features/auth/domain/auth_user.dart';
import 'package:runmares/features/auth/presentation/providers/auth_state_provider.dart';

final currentUserProvider = Provider<AuthUser?>((ref) {
  // Observar o fluxo reavalia este provider a cada login ou logout.
  ref.watch(authStateProvider);
  return ref.watch(authRepositoryProvider).currentUser;
});
