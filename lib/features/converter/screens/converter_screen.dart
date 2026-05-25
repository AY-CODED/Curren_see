import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/providers.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/models/conversion_history.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/currency_icon.dart';
import '../../../shared/widgets/cs_header.dart';
import '../../../shared/widgets/sparkline.dart';
import '../../../features/auth/widgets/cs_logo.dart';
import '../providers/converter_provider.dart';
import '../widgets/ticker_bar.dart';

class ConverterScreen extends ConsumerStatefulWidget {
  const ConverterScreen({super.key});

  @override
  ConsumerState<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends ConsumerState<ConverterScreen> {
  final _amountCtrl = TextEditingController(text: '1,000.00');
  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final appUser =
        await ref.read(firestoreServiceProvider).getUser(user.uid);
    if (appUser != null && mounted) {
      ref.read(converterProvider.notifier).setFrom(appUser.lastBaseCurrency);
      ref.read(converterProvider.notifier).setTo(appUser.lastTargetCurrency);
    }
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveConversion() async {
    final state = ref.read(converterProvider);
    final rates = ref.read(exchangeRatesProvider).value;
    if (rates == null) return;

    final rateService = ref.read(exchangeRateServiceProvider);
    final rate = rateService.getRate(state.from, state.to, rates);
    final converted = rateService.convert(state.amount, state.from, state.to, rates);

    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final conversion = ConversionHistory(
      baseCurrency: state.from,
      targetCurrency: state.to,
      amount: state.amount,
      rate: rate,
      convertedAmount: converted,
      createdAt: DateTime.now(),
    );

    await ref
        .read(firestoreServiceProvider)
        .addConversion(user.uid, conversion);

    // Save last used currencies
    await ref.read(firestoreServiceProvider).updateUser(user.uid, {
      'lastBaseCurrency': state.from,
      'lastTargetCurrency': state.to,
    });

    if (mounted) {
      setState(() => _showSuccess = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(converterProvider);
    final ratesAsync = ref.watch(exchangeRatesProvider);

    if (_showSuccess) {
      return _SuccessOverlay(
        state: state,
        rates: ratesAsync.value ?? {},
        onDone: () => setState(() => _showSuccess = false),
        onViewHistory: () {
          setState(() => _showSuccess = false);
          // Navigate to history tab - handled by parent
        },
      );
    }

    return ratesAsync.when(
      data: (rates) => _buildConverter(state, rates),
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.gold),
      ),
      error: (_, __) => _buildConverter(state, {}),
    );
  }

  Widget _buildConverter(ConverterState state, Map<String, double> rates) {
    final rateService = ref.read(exchangeRateServiceProvider);
    final rate =
        rates.isNotEmpty ? rateService.getRate(state.from, state.to, rates) : 0.0;
    final converted = rates.isNotEmpty
        ? rateService.convert(state.amount, state.from, state.to, rates)
        : 0.0;
    final series = rates.isNotEmpty
        ? rateService.generateSeries(state.from, state.to, rates,
            days: 24, seed: 11)
        : <double>[];
    final delta = series.length >= 2
        ? ((series.last / series.first) - 1) * 100
        : 0.0;

    return Column(
      children: [
        // Ticker
        const TickerBar(),

        // Header
        CSHeader(
          eyebrow: 'Converter',
          title: "Today's rate",
          leading: const CSMark(size: 26),
          actions: [
            IconBtn(
              badge: true,
              child: const Icon(Icons.notifications_outlined),
              onTap: () => Navigator.of(context).pushNamed('/alerts'),
            ),
            IconBtn(
              child: const Icon(Icons.person_outline_rounded),
              onTap: () {},
            ),
          ],
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                // Amount input — base
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 4, 22, 0),
                  child: _AmountField(
                    label: 'You send',
                    code: state.from,
                    amount: state.amount,
                    editable: true,
                    onAmountChanged: (v) {
                      ref.read(converterProvider.notifier).setAmount(v);
                      _amountCtrl.text =
                          CurrencyFormatter.formatAmount(v, state.from);
                    },
                    onPickCurrency: () => _pickCurrency('from'),
                  ),
                ),

                // Swap button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
                  child: SizedBox(
                    height: 28,
                    child: Stack(
                      children: [
                        const Center(
                          child: Divider(color: AppColors.hairline),
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: () =>
                                ref.read(converterProvider.notifier).swap(),
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.surface2,
                                border: Border.all(color: AppColors.gold),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.bg,
                                    spreadRadius: 4,
                                    blurRadius: 0,
                                  ),
                                  const BoxShadow(
                                    color: AppColors.goldGlow,
                                    blurRadius: 20,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.swap_vert_rounded,
                                size: 18,
                                color: AppColors.gold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Result — target
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 0, 22, 18),
                  child: _AmountField(
                    label: 'You receive',
                    code: state.to,
                    amount: converted,
                    isResult: true,
                    onPickCurrency: () => _pickCurrency('to'),
                  ),
                ),

                // Rate strip
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 22),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border.all(color: AppColors.hairline),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'MID-MARKET \u00b7 LIVE',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.26,
                                color: AppColors.ink3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink,
                                ),
                                children: [
                                  TextSpan(text: '1 ${state.from} = '),
                                  TextSpan(
                                    text: CurrencyFormatter.formatRate(rate),
                                    style: const TextStyle(
                                        color: AppColors.gold),
                                  ),
                                  TextSpan(text: ' ${state.to}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (series.isNotEmpty)
                        Sparkline(
                          data: series,
                          width: 58,
                          height: 26,
                          color: delta >= 0
                              ? AppColors.positive
                              : AppColors.negative,
                        ),
                      const SizedBox(width: 10),
                      _Chip(
                        label:
                            '${delta >= 0 ? '\u25b2' : '\u25bc'} ${delta.abs().toStringAsFixed(2)}%',
                        isPositive: delta >= 0,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Save button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: GoldButton(
                    label: 'Save conversion',
                    icon: Icons.check_rounded,
                    onPressed: _saveConversion,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _pickCurrency(String kind) async {
    final result = await Navigator.of(context).pushNamed(
      '/currency-picker',
      arguments: {
        'kind': kind,
        'from': ref.read(converterProvider).from,
        'to': ref.read(converterProvider).to,
      },
    );
    if (result is String) {
      if (kind == 'from') {
        ref.read(converterProvider.notifier).setFrom(result);
      } else {
        ref.read(converterProvider.notifier).setTo(result);
      }
    }
  }
}

class _AmountField extends StatelessWidget {
  final String label;
  final String code;
  final double amount;
  final bool editable;
  final bool isResult;
  final VoidCallback? onPickCurrency;
  final ValueChanged<double>? onAmountChanged;

  const _AmountField({
    required this.label,
    required this.code,
    required this.amount,
    this.editable = false,
    this.isResult = false,
    this.onPickCurrency,
    this.onAmountChanged,
  });

  @override
  Widget build(BuildContext context) {
    final formatted = CurrencyFormatter.formatAmount(amount, code);
    return Row(
      children: [
        GestureDetector(
          onTap: onPickCurrency,
          child: Container(
            padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.hairline),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CurrencyIcon(code: code, size: 32),
                const SizedBox(width: 10),
                Text(
                  code,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.52,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down_rounded,
                    size: 14, color: AppColors.ink3),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
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
              const SizedBox(height: 2),
              editable
                  ? SizedBox(
                      height: 44,
                      child: TextField(
                        onChanged: (v) {
                          final raw = v.replaceAll(RegExp(r'[^0-9.]'), '');
                          final n = double.tryParse(raw) ?? 0;
                          onAmountChanged?.call(n);
                        },
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 38,
                          letterSpacing: -0.95,
                          color: AppColors.ink,
                          height: 1.1,
                        ),
                        textAlign: TextAlign.right,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                          filled: false,
                        ),
                        controller:
                            TextEditingController(text: formatted),
                      ),
                    )
                  : AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        formatted,
                        key: ValueKey(amount),
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 38,
                          letterSpacing: -0.95,
                          color: isResult ? AppColors.gold : AppColors.ink,
                          height: 1.1,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool isPositive;

  const _Chip({required this.label, required this.isPositive});

  @override
  Widget build(BuildContext context) {
    final color = isPositive ? AppColors.positive : AppColors.negative;
    final bg = isPositive ? AppColors.positiveSoft : AppColors.negativeSoft;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.66,
          color: color,
        ),
      ),
    );
  }
}

class _SuccessOverlay extends StatelessWidget {
  final ConverterState state;
  final Map<String, double> rates;
  final VoidCallback onDone;
  final VoidCallback onViewHistory;

  const _SuccessOverlay({
    required this.state,
    required this.rates,
    required this.onDone,
    required this.onViewHistory,
  });

  @override
  Widget build(BuildContext context) {
    final converted = rates.isNotEmpty
        ? (state.amount / (rates[state.from] ?? 1)) * (rates[state.to] ?? 1)
        : 0.0;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          Positioned(
            top: 16,
            right: 16,
            child: SafeArea(
              child: IconBtn(
                child: const Icon(Icons.close_rounded),
                onTap: onDone,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Gold halo
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [AppColors.goldGlow, Colors.transparent],
                        stops: const [0, 0.7],
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [AppColors.goldSoft, AppColors.gold],
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.goldGlow,
                              blurRadius: 40,
                              offset: Offset(0, 12),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          size: 36,
                          color: Color(0xFF0A0E1A),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  Text(
                    'CONVERSION SAVED',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.98,
                      color: AppColors.gold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        CurrencyFormatter.formatAmount(
                            state.amount, state.from),
                        style: const TextStyle(
                          fontSize: 20,
                          color: AppColors.ink2,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '\u2192',
                          style: TextStyle(
                              fontSize: 20, color: AppColors.gold),
                        ),
                      ),
                      Text(
                        CurrencyFormatter.formatAmount(
                            converted, state.to),
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 30,
                          letterSpacing: -0.6,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),
                  const Text(
                    'Filed in your history. Tap again any time \u2014 your last pair is remembered.',
                    style: TextStyle(fontSize: 14, color: AppColors.ink2),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: GhostButton(
                          label: 'New conversion',
                          onPressed: onDone,
                          fullWidth: true,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GoldButton(
                          label: 'View history',
                          onPressed: onViewHistory,
                          fullWidth: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
