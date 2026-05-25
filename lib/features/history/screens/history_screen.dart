import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/providers.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/models/conversion_history.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/currency_icon.dart';
import '../../../shared/widgets/cs_header.dart';
import '../../../shared/widgets/sparkline.dart';
import '../../../features/auth/widgets/cs_logo.dart';

final historyProvider =
    StreamProvider.family<List<ConversionHistory>, String>((ref, uid) {
  return ref.watch(firestoreServiceProvider).watchConversions(uid);
});

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    if (user == null) {
      return const Center(child: Text('Not signed in'));
    }

    final historyAsync = ref.watch(historyProvider(user.uid));

    return historyAsync.when(
      data: (items) => items.isEmpty
          ? _EmptyHistory(context: context)
          : _FilledHistory(items: items),
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.gold),
      ),
      error: (_, __) => const Center(
        child: Text('Failed to load history', style: TextStyle(color: AppColors.ink2)),
      ),
    );
  }
}

class _FilledHistory extends StatelessWidget {
  final List<ConversionHistory> items;
  const _FilledHistory({required this.items});

  @override
  Widget build(BuildContext context) {
    // Group by date
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    final todayItems = <ConversionHistory>[];
    final yesterdayItems = <ConversionHistory>[];
    final olderItems = <ConversionHistory>[];

    for (final item in items) {
      if (_isSameDay(item.createdAt, today)) {
        todayItems.add(item);
      } else if (_isSameDay(item.createdAt, yesterday)) {
        yesterdayItems.add(item);
      } else {
        olderItems.add(item);
      }
    }

    // Calculate total for summary
    final totalUSD = items.fold<double>(0, (sum, item) {
      if (item.baseCurrency == 'USD') return sum + item.amount;
      return sum + item.convertedAmount;
    });

    return Column(
      children: [
        CSHeader(
          title: 'History',
          eyebrow: '${items.length} conversions',
          large: true,
          leading: const CSMark(size: 26),
          actions: [
            IconBtn(
              child: const Icon(Icons.filter_list_rounded),
              onTap: () {},
            ),
            IconBtn(
              child: const Icon(Icons.search_rounded),
              onTap: () {},
            ),
          ],
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Summary card
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 8, 22, 14),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.surface, AppColors.surface2],
                    ),
                    border: Border.all(color: AppColors.hairline2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'THIS MONTH',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.26,
                                color: AppColors.ink3,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '\$${CurrencyFormatter.formatCompact(totalUSD)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 30,
                                    letterSpacing: -0.6,
                                    color: AppColors.ink,
                                    height: 1,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'USD',
                                  style: TextStyle(
                                      fontSize: 11, color: AppColors.ink3),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Sparkline(
                        data: const [80, 85, 78, 92, 96, 88, 102, 110, 118, 122, 138, 148],
                        width: 88,
                        height: 48,
                        color: AppColors.gold,
                        fillColor: AppColors.gold,
                      ),
                    ],
                  ),
                ),
              ),

              // Groups
              if (todayItems.isNotEmpty)
                _HistoryGroup(title: 'Today', items: todayItems),
              if (yesterdayItems.isNotEmpty)
                _HistoryGroup(title: 'Yesterday', items: yesterdayItems),
              if (olderItems.isNotEmpty)
                _HistoryGroup(title: 'Earlier', items: olderItems),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _HistoryGroup extends StatelessWidget {
  final String title;
  final List<ConversionHistory> items;

  const _HistoryGroup({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 14, 22, 4),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.54,
              color: AppColors.ink3,
            ),
          ),
        ),
        ...items.map((h) => _HistoryRow(item: h)),
      ],
    );
  }
}

class _HistoryRow extends StatelessWidget {
  final ConversionHistory item;

  const _HistoryRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat('HH:mm').format(item.createdAt);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.hairline)),
      ),
      child: Row(
        children: [
          // Overlapping currency icons
          SizedBox(
            width: 50,
            child: Stack(
              children: [
                CurrencyIcon(code: item.baseCurrency, size: 32),
                Positioned(
                  left: 18,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.bg, width: 2),
                    ),
                    child: CurrencyIcon(
                        code: item.targetCurrency, size: 32),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${item.baseCurrency} \u2192 ${item.targetCurrency}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '@ ${CurrencyFormatter.formatRate(item.rate)}',
                      style: const TextStyle(
                          fontSize: 10, color: AppColors.ink3),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  timeStr,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.ink3),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                CurrencyFormatter.formatAmount(
                    item.convertedAmount, item.targetCurrency),
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  letterSpacing: -0.18,
                  color: AppColors.ink,
                  height: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'from ${CurrencyFormatter.formatAmount(item.amount, item.baseCurrency)} ${item.baseCurrency}',
                style: const TextStyle(
                    fontSize: 11, color: AppColors.ink3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  final BuildContext context;
  const _EmptyHistory({required this.context});

  @override
  Widget build(BuildContext _) {
    return Column(
      children: [
        CSHeader(
          title: 'History',
          eyebrow: 'Nothing yet',
          large: true,
          leading: const CSMark(size: 26),
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface,
                      border: Border.all(
                        color: AppColors.hairline2,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: const Icon(Icons.history_rounded,
                        size: 32, color: AppColors.ink3),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'NO HISTORY',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.98,
                      color: AppColors.gold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 26,
                        letterSpacing: -0.52,
                        color: AppColors.ink,
                        height: 1.1,
                      ),
                      children: [
                        TextSpan(text: 'Make your first '),
                        TextSpan(
                          text: 'conversion.',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: AppColors.gold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Saved conversions live here \u2014 every amount, rate, and date, kept private to your account.',
                    style: TextStyle(fontSize: 14, color: AppColors.ink2),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 26),
                  GoldButton(
                    label: 'Convert now',
                    icon: Icons.add_rounded,
                    onPressed: () {},
                    fullWidth: false,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
