import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:quick_doodle/core/di/providers.dart';
import 'package:quick_doodle/models/user/user_model.dart';

final authControllerProvider =
    StateNotifierProvider.autoDispose<AuthController, AsyncValue<void>>((ref) {
      return AuthController(ref);
    });

class AuthController extends StateNotifier<AsyncValue<void>> {
  AuthController(this.ref) : super(const AsyncData(null));

  final Ref ref;

  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    final repo = ref.read(authRepositoryProvider);
    final res = await repo.signIn(email: email, password: password);

    return res.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
        return null;
      },
      (user) {
        state = const AsyncData(null);
        return user;
      },
    );
  }

  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    state = const AsyncLoading();

    final repo = ref.read(authRepositoryProvider);
    final res = await repo.signUp(email: email, password: password, name: name);

    return res.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
        return null;
      },
      (user) {
        state = const AsyncData(null);
        return user;
      },
    );
  }

  Future<void> signOut() async {
    state = const AsyncLoading();

    final repo = ref.read(authRepositoryProvider);
    final res = await repo.signOut();

    res.fold(
      (failure) => state = AsyncError(failure.message, StackTrace.current),
      (_) => state = const AsyncData(null),
    );
  }
}
