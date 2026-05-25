import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/providers.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/cs_header.dart';

class RateDetailScreen extends ConsumerStatefulWidget {
  final String from;
  final String to;

  const RateDetailScreen({
    super.key,
    required this.from,
    required this.to,
  });

  @override
  ConsumerState<RateDetailScreen> createState() => _RateDetailScreenState();
}

class _RateDetailScreenState extends ConsumerState<RateDetailScreen> {
  String _range = '1M';

  static const _rangeConfig = {
    '1D': (24, 3),
    '1W': (24, 7),
    '1M': (30, 11),
    '3M': (90, 17),
    '1Y': (90, 23),
    'All': (90, 31),
  };

  @override
  Widget build(BuildContext context) {
    final rates = ref.watch(exchangeRatesProvider).value ?? {};
    final rateService = ref.read(exchangeRateServiceProvider);
    final config = _rangeConfig[_range]!;
    final series = rates.isNotEmpty
        ? rateService.generateSeries(widget.from, widget.to, rates,
            days: config.$1, seed: config.$2)
        : <double>[];

    if (series.isEmpty) {
      return const Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(
            child: CircularProgressIndicator(color: AppColors.gold)),
      );
    }

    final minVal = series.reduce(min);
    final maxVal = series.reduce(max);
    final current = series.last;
    final open = series.first;
    final change = current - open;
    final changePct = (change / open) * 100;
    final positive = change >= 0;
    final avg = series.reduce((a, b) => a + b) / series.length;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            CSHeader(
              title: '${widget.from}/${widget.to}',
              eyebrow: 'Rate detail',
              leading: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.chevron_left,
                    color: AppColors.ink2, size: 22),
              ),
              actions: [
                IconBtn(
                  child: const Icon(Icons.notifications_outlined),
                  onTap: () {},
                ),
                IconBtn(
                  child: const Icon(Icons.star_border_rounded),
                  onTap: () {},
                ),
              ],
            ),

            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Hero number
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 8, 22, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              CurrencyFormatter.formatRate(current),
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 56,
                                height: 1,
                                letterSpacing: -1.68,
                                color: AppColors.ink,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              widget.to,
                              style: const TextStyle(
                                  fontSize: 13, color: AppColors.ink3),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: positive
                                    ? AppColors.positiveSoft
                                    : AppColors.negativeSoft,
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  color: (positive
                                          ? AppColors.positive
                                          : AppColors.negative)
                                      .withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                '${positive ? '\u25b2' : '\u25bc'} ${change.abs().toStringAsFixed(4)}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: positive
                                      ? AppColors.positive
                                      : AppColors.negative,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${positive ? '+' : ''}${changePct.toStringAsFixed(2)}%',
                              style: TextStyle(
                                fontSize: 13,
                                color: positive
                                    ? AppColors.positive
                                    : AppColors.negative,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '\u00b7 $_range',
                              style: const TextStyle(
                                  fontSize: 12, color: AppColors.ink3),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Chart
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 20, 22, 0),
                    child: SizedBox(
                      height: 200,
                      child: CustomPaint(
                        size: const Size(double.infinity, 200),
                        painter: _ChartPainter(
                          data: series,
                          lineColor: AppColors.gold,
                        ),
                      ),
                    ),
                  ),

                  // Range tabs
                  Container(
                    margin: const EdgeInsets.fromLTRB(22, 14, 22, 8),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.hairline),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      children:
                          ['1D', '1W', '1M', '3M', '1Y', 'All'].map((r) {
                        final on = _range == r;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _range = r),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: on
                                    ? AppColors.gold
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                r,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.88,
                                  color: on
                                      ? const Color(0xFF0A0E1A)
                                      : AppColors.ink2,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // Stats grid
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 3,
                      children: [
                        _StatBox('Open', CurrencyFormatter.formatRate(open)),
                        _StatBox('High', CurrencyFormatter.formatRate(maxVal)),
                        _StatBox('Low', CurrencyFormatter.formatRate(minVal)),
                        _StatBox('Avg', CurrencyFormatter.formatRate(avg)),
                      ],
                    ),
                  ),

                  // CTA
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
                    child: Row(
                      children: [
                        Expanded(
                          child: GhostButton(
                            label: 'Set alert',
                            icon: Icons.notifications_outlined,
                            onPressed: () =>
                                Navigator.of(context).pushNamed('/new-alert'),
                            fullWidth: true,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GoldButton(
                            label: 'Convert',
                            icon: Icons.swap_horiz_rounded,
                            onPressed: () => Navigator.of(context).pop(),
                            fullWidth: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.hairline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.26,
              color: AppColors.ink3,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  final List<double> data;
  final Color lineColor;

  _ChartPainter({required this.data, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final minVal = data.reduce(min);
    final maxVal = data.reduce(max);
    final range = maxVal - minVal;
    const pad = 2.0;

    // Grid lines
    final gridPaint = Paint()
      ..color = const Color(0x0FFFFFFF)
      ..strokeWidth = 1;

    for (var r in [0.2, 0.4, 0.6, 0.8]) {
      final y = size.height * r;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    // Points
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

    // Fill
    if (points.length >= 2) {
      final fillPath = Path()..moveTo(points.first.dx, points.first.dy);
      for (final p in points.skip(1)) {
        fillPath.lineTo(p.dx, p.dy);
      }
      fillPath.lineTo(points.last.dx, size.height);
      fillPath.lineTo(points.first.dx, size.height);
      fillPath.close();

      final fillPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            lineColor.withValues(alpha: 0.35),
            lineColor.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

      canvas.drawPath(fillPath, fillPaint);
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
          ..strokeWidth = 1.8
          ..strokeCap = StrokeCap.round,
      );
    }

    // End marker
    if (points.isNotEmpty) {
      canvas.drawCircle(points.last, 4, Paint()..color = lineColor);
      canvas.drawCircle(
        points.last,
        9,
        Paint()..color = lineColor.withValues(alpha: 0.2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ChartPainter old) => data != old.data;
}
