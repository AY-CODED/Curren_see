import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/currency_icon.dart';
import '../../../shared/widgets/sparkline.dart';
import '../widgets/cs_logo.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;

  static const _slides = [
    _Slide(
      label: 'Convert',
      title: 'Know what your\nmoney is ',
      titleAccent: 'worth.',
      body:
          'Instant, mid-market rates from twenty-two currencies. No spreads. No surprises.',
    ),
    _Slide(
      label: 'Track',
      title: 'Every conversion,\n',
      titleAccent: 'remembered.',
      body:
          'Your history is private, searchable, and ready when you need to find that one number.',
    ),
    _Slide(
      label: 'Watch',
      title: 'Get told when a rate\n',
      titleAccent: 'moves your way.',
      body:
          "Set a target. We'll quietly watch the market and ping you the moment it hits.",
    ),
  ];

  void _next() {
    if (_step < _slides.length - 1) {
      setState(() => _step++);
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  void _skip() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_step];
    final isLast = _step == _slides.length - 1;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CSLogo(size: 18),
                  TextButton(
                    onPressed: _skip,
                    child: const Text('Skip'),
                  ),
                ],
              ),
            ),

            // Art area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          border: Border.all(color: AppColors.hairline),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: _buildArt(_step),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Label
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '0${_step + 1} / 03 \u00b7 ${slide.label}'
                            .toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.98,
                          color: AppColors.gold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Title
                    Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 34,
                            height: 1.05,
                            letterSpacing: -0.68,
                            color: AppColors.ink,
                          ),
                          children: [
                            TextSpan(text: slide.title),
                            TextSpan(
                              text: slide.titleAccent,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                color: AppColors.gold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Body
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        slide.body,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.55,
                          color: AppColors.ink2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom: dots + button
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
              child: Row(
                children: [
                  // Dots
                  Row(
                    children: List.generate(3, (i) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 6),
                        width: i == _step ? 22 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: i == _step
                              ? AppColors.gold
                              : AppColors.hairline2,
                        ),
                      );
                    }),
                  ),
                  const Spacer(),
                  GoldButton(
                    label: isLast ? 'Get started' : 'Next',
                    icon: Icons.arrow_forward_ios_rounded,
                    onPressed: _next,
                    fullWidth: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArt(int step) {
    switch (step) {
      case 0:
        return SizedBox(
          width: 220,
          height: 200,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 18,
                child: Transform.rotate(
                  angle: -0.1,
                  child: const CurrencyDisc(code: 'USD', size: 86),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 18,
                child: Transform.rotate(
                  angle: 0.14,
                  child: const CurrencyDisc(code: 'EUR', size: 86),
                ),
              ),
              Center(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.goldGlow,
                    border: Border.all(
                      color: AppColors.gold.withValues(alpha: 0.4),
                    ),
                  ),
                  child: const Icon(
                    Icons.swap_vert_rounded,
                    size: 26,
                    color: AppColors.gold,
                  ),
                ),
              ),
            ],
          ),
        );
      case 1:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (i) {
              final codes = ['USD', 'GBP', 'JPY'];
              final labels = ['\$2,400 \u2192 \u20ac2,211', '\u00a31,500 \u2192 \$1,917', '\u00a5800 \u2192 \u20ac7.50'];
              return Opacity(
                opacity: 1 - i * 0.22,
                child: Transform.translate(
                  offset: Offset(i * 10.0, 0),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.surface2,
                      border: Border.all(color: AppColors.hairline),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CurrencyIcon(code: codes[i], size: 28),
                        const SizedBox(width: 12),
                        Text(
                          labels[i],
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.ink2,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Sparkline(
                          data: _mockSeries(5 + i),
                          width: 36,
                          height: 16,
                          color: AppColors.gold,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      case 2:
        final data = _mockSeries(7);
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              Sparkline(
                data: data,
                width: 216,
                height: 140,
                color: AppColors.gold,
                fillColor: AppColors.gold,
              ),
              Positioned(
                right: 4,
                top: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.goldGlow,
                        blurRadius: 16,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Text(
                    'ALERT',
                    style: TextStyle(
                      color: Color(0xFF0A0E1A),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  List<double> _mockSeries(int seed) {
    final arr = <double>[];
    var s = seed;
    double rand() {
      s = (s * 9301 + 49297) % 233280;
      return s / 233280;
    }

    var v = 1.0 * (0.96 + rand() * 0.08);
    for (var i = 0; i < 12; i++) {
      final drift = (rand() - 0.48) * 0.012;
      v = v * (1 + drift);
      arr.add(v);
    }
    return arr;
  }
}

class _Slide {
  final String label;
  final String title;
  final String titleAccent;
  final String body;

  const _Slide({
    required this.label,
    required this.title,
    required this.titleAccent,
    required this.body,
  });
}
