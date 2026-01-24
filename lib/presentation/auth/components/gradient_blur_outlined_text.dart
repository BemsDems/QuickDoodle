import 'package:flutter/material.dart';

class GradientBlurOutlinedText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Gradient gradient;
  final double strokeWidth;
  final double glowSigma;
  final double glowStrokeExtra;
  final Color? fillColor;

  const GradientBlurOutlinedText({
    super.key,
    required this.text,
    required this.style,
    required this.gradient,
    required this.strokeWidth,
    required this.glowSigma,
    required this.glowStrokeExtra,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: Directionality.of(context),
      maxLines: 1,
    )..layout();

    final rect = Offset.zero & tp.size;

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + glowStrokeExtra
      ..shader = gradient.createShader(rect)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowSigma);

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = gradient.createShader(rect);

    return Stack(
      children: [
        Text(text, style: style.copyWith(foreground: glowPaint)),
        Text(text, style: style.copyWith(foreground: strokePaint)),
        Text(text, style: style.copyWith(color: fillColor)),
      ],
    );
  }
}
