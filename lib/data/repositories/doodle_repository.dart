import 'package:firebase_database/firebase_database.dart';
import 'package:fpdart/fpdart.dart';
import 'package:quick_doodle/core/error/app_failure.dart';
import 'package:quick_doodle/core/network/safe_caller.dart';
import 'package:quick_doodle/models/doodle/doodle_model.dart';
import 'package:quick_doodle/models/user/user_model.dart';

class DoodleRepository {
  DoodleRepository({
    required DatabaseReference database,
    required SafeCaller safeCaller,
  }) : _database = database,
       _safeCaller = safeCaller;

  final DatabaseReference _database;
  final SafeCaller _safeCaller;

  DatabaseReference _collection(String uid) =>
      _database.child('users/$uid/doodles');

  Future<Either<AppFailure, List<DoodleModel>>> getDoodles({
    required UserModel user,
  }) {
    return _safeCaller.call(() async {
      final snapshot = await _collection(user.uid).get();

      if (!snapshot.exists) return <DoodleModel>[];

      return snapshot.children
          .map((childSnapshot) {
            final data = Map<String, dynamic>.from(childSnapshot.value as Map);
            data['id'] = childSnapshot.key ?? '';
            return DoodleModel.fromJson(data);
          })
          .where((doodle) => doodle.id.isNotEmpty)
          .toList();
    });
  }

  Stream<Either<AppFailure, List<DoodleModel>>> watchDoodles({
    required String userUid,
  }) {
    return _safeCaller.stream(() async* {
      try {
        await for (final event in _collection(userUid).onValue) {
          final snapshot = event.snapshot;
          if (!snapshot.exists) {
            yield right(<DoodleModel>[]);
            continue;
          }

          final doodles = snapshot.children
              .map((child) {
                final data = Map<String, dynamic>.from(child.value as Map);
                data['id'] = child.key ?? '';
                return DoodleModel.fromJson(data);
              })
              .where((d) => d.id.isNotEmpty)
              .toList();

          yield right(doodles);
        }
      } catch (e) {
        yield left(UnknownFailure(message: e.toString()));
      }
    });
  }

  Future<Either<AppFailure, String>> createDoodle({
    required UserModel user,
    required String title,
    required String fullImageBase64,
  }) {
    return _safeCaller.call(() async {
      final ref = _collection(user.uid).push();

      final doodleData = {
        'id': ref.key!,
        'title': title,
        'authorId': user.uid,
        'authorName': user.name,
        'createdAt': ServerValue.timestamp,
        'fullImageBase64': fullImageBase64,
      };

      await ref.set(doodleData);
      return ref.key!;
    });
  }

  Future<Either<AppFailure, void>> updateDoodle({
    required String userUid,
    required DoodleModel doodle,
  }) {
    return _safeCaller.call(() async {
      await _collection(userUid).child(doodle.id).update(doodle.toJson());
    });
  }

  Future<Either<AppFailure, void>> deleteDoodle({
    required UserModel user,
    required String doodleId,
  }) {
    return _safeCaller.call(() async {
      await _collection(user.uid).child(doodleId).remove();
    });
  }
}
