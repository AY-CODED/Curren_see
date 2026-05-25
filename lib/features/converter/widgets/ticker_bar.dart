import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class TickerBar extends StatefulWidget {
  const TickerBar({super.key});

  @override
  State<TickerBar> createState() => _TickerBarState();
}

class _TickerBarState extends State<TickerBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  static const _items = [
    _TickerItem('EUR/USD', '1.0853', 0.24),
    _TickerItem('GBP/USD', '1.2786', -0.11),
    _TickerItem('USD/JPY', '156.42', 0.42),
    _TickerItem('USD/CHF', '0.8930', -0.08),
    _TickerItem('AUD/USD', '0.6574', 0.31),
    _TickerItem('USD/CAD', '1.3654', 0.07),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0x0FC9A961), // gold 6%
            Colors.transparent,
          ],
        ),
        border: Border(bottom: BorderSide(color: AppColors.hairline)),
      ),
      child: ClipRect(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FractionalTranslation(
              translation: Offset(-_controller.value, 0),
              child: child,
            );
          },
          child: Row(
            children: [
              ..._buildRow(),
              ..._buildRow(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRow() {
    return _items.map((item) {
      return Padding(
        padding: const EdgeInsets.only(right: 24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.pair,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color: AppColors.ink3,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              item.rate,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${item.delta >= 0 ? '\u25b2' : '\u25bc'} ${item.delta.abs().toStringAsFixed(2)}%',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color:
                    item.delta >= 0 ? AppColors.positive : AppColors.negative,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

class _TickerItem {
  final String pair;
  final String rate;
  final double delta;
  const _TickerItem(this.pair, this.rate, this.delta);
}
