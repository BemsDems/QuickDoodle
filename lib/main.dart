import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_doodle/core/config/firebase_options.dart';
import 'package:quick_doodle/core/config/navigation/app_routes.dart';
import 'package:quick_doodle/core/config/navigation/auth_guard.dart';
import 'package:quick_doodle/core/services/notification_service.dart';
import 'package:quick_doodle/models/doodle/doodle_model.dart';
import 'package:quick_doodle/presentation/auth/sign_in_screen.dart';
import 'package:quick_doodle/presentation/auth/sign_up_screen.dart';
import 'package:quick_doodle/presentation/doodle/doodle_screen.dart';
import 'package:quick_doodle/presentation/gallery/gallery_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.initialize();
  FirebaseDatabase.instance.setPersistenceEnabled(true);
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
        AppRoutes.gallery: (_) => const GalleryScreen(),
        AppRoutes.doodle: (context) {
          final doodle =
              ModalRoute.of(context)?.settings.arguments as DoodleModel?;
          return DoodleScreen(doodle: doodle);
        },
      },
      home: AuthGuard(),
    );
  }
}
