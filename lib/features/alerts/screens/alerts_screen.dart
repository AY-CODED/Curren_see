import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/providers.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/models/rate_alert.dart';
import '../../../shared/widgets/currency_icon.dart';
import '../../../shared/widgets/cs_header.dart';
import '../../../features/auth/widgets/cs_logo.dart';

final alertsProvider = StreamProvider.family<List<RateAlert>, String>((
  ref,
  uid,
) {
  return ref.watch(firestoreServiceProvider).watchAlerts(uid);
});

class AlertsScreen extends ConsumerWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    if (user == null) {
      return const Center(child: Text('Not signed in'));
    }

    final alertsAsync = ref.watch(alertsProvider(user.uid));

    return alertsAsync.when(
      data: (alerts) => Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(child: _AlertsBody(alerts: alerts)),
      ),
      loading: () => Scaffold(
        backgroundColor: AppColors.bg,
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.gold),
        ),
      ),
      error: (_, __) => Scaffold(
        backgroundColor: AppColors.bg,
        body: const Center(
          child: Text(
            'Failed to load alerts',
            style: TextStyle(color: AppColors.ink2),
          ),
        ),
      ),
    );
  }
}

class _AlertsBody extends StatelessWidget {
  final List<RateAlert> alerts;
  const _AlertsBody({required this.alerts});

  @override
  Widget build(BuildContext context) {
    final active = alerts.where((a) => a.isActive).length;
    return Column(
      children: [
        CSHeader(
          title: 'Alerts',
          eyebrow: '$active active \u00b7 ${alerts.length} total',
          large: true,
          leading: const CSMark(size: 26),
          actions: [
            IconBtn(
              child: const Icon(Icons.add_rounded),
              onTap: () => Navigator.of(context).pushNamed('/new-alert'),
            ),
          ],
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 8, 22, 24),
            children: [
              ...alerts.map(
                (a) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _AlertCard(alert: a),
                ),
              ),

              // New alert CTA
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed('/new-alert'),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.hairline2,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white.withValues(alpha: 0.02),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.goldGlow,
                          border: Border.all(color: AppColors.gold),
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          size: 20,
                          color: AppColors.gold,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'New alert',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.ink,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Watch a pair, get notified',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.ink3,
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
        ),
      ],
    );
  }
}

class _AlertCard extends ConsumerWidget {
  final RateAlert alert;
  const _AlertCard({required this.alert});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rates = ref.watch(exchangeRatesProvider).value ?? {};
    final rateService = ref.read(exchangeRateServiceProvider);
    final current = rates.isNotEmpty
        ? rateService.getRate(alert.baseCurrency, alert.targetCurrency, rates)
        : 0.0;
    final distance = current > 0
        ? ((alert.targetRate - current) / current * 100)
        : 0.0;

    return Opacity(
      opacity: alert.isActive ? 1 : 0.5,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.hairline),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 44,
                  child: Stack(
                    children: [
                      CurrencyIcon(code: alert.baseCurrency, size: 28),
                      Positioned(
                        left: 16,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.surface,
                              width: 2,
                            ),
                          ),
                          child: CurrencyIcon(
                            code: alert.targetCurrency,
                            size: 28,
                          ),
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
                      Text(
                        '${alert.baseCurrency} \u2192 ${alert.targetCurrency}',
                        style: const TextStyle(
                          fontSize: 13,
                          letterSpacing: 0.52,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.ink3,
                          ),
                          children: [
                            TextSpan(
                              text: 'When rate goes ${alert.condition} ',
                            ),
                            TextSpan(
                              text: alert.targetRate.toStringAsFixed(4),
                              style: const TextStyle(color: AppColors.gold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: alert.isActive
                        ? AppColors.goldGlow
                        : AppColors.surface2,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: alert.isActive
                          ? AppColors.gold.withValues(alpha: 0.3)
                          : AppColors.hairline,
                    ),
                  ),
                  child: Text(
                    alert.isActive ? 'Watching' : 'Paused',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.66,
                      color: alert.isActive ? AppColors.gold : AppColors.ink2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Progress bar visualization
            SizedBox(
              height: 38,
              child: Stack(
                children: [
                  Positioned(
                    top: 18,
                    left: 0,
                    right: 0,
                    child: Container(height: 1, color: AppColors.hairline),
                  ),
                  Positioned(
                    top: 14,
                    left: MediaQuery.of(context).size.width * 0.25,
                    child: Column(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.ink2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'now ${CurrencyFormatter.formatRate(current)}',
                          style: const TextStyle(
                            fontSize: 9,
                            color: AppColors.ink3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.gold,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.goldGlow,
                                spreadRadius: 4,
                                blurRadius: 0,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'target',
                          style: TextStyle(fontSize: 9, color: AppColors.gold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${distance >= 0 ? '+' : ''}${distance.toStringAsFixed(2)}% away',
                  style: const TextStyle(fontSize: 11, color: AppColors.ink3),
                ),
                const Text(
                  'Created recently',
                  style: TextStyle(fontSize: 11, color: AppColors.ink3),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showEditMenu(context, ref, alert),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.hairline),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: 14,
                            color: AppColors.ink2,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.ink2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showDeleteDialog(context, ref, alert),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.negative.withValues(alpha: 0.3),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete_outline,
                            size: 14,
                            color: AppColors.negative,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Delete',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.negative,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditMenu(BuildContext context, WidgetRef ref, RateAlert alert) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      builder: (context) => Container(
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit Alert',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.edit, color: AppColors.gold),
              title: const Text('Edit target rate'),
              onTap: () {
                Navigator.pop(context);
                _showEditRateDialog(context, ref, alert);
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.swap_vert, color: AppColors.gold),
              title: Text(alert.isActive ? 'Pause alert' : 'Resume alert'),
              onTap: () {
                Navigator.pop(context);
                _toggleAlertStatus(context, ref, alert);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditRateDialog(BuildContext context, WidgetRef ref, RateAlert alert) {
    final rateCtrl = TextEditingController(text: alert.targetRate.toString());
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Edit Target Rate'),
        content: TextField(
          controller: rateCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            hintText: 'Enter new target rate',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final newRate = double.tryParse(rateCtrl.text);
              if (newRate != null) {
                _updateAlertRate(context, ref, alert, newRate);
                Navigator.pop(context);
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, RateAlert alert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Delete Alert?'),
        content: const Text('Are you sure you want to delete this alert?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteAlert(context, ref, alert);
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.negative),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateAlertRate(
    BuildContext context,
    WidgetRef ref,
    RateAlert alert,
    double newRate,
  ) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    try {
      await ref.read(firestoreServiceProvider).updateAlert(
        user.uid,
        alert.id ?? '',
        {'targetRate': newRate},
      );
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Alert updated successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating alert: $e')),
        );
      }
    }
  }

  Future<void> _toggleAlertStatus(
    BuildContext context,
    WidgetRef ref,
    RateAlert alert,
  ) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    try {
      await ref.read(firestoreServiceProvider).updateAlert(
        user.uid,
        alert.id ?? '',
        {'isActive': !alert.isActive},
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating alert: $e')),
        );
      }
    }
  }

  Future<void> _deleteAlert(
    BuildContext context,
    WidgetRef ref,
    RateAlert alert,
  ) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    try {
      await ref.read(firestoreServiceProvider).deleteAlert(user.uid, alert.id ?? '');
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Alert deleted')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting alert: $e')),
        );
      }
    }
  }
}