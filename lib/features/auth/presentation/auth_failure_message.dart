import 'package:runmares/features/auth/domain/auth_failure.dart';

extension AuthFailureMessage on AuthFailure {
  String get message {
    return switch (this) {
      AuthFailure.invalidEmail => 'O e-mail informado é inválido.',
      AuthFailure.wrongCredentials => 'E-mail ou senha incorretos.',
      AuthFailure.emailAlreadyInUse => 'Já existe uma conta com este e-mail.',
      AuthFailure.weakPassword =>
        'A senha é muito fraca. Use pelo menos 6 caracteres.',
      AuthFailure.network => 'Sem conexão com a internet. Tente novamente.',
      AuthFailure.tooManyRequests =>
        'Muitas tentativas. Aguarde um pouco e tente de novo.',
      AuthFailure.unknown => 'Não foi possível concluir. Tente novamente.',
    };
  }
}
