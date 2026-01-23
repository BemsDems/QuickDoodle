class AuthValidators {
  static String? requiredField(String? value, String message) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  static String? email(String? value) {
    final required = requiredField(value, 'Введите e-mail');
    if (required != null) return required;

    final trimValue = value!.trim();
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(trimValue)) return 'Некорректный e-mail';
    return null;
  }

  static String? password(String? value) {
    final required = requiredField(value, 'Введите пароль');
    if (required != null) return required;

    if (value!.length < 8) return 'Минимум 8 символов';
    if (value.length > 16) return 'Максимум 16 символов';
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    final required = requiredField(value, 'Подтвердите пароль');
    if (required != null) return required;

    if (value != password) return 'Пароли не совпадают';
    return null;
  }
}
