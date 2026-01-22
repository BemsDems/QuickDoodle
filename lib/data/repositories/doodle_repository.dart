import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:quick_doodle/core/error/app_failure.dart';
import 'package:quick_doodle/core/network/safe_caller.dart';
import 'package:quick_doodle/models/doodle/doodle_model.dart';
import 'package:quick_doodle/models/user/user_model.dart';

class DoodleRepository {
  DoodleRepository({
    required FirebaseFirestore firestore,
    required SafeCaller safeCaller,
  }) : _firestore = firestore,
       _safeCaller = safeCaller;

  final FirebaseFirestore _firestore;
  final SafeCaller _safeCaller;

  CollectionReference<Map<String, dynamic>> _collection(String uid) =>
      _firestore.collection('users').doc(uid).collection('doodles');

  Future<Either<AppFailure, List<DoodleModel>>> getDoodles({
    required UserModel user,
  }) {
    return _safeCaller.call(() async {
      final snapshot = await _collection(user.uid).get();
      return snapshot.docs
          .map(
            (document) =>
                DoodleModel.fromJson({...document.data(), 'id': document.id}),
          )
          .toList();
    });
  }

  Future<Either<AppFailure, DoodleModel?>> getDoodle({
    required UserModel user,
    required String doodleId,
  }) {
    return _safeCaller.call(() async {
      final document = await _collection(user.uid).doc(doodleId).get();
      return DoodleModel.fromJson({...document.data()!, 'id': document.id});
    });
  }

  Future<Either<AppFailure, String>> createDoodle({
    required UserModel user,
    required String title,
    required String previewBase64,
    required String fullImageBase64,
  }) {
    return _safeCaller.call(() async {
      final documentReference = _collection(user.uid).doc();

      final doodle = DoodleModel(
        id: documentReference.id,
        title: title,
        authorId: user.uid,
        authorName: user.name,
        previewBase64: previewBase64,
        fullImageBase64: fullImageBase64,
      );

      await documentReference.set(doodle.toJson());
      return documentReference.id;
    });
  }

  Future<Either<AppFailure, void>> updateDoodle({
    required UserModel user,
    required DoodleModel doodle,
  }) => _safeCaller.call(
    () async =>
        await _collection(user.uid).doc(doodle.id).update(doodle.toJson()),
  );

  Future<Either<AppFailure, void>> deleteDoodle({
    required UserModel user,
    required String doodleId,
  }) => _safeCaller.call(
    () async => await _collection(user.uid).doc(doodleId).delete(),
  );
}
