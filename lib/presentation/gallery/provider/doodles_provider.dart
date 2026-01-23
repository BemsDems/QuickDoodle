import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_doodle/core/di/providers.dart';
import 'package:quick_doodle/models/doodle/doodle_model.dart';
import 'package:quick_doodle/shared/providers/user/user_provider.dart';

final doodlesProvider = FutureProvider.autoDispose<List<DoodleModel>>((
  ref,
) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return <DoodleModel>[];

  final repository = ref.watch(doodleRepositoryProvider);
  final respose = await repository.getDoodles(user: user);

  return respose.fold((failure) => throw failure, (items) => items);
});
