import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// The CurrenSee mark: stacked C's forming an eye/lens with horizontal bar.
class CSMark extends StatelessWidget {
  final double size;
  final Color color;

  const CSMark({
    super.key,
    this.size = 32,
    this.color = AppColors.gold,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _CSMarkPainter(color: color),
    );
  }
}

class _CSMarkPainter extends CustomPainter {
  final Color color;
  _CSMarkPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 40;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2 * scale
      ..strokeCap = StrokeCap.round;

    // Outer arc
    final outerRect = Rect.fromLTWH(7 * scale, 7 * scale, 26 * scale, 26 * scale);
    canvas.drawArc(outerRect, -2.3, 4.6, false, paint);

    // Inner arc (lighter)
    final innerPaint = Paint()
      ..color = color.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6 * scale
      ..strokeCap = StrokeCap.round;
    final innerRect = Rect.fromLTWH(14 * scale, 14 * scale, 12 * scale, 12 * scale);
    canvas.drawArc(innerRect, -2.0, 4.0, false, innerPaint);

    // Horizontal line
    canvas.drawLine(
      Offset(22 * scale, 20 * scale),
      Offset(34 * scale, 20 * scale),
      paint,
    );

    // End dot
    canvas.drawCircle(
      Offset(34 * scale, 20 * scale),
      1.6 * scale,
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant _CSMarkPainter old) => color != old.color;
}

/// "CurrenSee." wordmark with italic gold "See".
class CSWordmark extends StatelessWidget {
  final double size;
  final Color color;
  final Color goldColor;

  const CSWordmark({
    super.key,
    this.size = 24,
    this.color = AppColors.ink,
    this.goldColor = AppColors.gold,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: size,
          letterSpacing: -size * 0.04,
          height: 1,
          color: color,
        ),
        children: [
          const TextSpan(text: 'Curren'),
          TextSpan(
            text: 'See',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: goldColor,
            ),
          ),
          TextSpan(
            text: '.',
            style: TextStyle(color: goldColor),
          ),
        ],
      ),
    );
  }
}

/// Combined logo: mark + wordmark.
class CSLogo extends StatelessWidget {
  final double size;

  const CSLogo({super.key, this.size = 28});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CSMark(size: size * 1.2),
        const SizedBox(width: 10),
        CSWordmark(size: size),
      ],
    );
  }
}
