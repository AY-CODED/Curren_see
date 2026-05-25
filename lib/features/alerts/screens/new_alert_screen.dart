import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/providers.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/models/rate_alert.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/currency_icon.dart';
import '../../../shared/widgets/cs_header.dart';

class NewAlertScreen extends ConsumerStatefulWidget {
  const NewAlertScreen({super.key});

  @override
  ConsumerState<NewAlertScreen> createState() => _NewAlertScreenState();
}

class _NewAlertScreenState extends ConsumerState<NewAlertScreen> {
  String _from = 'USD';
  String _to = 'EUR';
  double _target = 0.95;
  String _condition = 'above';
  bool _loading = false;
  final _targetCtrl = TextEditingController(text: '0.95');

  @override
  void dispose() {
    _targetCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    setState(() => _loading = true);
    try {
      await ref.read(firestoreServiceProvider).addAlert(
            user.uid,
            RateAlert(
              baseCurrency: _from,
              targetCurrency: _to,
              targetRate: _target,
              condition: _condition,
              createdAt: DateTime.now(),
            ),
          );
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rates = ref.watch(exchangeRatesProvider).value ?? {};
    final rateService = ref.read(exchangeRateServiceProvider);
    final current =
        rates.isNotEmpty ? rateService.getRate(_from, _to, rates) : 0.0;
    final distance =
        current > 0 ? ((_target - current) / current * 100) : 0.0;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            CSHeader(
              title: 'New alert',
              eyebrow: "We'll watch for you",
              leading: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.close_rounded,
                    color: AppColors.ink2, size: 22),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 8, 22, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CURRENCY PAIR',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.54,
                        color: AppColors.ink3,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        border: Border.all(color: AppColors.hairline),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final result = await Navigator.of(context)
                                  .pushNamed('/currency-picker', arguments: {
                                'kind': 'from',
                                'from': _from,
                                'to': _to,
                              });
                              if (result is String) {
                                setState(() => _from = result);
                              }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CurrencyIcon(code: _from, size: 28),
                                const SizedBox(width: 8),
                                Text(
                                  _from,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.ink,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14),
                            child: Icon(Icons.arrow_forward_ios_rounded,
                                size: 14, color: AppColors.ink3),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final result = await Navigator.of(context)
                                  .pushNamed('/currency-picker', arguments: {
                                'kind': 'to',
                                'from': _from,
                                'to': _to,
                              });
                              if (result is String) {
                                setState(() => _to = result);
                              }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CurrencyIcon(code: _to, size: 28),
                                const SizedBox(width: 8),
                                Text(
                                  _to,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.ink,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.surface2,
                              borderRadius: BorderRadius.circular(100),
                              border:
                                  Border.all(color: AppColors.hairline),
                            ),
                            child: Text(
                              CurrencyFormatter.formatRate(current),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: AppColors.ink2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    Text(
                      'NOTIFY ME WHEN RATE GOES',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.54,
                        color: AppColors.ink3,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: ['above', 'below'].map((c) {
                        final on = _condition == c;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: c == 'above' ? 10 : 0),
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _condition = c),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: on
                                      ? AppColors.goldGlow
                                      : AppColors.surface,
                                  border: Border.all(
                                    color: on
                                        ? AppColors.gold
                                        : AppColors.hairline,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      c == 'above'
                                          ? Icons.arrow_upward_rounded
                                          : Icons.arrow_downward_rounded,
                                      size: 16,
                                      color: on
                                          ? AppColors.gold
                                          : AppColors.ink2,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      c[0].toUpperCase() +
                                          c.substring(1),
                                      style: TextStyle(
                                        fontSize: 13,
                                        letterSpacing: 0.52,
                                        color: on
                                            ? AppColors.gold
                                            : AppColors.ink2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),
                    Text(
                      'TARGET RATE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.54,
                        color: AppColors.ink3,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        border: Border.all(color: AppColors.hairline),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _targetCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              onChanged: (v) {
                                final n = double.tryParse(v);
                                if (n != null) {
                                  setState(() => _target = n);
                                }
                              },
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 36,
                                letterSpacing: -0.9,
                                color: AppColors.ink,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                                filled: false,
                              ),
                            ),
                          ),
                          Text(
                            _to,
                            style: const TextStyle(
                                fontSize: 13, color: AppColors.ink3),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.ink3),
                        children: [
                          const TextSpan(text: 'Current is '),
                          TextSpan(
                            text: CurrencyFormatter.formatRate(current),
                            style:
                                const TextStyle(color: AppColors.gold),
                          ),
                          TextSpan(
                            text:
                                ' \u00b7 target is ${distance.toStringAsFixed(2)}% ${_target > current ? 'higher' : 'lower'}',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(22, 16, 22, 16),
              child: GoldButton(
                label: 'Create alert',
                icon: Icons.notifications_outlined,
                onPressed: _save,
                isLoading: _loading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
