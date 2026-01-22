import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:quick_doodle/core/error/app_failure.dart';
import 'package:quick_doodle/core/network/safe_caller.dart';
import 'package:quick_doodle/models/user/user_model.dart';

class AuthRepository {
  AuthRepository({
    required FirebaseAuth firebaseAuth,
    required SafeCaller safeCaller,
  }) : _firebaseAuth = firebaseAuth,
       _safeCaller = safeCaller;

  final FirebaseAuth _firebaseAuth;
  final SafeCaller _safeCaller;

  Future<Either<AppFailure, UserModel>> signUp({
    required String email,
    required String password,
    required String name,
  }) {
    return _safeCaller.call(() async {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw const UnknownFailure(
          message: 'Не удалось получить пользователя после signUp',
        );
      }

      await user.updateDisplayName(name);
      await user.reload();

      return UserModel.fromFirebaseUser(user);
    });
  }

  Future<Either<AppFailure, UserModel>> signIn({
    required String email,
    required String password,
  }) {
    return _safeCaller.call(() async {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw const UnknownFailure(
          message: 'Не удалось получить пользователя после signIn',
        );
      }

      return UserModel.fromFirebaseUser(user);
    });
  }

  Future<Either<AppFailure, void>> signOut() =>
      _safeCaller.call(() async => await _firebaseAuth.signOut());
}
