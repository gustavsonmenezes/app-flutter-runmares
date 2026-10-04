import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/features/auth/presentation/auth_validators.dart';

void main() {
  group('email', () {
    test('requires a value', () {
      expect(AuthValidators.email(''), 'Informe seu e-mail.');
      expect(AuthValidators.email(null), 'Informe seu e-mail.');
    });

    test('rejects an invalid address', () {
      expect(AuthValidators.email('ana@'), 'Informe um e-mail válido.');
      expect(
        AuthValidators.email('ana.exemplo.com'),
        'Informe um e-mail válido.',
      );
    });

    test('accepts a valid address, ignoring surrounding spaces', () {
      expect(AuthValidators.email(' ana@exemplo.com '), isNull);
    });
  });

  group('passwords', () {
    test('sign in only requires a value', () {
      expect(AuthValidators.signInPassword(''), 'Informe sua senha.');
      expect(AuthValidators.signInPassword('123'), isNull);
    });

    test('a new password needs at least 6 characters', () {
      expect(AuthValidators.newPassword(''), 'Informe uma senha.');
      expect(
        AuthValidators.newPassword('12345'),
        'A senha deve ter pelo menos 6 caracteres.',
      );
      expect(AuthValidators.newPassword('123456'), isNull);
    });

    test('the confirmation must match', () {
      expect(
        AuthValidators.passwordConfirmation('abc', 'abcdef'),
        'As senhas não coincidem.',
      );
      expect(AuthValidators.passwordConfirmation('abcdef', 'abcdef'), isNull);
    });
  });
}
