import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_doodle/core/config/navigation/app_routes.dart';
import 'package:quick_doodle/presentation/auth/sign_in_screen.dart';
import 'package:quick_doodle/presentation/gallery/gallery_screen.dart';
import 'package:quick_doodle/shared/providers/user/auth_user_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _redirected = false;

  double _changeSplashImageSize(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final shortestScreenSide = math.min(screenSize.width, screenSize.height);

    return (shortestScreenSide * 0.60).clamp(180.0, 260.0);
  }

  @override
  Widget build(BuildContext context) {
    final logoSize = _changeSplashImageSize(context);

    ref.listen(authUserProvider, (prev, next) {
      if (_redirected) return;

      next.whenOrNull(
        data: (user) {
          _redirected = true;

          final route = user == null ? AppRoutes.signIn : AppRoutes.gallery;

          final screen = route == AppRoutes.signIn
              ? SignInScreen()
              : GalleryScreen();

          if (!mounted) return;
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => screen,
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: Color(0xFF0F0F12),
      body: Center(
        child: Image.asset(
          'assets/images/splash.png',
          width: logoSize,
          height: logoSize,
        ),
      ),
    );
  }
}
