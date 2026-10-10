import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:runmares/app/router/app_routes.dart';
import 'package:runmares/app/theme/app_colors.dart';
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

  static bool _hasShownSplash = false;
  bool _showSplashOverlay = !_hasShownSplash;

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
      body: Stack(
        children: [
          SafeArea(
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
                                  _isSignUp
                                      ? AppRoutes.login
                                      : AppRoutes.register,
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
          if (_showSplashOverlay)
            _SplashOverlay(
              onFinish: () {
                if (mounted) {
                  setState(() {
                    _hasShownSplash = true;
                    _showSplashOverlay = false;
                  });
                }
              },
            ),
        ],
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

class _SplashOverlay extends StatefulWidget {
  const _SplashOverlay({required this.onFinish});

  final VoidCallback onFinish;

  @override
  State<_SplashOverlay> createState() => _SplashOverlayState();
}

class _SplashOverlayState extends State<_SplashOverlay> {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        color: AppColors.backgroundDark,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 32,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: const Icon(
                Icons.directions_run_rounded,
                size: 64,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'RunMares',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                    letterSpacing: 1,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'SEU COACH DE CORRIDA',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondaryDark,
                    letterSpacing: 3,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        )
            .animate(onComplete: (_) => widget.onFinish())
            .fadeIn(duration: 400.ms)
            .scale(
              begin: const Offset(0.8, 0.8),
              end: const Offset(1.0, 1.0),
              duration: 500.ms,
              curve: Curves.easeOutBack,
            )
            .then(delay: 1000.ms)
            .fadeOut(duration: 700.ms, curve: Curves.easeInOut)
            .scale(
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.15, 1.15),
              duration: 700.ms,
            ),
      ),
    );
  }
}
