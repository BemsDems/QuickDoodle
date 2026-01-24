import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quick_doodle/core/di/providers.dart';
import 'package:quick_doodle/core/error/app_failure.dart';
import 'package:quick_doodle/core/services/notification_service.dart';
import 'package:quick_doodle/models/doodle/doodle_model.dart';
import 'package:quick_doodle/models/user/user_model.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:share_plus/share_plus.dart';

final doodleControllerProvider =
    StateNotifierProvider.autoDispose<DoodleController, AsyncValue<void>>((
      ref,
    ) {
      return DoodleController(ref);
    });

class DoodleController extends StateNotifier<AsyncValue<void>> {
  DoodleController(this.ref) : super(AsyncData(null));

  final Ref ref;

  Future<void> shareDoodle(DrawingController drawingController) async {
    state = const AsyncLoading();

    try {
      final bytes = await _exportPng(drawingController);
      if (bytes == null) {
        state = const AsyncError(
          'Не удалось экспортировать изображение',
          StackTrace.empty,
        );
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${tempDir.path}/doodle_$timestamp.png';
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      await SharePlus.instance.share(
        ShareParams(
          text: 'Мой рисунок из QuickDoodle!',
          files: [XFile(filePath)],
        ),
      );

      await file.delete();
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      final errorText = error is AppFailure ? error.message : error.toString();
      state = AsyncError('Ошибка шаринга: $errorText', stackTrace);
    }
  }

  Future<bool> saveDoodle({
    required DrawingController drawingController,
    required String title,
    required UserModel user,
  }) async {
    state = const AsyncLoading();

    try {
      final bytes = await _exportPng(drawingController);
      if (bytes == null) {
        state = AsyncError('Экспорт не удался', StackTrace.empty);
        return false;
      }
      await _saveToGallery(bytes);
      final compressedImage = await _compressImage(originalBytes: bytes);

      final repository = ref.read(doodleRepositoryProvider);
      final result = await repository.createDoodle(
        user: user,
        title: title,
        fullImageBase64: compressedImage,
      );

      return result.fold(
        (failure) {
          state = AsyncError(failure.message, StackTrace.current);
          return false;
        },
        (_) {
          NotificationService.show(
            id: 0,
            title: '✅ Сохранено!',
            body:
                'Размер: ${(base64Decode(compressedImage).length / 1024).toStringAsFixed(1)} KB',
          );
          return true;
        },
      );
    } catch (error, stackTrace) {
      final errorText = error is AppFailure ? error.message : error.toString();
      state = AsyncError(errorText, stackTrace);
      return false;
    }
  }

  Future<bool> updateDoodle({
    required DrawingController drawingController,
    required DoodleModel doodle,
    required String title,
    required String userUid,
  }) async {
    state = const AsyncLoading();

    try {
      final bytes = await _exportPng(drawingController);
      if (bytes == null) {
        state = AsyncError('Экспорт не удался', StackTrace.empty);
        return false;
      }

      await _saveToGallery(bytes);

      final compressedImage = await _compressImage(
        originalBytes: bytes,
        quality: 100,
      );

      final repository = ref.read(doodleRepositoryProvider);
      final result = await repository.updateDoodle(
        userUid: userUid,
        doodle: doodle.copyWith(title: title, fullImageBase64: compressedImage),
      );

      return result.fold(
        (failure) {
          state = AsyncError(failure.message, StackTrace.current);
          return false;
        },
        (_) {
          NotificationService.show(
            id: 1,
            title: '✅ Обновлено!',
            body:
                'Размер: ${(base64Decode(compressedImage).length / 1024).toStringAsFixed(1)} KB',
          );
          state = const AsyncData(null);
          return true;
        },
      );
    } catch (error, stackTrace) {
      final errorText = error is AppFailure ? error.message : error.toString();
      state = AsyncError(errorText, stackTrace);
      return false;
    }
  }

  Future<Uint8List?> pickBackgroundImageBytes() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final bytes = await File(image.path).readAsBytes();

        return await FlutterImageCompress.compressWithList(bytes, quality: 85);
      }
      return null;
    } catch (error) {
      final errorText = error is AppFailure ? error.message : error.toString();
      state = AsyncError('Ошибка выбора: $errorText', StackTrace.current);
      return null;
    }
  }

  Future<Uint8List?> _exportPng(DrawingController controller) async {
    final data = await controller.getImageData(format: ImageByteFormat.png);
    return data?.buffer.asUint8List();
  }

  Future<String> _compressImage({
    required Uint8List originalBytes,
    int? quality,
  }) async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/temp_original.png');
    await tempFile.writeAsBytes(originalBytes);

    final fullBytes = await FlutterImageCompress.compressWithFile(
      tempFile.absolute.path,
      quality: quality ?? 85,
      minWidth: 1200,
      minHeight: 1600,
      format: CompressFormat.jpeg,
    );

    final fullImageBase64 = base64Encode(fullBytes ?? []);

    await tempFile.delete();

    return fullImageBase64;
  }

  Future<void> _saveToGallery(Uint8List imageBytes) async {
    try {
      final result = await SaverGallery.saveImage(
        imageBytes,
        quality: 100,
        fileName: 'doodle_${DateTime.now().millisecondsSinceEpoch}',
        skipIfExists: true,
      );

      if (result.isSuccess == true) {
        return;
      } else {
        throw UnknownFailure(
          message: 'Ошибка сохранения в галерею: ${result.errorMessage}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}

final drawingControllerProvider = Provider.autoDispose<DrawingController>((
  ref,
) {
  final controller = DrawingController();
  ref.onDispose(controller.dispose);
  return controller;
});
