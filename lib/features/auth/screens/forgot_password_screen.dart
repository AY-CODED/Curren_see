import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/providers.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../widgets/cs_logo.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _loading = false;
  bool _sent = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _reset() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await ref
          .read(authServiceProvider)
          .resetPassword(_emailCtrl.text.trim());
      setState(() {
        _sent = true;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Could not send reset email. Please try again.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 20, 28, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.chevron_left,
                        color: AppColors.ink2, size: 22),
                  ),
                  const SizedBox(width: 10),
                  const CSLogo(size: 18),
                ],
              ),
              const SizedBox(height: 36),

              Text(
                'RESET PASSWORD',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.98,
                  color: AppColors.gold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Forgot your\npassword?',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 36,
                  height: 1,
                  letterSpacing: -0.9,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                "Enter your email and we'll send you a link to reset it.",
                style: TextStyle(fontSize: 14, color: AppColors.ink2),
              ),

              const SizedBox(height: 32),

              if (_sent) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.positiveSoft,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.positive.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.check_circle_outline_rounded,
                          color: AppColors.positive, size: 32),
                      const SizedBox(height: 12),
                      const Text(
                        'Check your inbox',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.positive,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'We sent a reset link to ${_emailCtrl.text.trim()}',
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.ink2),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                GoldButton(
                  label: 'Back to sign in',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ] else ...[
                if (_error != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: AppColors.negativeSoft,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.negative.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      _error!,
                      style: const TextStyle(
                          color: AppColors.negative, fontSize: 13),
                    ),
                  ),
                Form(
                  key: _formKey,
                  child: AppTextField(
                    label: 'Email',
                    hint: 'you@email.com',
                    prefixIcon: Icons.mail_outline_rounded,
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                ),
                const SizedBox(height: 24),
                GoldButton(
                  label: 'Send reset link',
                  icon: Icons.send_rounded,
                  onPressed: _reset,
                  isLoading: _loading,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
