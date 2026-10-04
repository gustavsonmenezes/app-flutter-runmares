enum AuthFailure {
  invalidEmail,
  wrongCredentials,
  emailAlreadyInUse,
  weakPassword,
  network,
  tooManyRequests,
  unknown,
}

class AuthException implements Exception {
  const AuthException(this.failure);

  final AuthFailure failure;
}
