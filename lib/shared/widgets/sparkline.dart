import 'dart:math';
import 'package:flutter/material.dart';

class Sparkline extends StatelessWidget {
  final List<double> data;
  final double width;
  final double height;
  final Color color;
  final Color? fillColor;

  const Sparkline({
    super.key,
    required this.data,
    this.width = 80,
    this.height = 28,
    this.color = const Color(0xFFC9A961),
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return SizedBox(width: width, height: height);

    return CustomPaint(
      size: Size(width, height),
      painter: _SparklinePainter(
        data: data,
        lineColor: color,
        fillColor: fillColor,
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color lineColor;
  final Color? fillColor;

  _SparklinePainter({
    required this.data,
    required this.lineColor,
    this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final minVal = data.reduce(min);
    final maxVal = data.reduce(max);
    final range = maxVal - minVal;
    const pad = 2.0;

    final points = <Offset>[];
    for (var i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * (size.width - pad * 2) + pad;
      final y = range == 0
          ? size.height / 2
          : size.height -
              pad -
              ((data[i] - minVal) / range) * (size.height - pad * 2);
      points.add(Offset(x, y));
    }

    // Fill area
    if (fillColor != null && points.length >= 2) {
      final fillPath = Path()..moveTo(points.first.dx, points.first.dy);
      for (final p in points.skip(1)) {
        fillPath.lineTo(p.dx, p.dy);
      }
      fillPath.lineTo(points.last.dx, size.height);
      fillPath.lineTo(points.first.dx, size.height);
      fillPath.close();

      canvas.drawPath(
        fillPath,
        Paint()..color = fillColor!.withValues(alpha: 0.18),
      );
    }

    // Line
    if (points.length >= 2) {
      final linePath = Path()..moveTo(points.first.dx, points.first.dy);
      for (final p in points.skip(1)) {
        linePath.lineTo(p.dx, p.dy);
      }

      canvas.drawPath(
        linePath,
        Paint()
          ..color = lineColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }

    // End dot
    if (points.isNotEmpty) {
      canvas.drawCircle(points.last, 2, Paint()..color = lineColor);
    }
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter old) =>
      data != old.data || lineColor != old.lineColor;
}
