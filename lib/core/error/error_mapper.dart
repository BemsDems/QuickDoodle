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
      if (error.plugin == 'cloud_firestore') {
        return FirestoreFailure(
          message: _mapFirestoreMessage(error),
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
        return 'Слишком простой пароль (минимум 6 символов)';
      case 'operation-not-allowed':
        return 'Операция запрещена';
      case 'invalid-credential':
        return 'Неверные учётные данные';
      default:
        return error.message ?? 'Ошибка авторизации';
    }
  }

  String _mapFirestoreMessage(FirebaseException error) {
    switch (error.code) {
      case 'permission-denied':
        return 'Нет прав для выполнения операции (проверь Firestore Rules)';
      case 'unauthenticated':
        return 'Требуется авторизация';
      case 'not-found':
        return 'Документ не найден';
      case 'already-exists':
        return 'Документ уже существует';
      case 'failed-precondition':
        return 'Операция невозможна в текущем состоянии';
      case 'invalid-argument':
        return 'Некорректные данные запроса';
      case 'resource-exhausted':
        return 'Превышены лимиты/квоты Firestore';
      case 'deadline-exceeded':
        return 'Превышено время ожидания';
      case 'unavailable':
        return 'Сервис Firestore временно недоступен';
      case 'cancelled':
        return 'Операция отменена';
      case 'aborted':
        return 'Операция прервана (повтори попытку)';
      case 'internal':
        return 'Внутренняя ошибка Firestore';
      case 'data-loss':
        return 'Потеря/повреждение данных';
      default:
        return error.message ?? 'Ошибка Firestore';
    }
  }
}
