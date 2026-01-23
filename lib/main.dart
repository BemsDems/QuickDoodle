import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_doodle/core/config/firebase_options.dart';
import 'package:quick_doodle/core/config/navigation/app_routes.dart';
import 'package:quick_doodle/core/config/navigation/auth_guard.dart';
import 'package:quick_doodle/presentation/auth/signIn_screen.dart';
import 'package:quick_doodle/presentation/auth/signUp_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Doodle',
      routes: {
        AppRoutes.signIn: (_) => const SignInScreen(),
        AppRoutes.signUp: (_) => const SignUpScreen(),
      },
      home: AuthGuard(),
    );
  }
}
