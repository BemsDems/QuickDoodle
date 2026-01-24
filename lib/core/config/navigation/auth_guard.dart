import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_doodle/presentation/auth/sign_in_screen.dart';
import 'package:quick_doodle/presentation/gallery/gallery_screen.dart';
import 'package:quick_doodle/shared/providers/user/auth_user_provider.dart';

class AuthGuard extends ConsumerWidget {
  const AuthGuard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authUserProvider);

    return auth.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SignInScreen(),
      data: (user) =>
          user == null ? const SignInScreen() : const GalleryScreen(),
    );
  }
}
