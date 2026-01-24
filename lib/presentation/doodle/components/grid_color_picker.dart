import 'package:flutter/material.dart';

class GridColorPicker extends StatelessWidget {
  const GridColorPicker({
    super.key,
    required this.selected,
    required this.onSelect,
    this.visibleColumns = 12,
    this.totalColumns = 36,
    this.rows = 10,
  });

  final Color selected;
  final ValueChanged<Color> onSelect;
  final int visibleColumns;
  final int totalColumns;
  final int rows;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: totalColumns * 24.0,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: totalColumns,
              childAspectRatio: 1.0,
            ),
            itemCount: rows * totalColumns,
            itemBuilder: (context, index) {
              final x = index % totalColumns;
              final y = index ~/ totalColumns;

              late final Color color;

              final isTopLeft = x == 0 && y == 0;
              final isTopRight = x == totalColumns - 1 && y == 0;
              final isBottomLeft = x == 0 && y == rows - 1;
              final isBottomRight = x == totalColumns - 1 && y == rows - 1;

              BorderRadius? radius;

              if (isTopLeft || isTopRight || isBottomLeft || isBottomRight) {
                radius = BorderRadius.only(
                  topLeft: isTopLeft ? const Radius.circular(8) : Radius.zero,
                  topRight: isTopRight ? const Radius.circular(8) : Radius.zero,
                  bottomLeft: isBottomLeft
                      ? const Radius.circular(8)
                      : Radius.zero,
                  bottomRight: isBottomRight
                      ? const Radius.circular(8)
                      : Radius.zero,
                );
              }

              if (y == 0) {
                final t = x / (totalColumns - 1);
                final v = (255 * (1 - t)).round();
                color = Color.fromARGB(255, v, v, v);
              } else {
                final hue = x / (totalColumns - 1) * 360.0;
                final saturation = 0.4 + 0.6 * (y / (rows - 1));
                final value = 0.2 + 0.8 * (y / (rows - 1));
                color = HSVColor.fromAHSV(
                  1.0,
                  hue,
                  saturation,
                  value,
                ).toColor();
              }

              final isSelected = color == selected;

              return GestureDetector(
                onTap: () => onSelect(color),
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: radius,
                    border: isSelected
                        ? Border.all(color: Colors.white, width: 2)
                        : null,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}