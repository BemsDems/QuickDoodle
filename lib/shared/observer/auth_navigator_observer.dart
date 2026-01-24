import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_doodle/core/config/navigation/app_routes.dart';
import 'package:quick_doodle/models/user/user_model.dart';
import 'package:quick_doodle/presentation/gallery/gallery_screen.dart';
import 'package:quick_doodle/shared/providers/user/auth_user_provider.dart';

class AuthNavigatorObserver extends NavigatorObserver {
  final WidgetRef ref;

  AuthNavigatorObserver(this.ref) {
    ref.listen<AsyncValue<UserModel?>>(authUserProvider, (prev, next) {
      next.whenData((user) {
        if (user == null) {
          final currentRouteName =
              navigator?.widget.initialRoute ??
              navigator?.widget.pages.last.name ??
              '';

          if (currentRouteName.isNotEmpty &&
              !currentRouteName.contains(AppRoutes.signIn) &&
              !currentRouteName.contains(AppRoutes.signUp)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              navigator?.pushReplacementNamed(AppRoutes.signIn);
            });
          }
        } else {
          navigator?.pushAndRemoveUntil(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const GalleryScreen(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
            (route) => false,
          );
        }
      });
    });
  }

  void _redirectIfUnauthorized(Route<dynamic>? route) {
    final authAsync = ref.read(authUserProvider);

    authAsync.whenOrNull(
      data: (user) {
        final routeName = route?.settings.name ?? '';

        if (user == null &&
            !routeName.contains(AppRoutes.signIn) &&
            !routeName.contains(AppRoutes.signUp)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            route?.navigator?.pushReplacementNamed(AppRoutes.signIn);
          });
        }
      },
    );
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _redirectIfUnauthorized(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _redirectIfUnauthorized(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _redirectIfUnauthorized(newRoute ?? oldRoute);
  }
}
