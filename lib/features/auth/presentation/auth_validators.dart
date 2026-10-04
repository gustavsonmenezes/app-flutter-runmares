abstract final class AuthValidators {
  static const int minPasswordLength = 6;

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Informe seu e-mail.';
    if (!_emailPattern.hasMatch(text)) return 'Informe um e-mail válido.';
    return null;
  }

  static String? signInPassword(String? value) {
    if (value == null || value.isEmpty) return 'Informe sua senha.';
    return null;
  }

  static String? newPassword(String? value) {
    if (value == null || value.isEmpty) return 'Informe uma senha.';
    if (value.length < minPasswordLength) {
      return 'A senha deve ter pelo menos $minPasswordLength caracteres.';
    }
    return null;
  }

  static String? passwordConfirmation(String? value, String password) {
    if (value != password) return 'As senhas não coincidem.';
    return null;
  }
}
