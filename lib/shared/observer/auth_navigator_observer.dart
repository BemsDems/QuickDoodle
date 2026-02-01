import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_doodle/core/config/navigation/app_routes.dart';
import 'package:quick_doodle/models/user/user_model.dart';
import 'package:quick_doodle/shared/providers/user/auth_user_provider.dart';

class AuthNavigatorObserver extends NavigatorObserver {
  final WidgetRef ref;
  String _currentRoute = AppRoutes.splash;

  AuthNavigatorObserver(this.ref) {
    ref.listen<AsyncValue<UserModel?>>(authUserProvider, (prev, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null) return;

          if (_currentRoute == AppRoutes.signIn ||
              _currentRoute == AppRoutes.signUp ||
              _currentRoute == AppRoutes.splash) {
            return;
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigator?.pushNamedAndRemoveUntil(AppRoutes.signIn, (_) => false);
          });
        },
      );
    });
  }

  void _setCurrentRoute(Route<dynamic>? route) {
    final name = route?.settings.name;
    if (name != null && name.isNotEmpty) _currentRoute = name;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _setCurrentRoute(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _setCurrentRoute(newRoute ?? oldRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _setCurrentRoute(previousRoute);
  }
}
