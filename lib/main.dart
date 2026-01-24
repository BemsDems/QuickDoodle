import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_doodle/core/config/firebase_options.dart';
import 'package:quick_doodle/core/config/navigation/app_routes.dart';
import 'package:quick_doodle/core/services/notification_service.dart';
import 'package:quick_doodle/models/doodle/doodle_model.dart';
import 'package:quick_doodle/presentation/auth/sign_in_screen.dart';
import 'package:quick_doodle/presentation/auth/sign_up_screen.dart';
import 'package:quick_doodle/presentation/doodle/doodle_screen.dart';
import 'package:quick_doodle/presentation/gallery/gallery_screen.dart';
import 'package:quick_doodle/shared/observer/auth_navigator_observer.dart';

Future<void> main() async {
  final b = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: b);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.initialize();
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Quick Doodle',
      initialRoute: AppRoutes.signIn,
      navigatorObservers: [AuthNavigatorObserver(ref)],
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
    );
  }
}
