import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_doodle/core/di/providers.dart';
import 'package:quick_doodle/models/user/user_model.dart';

final authUserProvider = StreamProvider<UserModel?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);

  return auth.userChanges().map((user) {
    if (user == null) return null;
    return UserModel.fromFirebaseUser(user);
  });
});


