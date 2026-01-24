abstract class AppFailure {
  const AppFailure({required this.message, this.code});

  final String message;
  final String? code;

  @override
  String toString() => 'Failure(code: $code, message: $message)';
}

class NoInternetFailure extends AppFailure {
  const NoInternetFailure() : super(message: 'Нет подключения к интернету');
}

class AuthFailure extends AppFailure {
  const AuthFailure({required super.message, super.code});
}

class RealtimeDatabaseFailure extends AppFailure {
  const RealtimeDatabaseFailure({required super.message, super.code});
}

class UnknownFailure extends AppFailure {
  const UnknownFailure({required super.message, super.code});
}
