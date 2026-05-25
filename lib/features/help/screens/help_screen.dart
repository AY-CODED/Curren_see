import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/cs_header.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  int _openIndex = 0;

  static const _faqItems = [
    _FAQ(
      'Where do exchange rates come from?',
      'Rates are pulled from exchangerate.host every 60 seconds. They reflect mid-market reference values \u2014 the rate banks use among themselves, before any spread.',
    ),
    _FAQ(
      'Are conversions actually transferred?',
      'No. CurrenSee is a viewer \u2014 it tells you what your money is worth. To actually move money, use your bank or a transfer service.',
    ),
    _FAQ(
      'How do rate alerts work?',
      "Pick a currency pair and a target. We check the market in the background and send you a notification the moment your condition is met. Up to 10 active alerts.",
    ),
    _FAQ(
      'Is my data private?',
      "Yes. Conversion history and alerts are stored under your account only. We don't share or sell anything \u2014 see our Privacy policy.",
    ),
    _FAQ(
      'Can I use it offline?',
      'You can browse cached rates and your history. New conversions and alerts need a connection.',
    ),
    _FAQ(
      'Why does the converted amount blink?',
      "It's a fresh calculation \u2014 rates change constantly. The blink confirms you're seeing the most current value.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            CSHeader(
              title: 'Help',
              eyebrow: 'Frequently asked',
              large: true,
              leading: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.chevron_left,
                    color: AppColors.ink2, size: 22),
              ),
            ),

            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Quick links grid
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 8, 22, 16),
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 3.2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: const [
                        _QuickLink(Icons.mail_outline_rounded, 'Email us'),
                        _QuickLink(Icons.send_rounded, 'Feedback'),
                        _QuickLink(Icons.shield_outlined, 'Privacy'),
                        _QuickLink(Icons.public_rounded, 'Status'),
                      ],
                    ),
                  ),

                  // FAQ section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 4, 22, 0),
                    child: Text(
                      'TOP QUESTIONS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.54,
                        color: AppColors.ink3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  ...List.generate(_faqItems.length, (i) {
                    final item = _faqItems[i];
                    final isOpen = _openIndex == i;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => setState(
                                () => _openIndex = isOpen ? -1 : i),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(color: AppColors.hairline),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.question,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.ink,
                                      ),
                                    ),
                                  ),
                                  AnimatedContainer(
                                    duration:
                                        const Duration(milliseconds: 200),
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isOpen
                                          ? AppColors.gold
                                          : Colors.transparent,
                                      border: isOpen
                                          ? null
                                          : Border.all(
                                              color: AppColors.hairline2),
                                    ),
                                    child: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 14,
                                      color: isOpen
                                          ? const Color(0xFF0A0E1A)
                                          : AppColors.ink3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (isOpen)
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 6),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  item.answer,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    height: 1.6,
                                    color: AppColors.ink2,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }),

                  // Still stuck card
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.goldGlow,
                            Colors.transparent,
                          ],
                        ),
                        border: Border.all(
                          color: AppColors.gold.withValues(alpha: 0.25),
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'STILL STUCK?',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.98,
                              color: AppColors.gold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 22,
                                letterSpacing: -0.44,
                                color: AppColors.ink,
                              ),
                              children: [
                                TextSpan(text: 'We reply within '),
                                TextSpan(
                                  text: '4 hours.',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: AppColors.gold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          GoldButton(
                            label: 'Contact support',
                            icon: Icons.send_rounded,
                            onPressed: () {},
                          ),
                        ],
                      ),
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

class _QuickLink extends StatelessWidget {
  final IconData icon;
  final String label;
  const _QuickLink(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.hairline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.gold),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _FAQ {
  final String question;
  final String answer;
  const _FAQ(this.question, this.answer);
}
