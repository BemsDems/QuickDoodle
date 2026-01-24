import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_doodle/core/error/app_failure.dart';

class ErrorMapper {
  const ErrorMapper();

  AppFailure map(Object error, StackTrace stackTrace) {
    if (error is FirebaseAuthException) {
      return AuthFailure(message: _mapAuthMessage(error), code: error.code);
    }

    if (error is FirebaseException) {
      if (error.plugin == 'firebase_database') {
        return RealtimeDatabaseFailure(
          message: _mapRealtimeMessage(error),
          code: error.code,
        );
      }
    }

    if (error is SocketException) {
      return const NoInternetFailure();
    }

    return UnknownFailure(message: 'Неизвестная ошибка: ${error.toString()}');
  }

  String _mapAuthMessage(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'Некорректный email';
      case 'user-disabled':
        return 'Пользователь отключён';
      case 'user-not-found':
        return 'Пользователь не найден';
      case 'wrong-password':
        return 'Неверный пароль';
      case 'email-already-in-use':
        return 'Email уже используется';
      case 'weak-password':
        return 'Слишком простой пароль (минимум 8 символов)';
      case 'operation-not-allowed':
        return 'Операция запрещена';
      case 'invalid-credential':
        return 'Неверные учётные данные';
      default:
        return error.message ?? 'Ошибка авторизации';
    }
  }

  String _mapRealtimeMessage(FirebaseException error) {
    switch (error.code) {
      case 'permission-denied':
        return 'Нет прав доступа к базе данных';
      case 'data-exists':
        return 'Данные уже существуют';
      case 'invalid-token':
        return 'Неверный токен авторизации';
      case 'max-retries-exceeded':
        return 'Превышено максимальное количество попыток';
      case 'network-error':
        return 'Ошибка сети';
      case 'offline':
        return 'Нет соединения с интернетом';
      case 'requires-authentication':
        return 'Требуется авторизация';
      case 'unauthorized':
        return 'Не авторизован';
      case 'unavailable':
        return 'Сервис временно недоступен';
      default:
        return error.message ?? 'Ошибка Realtime Database';
    }
  }
}
