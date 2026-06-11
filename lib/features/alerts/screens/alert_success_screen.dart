import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/cs_header.dart';

class AlertSuccessScreen extends StatelessWidget {
  const AlertSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            CSHeader(title: 'Alert created', eyebrow: 'You\'re all set'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.goldGlow,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_active_rounded,
                        color: AppColors.gold,
                        size: 60,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'Alert Created!',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.9,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'We\'ll monitor the exchange rate and notify you when it reaches your target.',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.ink2,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 24),
              child: Column(
                children: [
                  SuccessButton(
                    label: 'View alerts',
                    icon: Icons.arrow_forward_ios_rounded,
                    onPressed: () => Navigator.of(context).pushReplacementNamed(
                      '/home',
                      arguments: {'initialIndex': 2},
                    ),
                  ),
                  const SizedBox(height: 12),
                  GhostButton(
                    label: 'Create another',
                    onPressed: () => Navigator.of(
                      context,
                    ).pushReplacementNamed('/new-alert'),
                    fullWidth: true,
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
