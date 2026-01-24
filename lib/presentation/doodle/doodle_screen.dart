import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quick_doodle/core/config/app_colors.dart';
import 'package:quick_doodle/models/doodle/doodle_model.dart';
import 'package:quick_doodle/presentation/doodle/components/circle_tool_button.dart';
import 'package:quick_doodle/presentation/doodle/components/grid_color_picker.dart';
import 'package:quick_doodle/presentation/doodle/controller/doodle_controller.dart';
import 'package:quick_doodle/shared/components/custom_app_bar.dart';
import 'package:quick_doodle/shared/components/custom_scaffold.dart';
import 'package:quick_doodle/shared/providers/user/user_provider.dart';

class DoodleScreen extends ConsumerStatefulWidget {
  const DoodleScreen({super.key, this.doodle});

  final DoodleModel? doodle;

  @override
  ConsumerState<DoodleScreen> createState() => _DoodleScreenState();
}

class _DoodleScreenState extends ConsumerState<DoodleScreen> {
  double _brushSize = 6;
  Uint8List? _backgroundFile;

  bool get _isEditing => widget.doodle != null;

  @override
  void initState() {
    super.initState();
    final controller = ref.read(drawingControllerProvider);
    controller.setStyle(color: AppColors.bg);

    if (_isEditing && widget.doodle!.fullImageBase64 != null) {
      final bytes = base64Decode(widget.doodle!.fullImageBase64!);
      setState(() => _backgroundFile = bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(drawingControllerProvider);
    final drawingController = ref.watch(drawingControllerProvider);
    final user = ref.watch(currentUserProvider);

    final isLoading = ref.watch(doodleControllerProvider).isLoading;

    ref.listen(doodleControllerProvider, (previous, next) {
      if (next.hasError) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.error.toString()),
              backgroundColor: Colors.red.shade500,
            ),
          );
        }
      }
    });

    return CustomScaffold(
      appBar: CustomAppBar(
        title: _isEditing ? 'Редактирование' : 'Новое изображение',
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset('assets/icons/arrow_back.svg'),
        ),
        actions: [
          IconButton(
            onPressed: !isLoading
                ? () async {
                    bool result = false;
                    if (_isEditing) {
                      result = await ref
                          .read(doodleControllerProvider.notifier)
                          .updateDoodle(
                            drawingController: drawingController,
                            title:
                                'doodle_${DateTime.now().millisecondsSinceEpoch}',
                            doodle: widget.doodle!,
                            userUid: user!.uid,
                          );
                    } else {
                      result = await ref
                          .read(doodleControllerProvider.notifier)
                          .saveDoodle(
                            drawingController: drawingController,
                            title:
                                'doodle_${DateTime.now().millisecondsSinceEpoch}',
                            user: user!,
                          );
                    }

                    if (result == true && context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                : null,
            icon: SizedBox(
              width: 20,
              height: 20,
              child: isLoading
                  ? CircularProgressIndicator()
                  : SvgPicture.asset('assets/icons/check.svg'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleToolButton(
                  asset: 'assets/icons/download.svg',
                  onTap: () => ref
                      .read(doodleControllerProvider.notifier)
                      .shareDoodle(drawingController),
                ),
                const SizedBox(width: 12),
                CircleToolButton(
                  asset: 'assets/icons/gallery.svg',
                  onTap: () async {
                    final bytes = await ref
                        .read(doodleControllerProvider.notifier)
                        .pickBackgroundImageBytes();

                    if (bytes != null) {
                      setState(() {
                        _backgroundFile = bytes;
                      });
                    }
                  },
                ),
                const SizedBox(width: 12),
                Builder(
                  builder: (buttonContext) {
                    return CircleToolButton(
                      asset: 'assets/icons/pencil.svg',
                      onTap: () {
                        final box =
                            buttonContext.findRenderObject() as RenderBox;
                        final offset = box.localToGlobal(Offset.zero);
                        final size = box.size;

                        final controller = ref.read(drawingControllerProvider);
                        controller.setPaintContent(SimpleLine());

                        _showBrushSizePopover(
                          context: context,
                          controller: controller,
                          buttonOffset: offset,
                          buttonSize: size,
                        );
                      },
                    );
                  },
                ),
                const SizedBox(width: 12),
                CircleToolButton(
                  asset: 'assets/icons/eraser.svg',
                  onTap: () {
                    controller.setPaintContent(Eraser());
                    controller.setStyle(strokeWidth: 14);
                  },
                ),
                const SizedBox(width: 12),
                Builder(
                  builder: (buttonContext) {
                    return CircleToolButton(
                      asset: 'assets/icons/palette.svg',
                      onTap: () {
                        final box =
                            buttonContext.findRenderObject() as RenderBox;
                        final offset = box.localToGlobal(Offset.zero);
                        final size = box.size;

                        _showPalettePopover(
                          context: context,
                          controller: controller,
                          buttonOffset: offset,
                          buttonSize: size,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 25),
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: AspectRatio(
                aspectRatio: 3 / 5,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return DrawingBoard(
                      controller: controller,
                      background: _backgroundFile != null
                          ? SizedBox(
                              width: constraints.maxWidth,
                              height: constraints.maxHeight,
                              child: Image.memory(
                                _backgroundFile!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              width: constraints.maxWidth,
                              height: constraints.maxHeight,
                              color: Colors.white,
                            ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBrushSizePopover({
    required BuildContext context,
    required DrawingController controller,
    required Offset buttonOffset,
    required Size buttonSize,
  }) {
    final overlayBox =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final overlaySize = overlayBox.size;

    const panelWidth = 220.0;

    final dx = (buttonOffset.dx + panelWidth > overlaySize.width)
        ? overlaySize.width - panelWidth - 32
        : buttonOffset.dx;

    final dy = buttonOffset.dy + buttonSize.height + 8;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (_, __, ___) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            return Material(
              color: Colors.transparent,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const ColoredBox(color: Colors.transparent),
                    ),
                  ),
                  Positioned(
                    left: dx,
                    top: dy,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SizedBox(
                        width: panelWidth,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 30,
                              alignment: Alignment.center,
                              child: Container(
                                width: 140,
                                height: _brushSize,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                            ),
                            Slider(
                              min: 1,
                              max: 40,
                              value: _brushSize,
                              onChanged: (v) {
                                setLocalState(() => _brushSize = v);
                                setState(() => _brushSize = v);
                                controller.setStyle(strokeWidth: v);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showPalettePopover({
    required BuildContext context,
    required DrawingController controller,
    required Offset buttonOffset,
    required Size buttonSize,
  }) {
    final overlayBox =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final overlaySize = overlayBox.size;

    const panelWidth = 300.0;
    const panelHeight = 250.0;

    final dx = (buttonOffset.dx + panelWidth > overlaySize.width)
        ? overlaySize.width - panelWidth - 32
        : buttonOffset.dx;

    final dy = buttonOffset.dy + buttonSize.height + 8;

    final currentColor = controller.getColor;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (_, __, ___) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const ColoredBox(color: Colors.transparent),
              ),
            ),
            Positioned(
              left: dx,
              top: dy,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                ),

                child: SizedBox(
                  width: panelWidth,
                  height: panelHeight,
                  child: GridColorPicker(
                    selected: currentColor,
                    onSelect: (c) {
                      controller.setStyle(color: c);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
