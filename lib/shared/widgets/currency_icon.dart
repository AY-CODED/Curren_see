import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../models/currency.dart';

class CurrencyIcon extends StatelessWidget {
  final String code;
  final double size;

  const CurrencyIcon({super.key, required this.code, this.size = 40});

  @override
  Widget build(BuildContext context) {
    final currency = CurrencyData.get(code);
    final tone = currency?.tone ?? const Color(0xFF555555);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.4, -0.5),
          radius: 1.2,
          colors: [
            tone.withValues(alpha: 0.94),
            tone.withValues(alpha: 0.5),
            tone.withValues(alpha: 0.25),
          ],
          stops: const [0, 0.6, 1],
        ),
        boxShadow: [
          const BoxShadow(
            color: Color(0x2EFFFFFF),
            offset: Offset(0, 1),
            blurRadius: 0,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Gold inner ring
          Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.gold.withValues(alpha: 0.35),
                width: 0.5,
              ),
            ),
          ),
          Text(
            code,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: size * 0.32,
              letterSpacing: 0.5,
              shadows: const [
                Shadow(color: Color(0x80000000), offset: Offset(0, 1), blurRadius: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CurrencyDisc extends StatelessWidget {
  final String code;
  final double size;

  const CurrencyDisc({super.key, required this.code, this.size = 70});

  @override
  Widget build(BuildContext context) {
    final currency = CurrencyData.get(code);
    final tone = currency?.tone ?? const Color(0xFF555555);
    final symbol = currency?.symbol ?? '?';

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.4, -0.5),
          radius: 1.2,
          colors: [
            tone.withValues(alpha: 0.94),
            tone.withValues(alpha: 0.5),
            tone.withValues(alpha: 0.19),
          ],
          stops: const [0, 0.6, 1],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            offset: const Offset(0, 12),
            blurRadius: 30,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(size * 0.06),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.gold.withValues(alpha: 0.4),
                width: 0.5,
              ),
            ),
          ),
          Text(
            symbol,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              fontSize: size * 0.5,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}
