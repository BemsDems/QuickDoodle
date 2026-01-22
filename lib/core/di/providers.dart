import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:quick_doodle/core/error/error_mapper.dart';
import 'package:quick_doodle/core/network/network_info.dart';
import 'package:quick_doodle/core/network/safe_caller.dart';
import 'package:quick_doodle/data/repositories/auth_repository.dart';
import 'package:quick_doodle/data/repositories/doodle_repository.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

final firestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

final internetConnectionProvider = Provider<InternetConnection>(
  (ref) => InternetConnection(),
);

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  final connection = ref.watch(internetConnectionProvider);
  return NetworkInfo(connection);
});

final errorMapperProvider = Provider<ErrorMapper>((ref) => const ErrorMapper());

final safeCallerProvider = Provider<SafeCaller>((ref) {
  return SafeCaller(
    ref.watch(networkInfoProvider),
    ref.watch(errorMapperProvider),
  );
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    safeCaller: ref.watch(safeCallerProvider),
  );
});

final doodleRepositoryProvider = Provider<DoodleRepository>((ref) {
  return DoodleRepository(
    firestore: ref.watch(firestoreProvider),
    safeCaller: ref.watch(safeCallerProvider),
  );
});
