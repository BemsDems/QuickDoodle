import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_doodle/models/user/user_model.dart';
import 'package:quick_doodle/shared/providers/user/auth_user_provider.dart';

final currentUserProvider = Provider<UserModel?>((ref) {
  final authState = ref.watch(authUserProvider);
  return authState.whenOrNull(data: (user) => user);
});
