import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/models/currency.dart';
import '../../../shared/widgets/currency_icon.dart';
import '../../../shared/widgets/cs_header.dart';

class CurrencyPickerScreen extends StatefulWidget {
  final String kind; // 'from' or 'to'
  final String selectedFrom;
  final String selectedTo;

  const CurrencyPickerScreen({
    super.key,
    required this.kind,
    required this.selectedFrom,
    required this.selectedTo,
  });

  @override
  State<CurrencyPickerScreen> createState() => _CurrencyPickerScreenState();
}

class _CurrencyPickerScreenState extends State<CurrencyPickerScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  static const _recents = ['USD', 'EUR', 'GBP', 'JPY'];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  String get _selected =>
      widget.kind == 'from' ? widget.selectedFrom : widget.selectedTo;

  @override
  Widget build(BuildContext context) {
    final filtered = CurrencyData.all.where((c) {
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      return c.code.toLowerCase().contains(q) ||
          c.name.toLowerCase().contains(q) ||
          c.country.toLowerCase().contains(q);
    }).toList();

    // Group by first letter
    final groups = <String, List<Currency>>{};
    for (final c in filtered) {
      final key = c.code[0];
      groups.putIfAbsent(key, () => []).add(c);
    }
    final sortedKeys = groups.keys.toList()..sort();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            CSHeader(
              title: widget.kind == 'from' ? 'Send from' : 'Receive in',
              eyebrow: 'Choose a currency',
              leading: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.close_rounded,
                    color: AppColors.ink2, size: 22),
              ),
            ),

            // Search
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 4, 22, 12),
              child: TextField(
                controller: _searchCtrl,
                autofocus: true,
                onChanged: (v) => setState(() => _query = v),
                style: const TextStyle(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  hintText: 'Search currency, country, or code',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 16, right: 12),
                    child:
                        Icon(Icons.search_rounded, size: 18, color: AppColors.ink3),
                  ),
                  prefixIconConstraints:
                      const BoxConstraints(minWidth: 46, minHeight: 0),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.hairline),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.hairline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.gold),
                  ),
                ),
              ),
            ),

            // Recents
            if (_query.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 4, 22, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RECENT',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.54,
                        color: AppColors.ink3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _recents.map((code) {
                          final isSel = code == _selected;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(code),
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
                                decoration: BoxDecoration(
                                  color: isSel
                                      ? AppColors.goldGlow
                                      : AppColors.surface,
                                  border: Border.all(
                                    color: isSel
                                        ? AppColors.gold
                                        : AppColors.hairline,
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CurrencyIcon(code: code, size: 22),
                                    const SizedBox(width: 8),
                                    Text(
                                      code,
                                      style: TextStyle(
                                        fontSize: 12,
                                        letterSpacing: 0.48,
                                        color: isSel
                                            ? AppColors.gold
                                            : AppColors.ink,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

            // Currency list
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'NO MATCHES',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.54,
                              color: AppColors.ink3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Try a country, code, or name.',
                            style: TextStyle(
                                color: AppColors.ink3, fontSize: 14),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: sortedKeys.length,
                      itemBuilder: (context, sectionIndex) {
                        final letter = sortedKeys[sectionIndex];
                        final currencies = groups[letter]!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              color: AppColors.bg,
                              padding: const EdgeInsets.fromLTRB(22, 14, 22, 6),
                              child: Text(
                                letter,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.54,
                                  color: AppColors.ink3,
                                ),
                              ),
                            ),
                            ...currencies.map((c) => _CurrencyRow(
                                  currency: c,
                                  isSelected: c.code == _selected,
                                  onTap: () =>
                                      Navigator.of(context).pop(c.code),
                                )),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrencyRow extends StatelessWidget {
  final Currency currency;
  final bool isSelected;
  final VoidCallback onTap;

  const _CurrencyRow({
    required this.currency,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: isSelected ? AppColors.surface2 : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        child: Row(
          children: [
            CurrencyIcon(code: currency.code, size: 40),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        currency.code,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.6,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        currency.symbol,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.ink3),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    currency.name,
                    style:
                        const TextStyle(fontSize: 13, color: AppColors.ink2),
                  ),
                ],
              ),
            ),
            Text(
              currency.country,
              style:
                  const TextStyle(fontSize: 11, color: AppColors.ink3),
            ),
            if (isSelected) ...[
              const SizedBox(width: 10),
              const Icon(Icons.check_rounded, size: 18, color: AppColors.gold),
            ],
          ],
        ),
      ),
    );
  }
}
