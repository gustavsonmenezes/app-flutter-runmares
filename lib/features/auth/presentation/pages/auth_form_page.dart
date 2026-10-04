import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:runmares/app/router/app_routes.dart';
import 'package:runmares/core/constants/app_spacing.dart';
import 'package:runmares/features/auth/data/auth_repository_provider.dart';
import 'package:runmares/features/auth/domain/auth_failure.dart';
import 'package:runmares/features/auth/presentation/auth_failure_message.dart';
import 'package:runmares/features/auth/presentation/auth_form_mode.dart';
import 'package:runmares/features/auth/presentation/auth_validators.dart';

class AuthFormPage extends ConsumerStatefulWidget {
  const AuthFormPage({required this.mode, super.key});

  final AuthFormMode mode;

  @override
  ConsumerState<AuthFormPage> createState() => _AuthFormPageState();
}

class _AuthFormPageState extends ConsumerState<AuthFormPage> {
  static const double _formMaxWidth = 420;
  static const double _loadingSize = 20;
  static const double _loadingStrokeWidth = 2;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmationController = TextEditingController();

  bool _obscurePassword = true;
  bool _isSubmitting = false;
  AuthFailure? _failure;

  bool get _isSignUp => widget.mode == AuthFormMode.signUp;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final failure = _failure;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _formMaxWidth),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _isSignUp ? 'Criar conta' : 'RunMares',
                      textAlign: TextAlign.center,
                      style: textTheme.displaySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.itemGap),
                    Text(
                      _isSignUp
                          ? 'Crie sua conta para começar'
                          : 'Registre cada passo, mesmo sem internet',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.screenPadding),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      autocorrect: false,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        border: OutlineInputBorder(),
                      ),
                      validator: AuthValidators.email,
                    ),
                    const SizedBox(height: AppSpacing.itemGap),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: _isSignUp
                          ? TextInputAction.next
                          : TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      onFieldSubmitted: _isSignUp ? null : (_) => _submit(),
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          tooltip: _obscurePassword
                              ? 'Mostrar senha'
                              : 'Ocultar senha',
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                      ),
                      validator: _isSignUp
                          ? AuthValidators.newPassword
                          : AuthValidators.signInPassword,
                    ),
                    if (_isSignUp) ...[
                      const SizedBox(height: AppSpacing.itemGap),
                      TextFormField(
                        controller: _confirmationController,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submit(),
                        decoration: const InputDecoration(
                          labelText: 'Confirmar senha',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            AuthValidators.passwordConfirmation(
                              value,
                              _passwordController.text,
                            ),
                      ),
                    ],
                    if (failure != null) ...[
                      const SizedBox(height: AppSpacing.itemGap),
                      Text(
                        failure.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.screenPadding),
                    FilledButton(
                      onPressed: _isSubmitting ? null : _submit,
                      child: _isSubmitting
                          ? const SizedBox(
                              width: _loadingSize,
                              height: _loadingSize,
                              child: CircularProgressIndicator(
                                strokeWidth: _loadingStrokeWidth,
                              ),
                            )
                          : Text(_isSignUp ? 'Criar conta' : 'Entrar'),
                    ),
                    const SizedBox(height: AppSpacing.itemGap),
                    TextButton(
                      onPressed: _isSubmitting
                          ? null
                          : () => context.go(
                              _isSignUp ? AppRoutes.login : AppRoutes.register,
                            ),
                      child: Text(
                        _isSignUp
                            ? 'Já tenho uma conta'
                            : 'Ainda não tem conta? Criar conta',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _failure = null;
    });

    final repository = ref.read(authRepositoryProvider);
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    AuthFailure? failure;
    try {
      if (_isSignUp) {
        await repository.signUp(email: email, password: password);
      } else {
        await repository.signIn(email: email, password: password);
      }
    } on AuthException catch (error) {
      failure = error.failure;
    }

    // Em caso de sucesso o roteador já leva o usuário para o Início.
    if (!mounted) return;
    setState(() {
      _isSubmitting = false;
      _failure = failure;
    });
  }
}
