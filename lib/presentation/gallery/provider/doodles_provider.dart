import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_doodle/core/di/providers.dart';
import 'package:quick_doodle/models/doodle/doodle_model.dart';
import 'package:quick_doodle/shared/providers/user/user_provider.dart';

final doodlesProvider = StreamProvider.autoDispose<List<DoodleModel>>((ref) {
  final user = ref.watch(currentUserProvider);

  if (user == null) {
    return Stream.value(<DoodleModel>[]);
  }

  final repo = ref.watch(doodleRepositoryProvider);
  return repo.watchDoodles(userUid: user.uid).map((result) {
    return result.fold(
      (failure) => throw failure.message,
      (doodles) => doodles,
    );
  });
});
