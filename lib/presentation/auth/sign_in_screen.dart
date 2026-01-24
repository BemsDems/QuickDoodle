import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_doodle/core/config/app_colors.dart';
import 'package:quick_doodle/core/config/app_text_styles.dart';
import 'package:quick_doodle/core/config/navigation/app_routes.dart';
import 'package:quick_doodle/presentation/auth/components/gradient_blur_outlined_text.dart';
import 'package:quick_doodle/presentation/auth/controller/auth_controller.dart';
import 'package:quick_doodle/shared/components/custom_button.dart';
import 'package:quick_doodle/shared/components/custom_scaffold.dart';
import 'package:quick_doodle/shared/components/custom_text_field.dart';
import 'package:quick_doodle/shared/validators/auth_validators.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  final _formKey = GlobalKey<FormState>();

  String? _backendErrorText;

  bool _allFilled = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    void listener() => _recalcFilled();

    _emailController.addListener(listener);
    _passwordController.addListener(listener);

    _recalcFilled();
  }

  void _recalcFilled() {
    final filled =
        _emailController.text.trim().isNotEmpty &&
        _passwordController.text.isNotEmpty;

    if (filled != _allFilled) {
      setState(() => _allFilled = filled);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;
    final canSubmit = _allFilled && !isLoading;
    ref.listen(authControllerProvider, (prev, next) {
      final error = next.whenOrNull(error: (e, _) => e)?.toString();
      if (error != _backendErrorText) {
        setState(() => _backendErrorText = error);
      }
    });

    return CustomScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 50),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GradientBlurOutlinedText(
                          text: 'Вход',
                          style: AppTextStyles.pressStartRegular20,
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromRGBO(137, 36, 231, 1),
                              Color.fromRGBO(106, 70, 249, 1),
                            ],
                          ),
                          strokeWidth: 2,
                          glowSigma: 6,
                          glowStrokeExtra: 2,
                          fillColor: AppColors.white,
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: CustomTextField(
                            nameTextField: 'e-mail',
                            hintText: 'Введите электронную почту',
                            textEditingController: _emailController,
                            onChanged: (_) =>
                                setState(() => _backendErrorText = null),
                            validator: AuthValidators.email,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: CustomTextField(
                            nameTextField: 'Пароль',
                            hintText: 'Введите пароль',
                            obscureText: true,
                            textEditingController: _passwordController,
                            onChanged: (_) =>
                                setState(() => _backendErrorText = null),
                            validator: AuthValidators.password,
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (_backendErrorText != null)
                          Center(
                            child: Text(
                              _backendErrorText!,
                              style: AppTextStyles.robotoRegular15.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            CustomButton(
              title: isLoading ? 'Вход...' : 'Войти',
              enabled: canSubmit,
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  final user = await ref
                      .read(authControllerProvider.notifier)
                      .signIn(
                        email: _emailController.text.trim(),
                        password: _passwordController.text,
                      );

                  if (user != null && context.mounted) {}
                }
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              title: 'Регистрация',
              textColor: AppColors.bg,
              backgroundColor: AppColors.white,
              enabled: !isLoading,
              onPressed: () => Navigator.pushNamed(context, AppRoutes.signUp),
            ),
          ],
        ),
      ),
    );
  }
}
