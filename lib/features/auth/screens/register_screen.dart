import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/providers.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/models/app_user.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/currency_icon.dart';
import '../widgets/cs_logo.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  String _defaultCurrency = 'USD';
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final cred = await ref.read(authServiceProvider).signUp(
            email: _emailCtrl.text.trim(),
            password: _passwordCtrl.text,
          );

      if (cred.user != null) {
        final now = DateTime.now();
        await ref.read(firestoreServiceProvider).createUser(
              AppUser(
                uid: cred.user!.uid,
                fullName: _nameCtrl.text.trim(),
                email: _emailCtrl.text.trim(),
                defaultBaseCurrency: _defaultCurrency,
                lastBaseCurrency: _defaultCurrency,
                lastTargetCurrency: _defaultCurrency == 'EUR' ? 'USD' : 'EUR',
                createdAt: now,
                updatedAt: now,
              ),
            );
      }

      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      setState(() {
        _error = _friendlyError(e.toString());
        _loading = false;
      });
    }
  }

  String _friendlyError(String error) {
    if (error.contains('email-already-in-use')) {
      return 'Email already in use';
    }
    if (error.contains('weak-password')) {
      return 'Password too weak';
    }
    if (error.contains('invalid-email')) {
      return 'Invalid email address';
    }
    return 'Registration failed. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 20, 28, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child:
                          const Icon(Icons.chevron_left, color: AppColors.ink2, size: 22),
                    ),
                    const SizedBox(width: 10),
                    const CSLogo(size: 18),
                  ],
                ),
                const SizedBox(height: 36),

                // Title
                Text(
                  'GET STARTED',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.98,
                    color: AppColors.gold,
                  ),
                ),
                const SizedBox(height: 12),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 36,
                      height: 1,
                      letterSpacing: -0.9,
                      color: AppColors.ink,
                    ),
                    children: [
                      TextSpan(text: 'Open an '),
                      TextSpan(
                        text: 'account.',
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
                  'Free, forever. Used by 84,000+ travelers, traders, and freelancers worldwide.',
                  style: TextStyle(fontSize: 13, color: AppColors.ink2),
                ),

                const SizedBox(height: 26),

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

                AppTextField(
                  label: 'Full name',
                  hint: 'Alex Morgan',
                  prefixIcon: Icons.person_outline_rounded,
                  controller: _nameCtrl,
                  validator: Validators.fullName,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  label: 'Email',
                  hint: 'you@email.com',
                  prefixIcon: Icons.mail_outline_rounded,
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  label: 'Password',
                  hint: 'At least 8 characters',
                  prefixIcon: Icons.lock_outline_rounded,
                  controller: _passwordCtrl,
                  obscureText: true,
                  validator: Validators.password,
                ),
                const SizedBox(height: 12),

                // Default currency picker
                Text(
                  'DEFAULT BASE CURRENCY',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.54,
                    color: AppColors.ink3,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: ['USD', 'EUR', 'GBP', 'JPY'].map((code) {
                    final selected = _defaultCurrency == code;
                    return GestureDetector(
                      onTap: () => setState(() => _defaultCurrency = code),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color:
                              selected ? AppColors.goldGlow : AppColors.surface,
                          border: Border.all(
                            color:
                                selected ? AppColors.gold : AppColors.hairline,
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
                                color:
                                    selected ? AppColors.gold : AppColors.ink,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 32),

                GoldButton(
                  label: 'Create account',
                  icon: Icons.arrow_forward_ios_rounded,
                  onPressed: _register,
                  isLoading: _loading,
                ),

                const SizedBox(height: 14),
                Center(
                  child: Text(
                    'By continuing you agree to our Terms \u00b7 Privacy',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.ink3,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
