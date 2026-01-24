import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_doodle/core/config/app_colors.dart';
import 'package:quick_doodle/core/error/app_failure.dart';
import 'package:quick_doodle/models/doodle/doodle_model.dart';

final doodleCacheProvider = Provider<CacheManager>((ref) {
  return CacheManager(
    Config(
      'doodle_images',
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 100,
    ),
  );
});
class CachedDoodleImage extends ConsumerStatefulWidget {
  final DoodleModel doodle;

  const CachedDoodleImage({super.key, required this.doodle});

  @override
  ConsumerState<CachedDoodleImage> createState() => _CachedDoodleImageState();
}

class _CachedDoodleImageState extends ConsumerState<CachedDoodleImage> {
  Uint8List? _imageBytes;
  bool _isLoading = true;
  String? _error;

  

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(CachedDoodleImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.doodle.fullImageBase64 != widget.doodle.fullImageBase64) {
      _imageBytes = null;
      _isLoading = true;
      _loadImage();
    }
  }

  

  Future<void> _loadImage() async {
    final cacheManager = ref.read(doodleCacheProvider);
    try {
      final base64String = widget.doodle.fullImageBase64 ?? "";
      if (base64String.isEmpty) {
        throw UnknownFailure(message: 'Пустой base64');
      }

      final cacheKey =
          'doodle_${md5.convert(utf8.encode(base64String)).toString()}';

      final cachedFile = await cacheManager.getFileFromCache(cacheKey);
      if (cachedFile != null) {
        final cachedBytes = await cachedFile.file.readAsBytes();
        setState(() {
          _imageBytes = cachedBytes;
          _isLoading = false;
        });
        return;
      }

      Uint8List originalBytes = base64Decode(base64String);

      final originalSizeKB = originalBytes.length / 1024;
      if (originalSizeKB > 500) {
        originalBytes = await _smartCompress(originalBytes);
      }

      await cacheManager.putFile(cacheKey, originalBytes);

      setState(() {
        _imageBytes = originalBytes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<Uint8List> _smartCompress(Uint8List bytes) async {
    final result = await FlutterImageCompress.compressWithList(
      bytes,
      minHeight: 320,
      minWidth: 320,
      quality: 90,
      format: CompressFormat.jpeg,
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: AppColors.greyDark,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    if (_error != null || _imageBytes == null) {
      return Container(
        color: AppColors.greyDark,
        child: const Icon(Icons.image_not_supported, color: AppColors.grey),
      );
    }

    return Image.memory(_imageBytes!, fit: BoxFit.cover, gaplessPlayback: true);
  }
}
