import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/providers.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/cs_header.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key});

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  int _type = 0;
  final _msgCtrl = TextEditingController();
  bool _loading = false;
  bool _sent = false;

  static const _types = [
    ('Idea', Icons.flash_on_rounded),
    ('Issue', Icons.shield_outlined),
    ('Praise', Icons.star_border_rounded),
  ];

  @override
  void dispose() {
    _msgCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_msgCtrl.text.trim().isEmpty) return;

    setState(() => _loading = true);
    try {
      final user = ref.read(currentUserProvider);
      await ref.read(firestoreServiceProvider).submitFeedback(
            userId: user?.uid ?? 'anonymous',
            email: user?.email ?? '',
            message: _msgCtrl.text.trim(),
            type: _types[_type].$1.toLowerCase(),
          );
      setState(() {
        _sent = true;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_sent) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [AppColors.goldSoft, AppColors.gold],
                      ),
                    ),
                    child: const Icon(Icons.check_rounded,
                        size: 36, color: Color(0xFF0A0E1A)),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Thank you!',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 28,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Your feedback has been sent. We read everything and will get back to you soon.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: AppColors.ink2),
                  ),
                  const SizedBox(height: 24),
                  GoldButton(
                    label: 'Done',
                    onPressed: () => Navigator.of(context).pop(),
                    fullWidth: false,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            CSHeader(
              title: 'Feedback',
              eyebrow: 'We read everything',
              large: true,
              leading: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.chevron_left,
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
                      "WHAT'S ON YOUR MIND?",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.54,
                        color: AppColors.ink3,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Type pills
                    Row(
                      children: List.generate(3, (i) {
                        final on = _type == i;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: i < 2 ? 10 : 0),
                            child: GestureDetector(
                              onTap: () => setState(() => _type = i),
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
                                child: Column(
                                  children: [
                                    Icon(
                                      _types[i].$2,
                                      size: 20,
                                      color: on
                                          ? AppColors.gold
                                          : AppColors.ink2,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _types[i].$1.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.88,
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
                      }),
                    ),

                    const SizedBox(height: 18),
                    Text(
                      'TELL US MORE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.54,
                        color: AppColors.ink3,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Expanded(
                      child: TextField(
                        controller: _msgCtrl,
                        maxLines: null,
                        maxLength: 600,
                        onChanged: (_) => setState(() {}),
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          height: 1.5,
                        ),
                        decoration: InputDecoration(
                          hintText: _type == 0
                              ? 'A feature you wish existed\u2026'
                              : _type == 1
                                  ? 'Where did it break, and what were you trying to do?'
                                  : "What did you love? We'll pass it along to the team.",
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: AppColors.hairline),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: AppColors.hairline),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: AppColors.gold),
                          ),
                          counterStyle: const TextStyle(
                            color: AppColors.ink3,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),

                    // Email notice
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        border: Border.all(color: AppColors.hairline),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.mail_outline_rounded,
                              size: 18, color: AppColors.gold),
                          const SizedBox(width: 12),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 12,
                                  height: 1.5,
                                  color: AppColors.ink2,
                                ),
                                children: [
                                  const TextSpan(text: "We'll reply to "),
                                  TextSpan(
                                    text: ref
                                            .read(currentUserProvider)
                                            ?.email ??
                                        'your email',
                                    style: const TextStyle(
                                        color: AppColors.ink),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: GoldButton(
                        label: 'Send feedback',
                        icon: Icons.send_rounded,
                        onPressed: _send,
                        isLoading: _loading,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
