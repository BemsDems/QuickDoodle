import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quick_doodle/shared/components/custom_button.dart';
import 'package:quick_doodle/shared/components/custom_scaffold.dart';
import 'package:quick_doodle/shared/components/custom_text_field.dart';
import 'package:quick_doodle/presentation/auth/components/gradient_blur_outlined_text.dart';
import 'package:quick_doodle/core/config/app_colors.dart';
import 'package:quick_doodle/core/config/app_text_styles.dart';
import 'package:quick_doodle/shared/validators/auth_validators.dart';
import 'package:quick_doodle/presentation/auth/controller/auth_controller.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  final _formKey = GlobalKey<FormState>();

  String? _backendErrorText;

  bool _allFilled = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    void listener() => _recalcFilled();
    _nameController.addListener(listener);
    _emailController.addListener(listener);
    _passwordController.addListener(listener);
    _confirmPasswordController.addListener(listener);

    _recalcFilled();
  }

  void _recalcFilled() {
    final filled =
        _nameController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty;

    if (filled != _allFilled) {
      setState(() => _allFilled = filled);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: SvgPicture.asset('assets/icons/arrow_back.svg'),
                  onPressed: () => Navigator.pop(context),
                  style: const ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GradientBlurOutlinedText(
                        text: 'Регистрация',
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
                          nameTextField: 'Имя',
                          hintText: 'Введите ваше имя',
                          textEditingController: _nameController,
                          onChanged: (_) =>
                              setState(() => _backendErrorText = null),
                          validator: (value) => AuthValidators.requiredField(
                            value,
                            'Введите имя',
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: CustomTextField(
                          nameTextField: 'e-mail',
                          hintText: 'Ваша электронная почта',
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
                          hintText: '8-16 символов',
                          obscureText: true,
                          textEditingController: _passwordController,
                          onChanged: (_) =>
                              setState(() => _backendErrorText = null),
                          validator: AuthValidators.password,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: CustomTextField(
                          nameTextField: 'Подтверждение пароля',
                          hintText: '8-16 символов',
                          obscureText: true,
                          textEditingController: _confirmPasswordController,
                          onChanged: (_) =>
                              setState(() => _backendErrorText = null),
                          validator: (value) => AuthValidators.confirmPassword(
                            value,
                            _passwordController.text,
                          ),
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
              CustomButton(
                title: isLoading ? 'Регистрация...' : 'Зарегистрироваться',
                enabled: canSubmit,
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final user = await ref
                        .read(authControllerProvider.notifier)
                        .signUp(
                          name: _nameController.text,
                          email: _emailController.text.trim(),
                          password: _passwordController.text,
                        );

                    if (user != null && context.mounted) {}
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
