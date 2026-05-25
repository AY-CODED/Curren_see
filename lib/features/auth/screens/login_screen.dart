import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/providers.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../widgets/cs_logo.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _showPassword = false;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await ref.read(authServiceProvider).signIn(
            email: _emailCtrl.text.trim(),
            password: _passwordCtrl.text,
          );
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
    if (error.contains('user-not-found')) return 'No account with that email';
    if (error.contains('wrong-password')) return 'Incorrect password';
    if (error.contains('invalid-email')) return 'Invalid email address';
    if (error.contains('too-many-requests')) return 'Too many attempts. Try later.';
    if (error.contains('network-request-failed')) return 'No internet connection';
    return 'Sign in failed. Please try again.';
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
                const CSLogo(size: 20),
                const SizedBox(height: 50),

                // Title
                Text(
                  'WELCOME BACK',
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
                      fontSize: 40,
                      height: 1,
                      letterSpacing: -1,
                      color: AppColors.ink,
                    ),
                    children: [
                      TextSpan(text: 'Sign '),
                      TextSpan(
                        text: 'in.',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: AppColors.gold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Pick up where you left off \u2014 your rates and history are waiting.',
                  style: TextStyle(fontSize: 14, color: AppColors.ink2),
                ),

                const SizedBox(height: 32),

                // Error
                if (_error != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: AppColors.negativeSoft,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.negative.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      _error!,
                      style: const TextStyle(
                        color: AppColors.negative,
                        fontSize: 13,
                      ),
                    ),
                  ),

                // Fields
                AppTextField(
                  label: 'Email',
                  hint: 'you@email.com',
                  prefixIcon: Icons.mail_outline_rounded,
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Password',
                  hint: '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022',
                  prefixIcon: Icons.lock_outline_rounded,
                  controller: _passwordCtrl,
                  obscureText: !_showPassword,
                  validator: Validators.password,
                  suffix: IconButton(
                    icon: Icon(
                      _showPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18,
                      color: AppColors.ink3,
                    ),
                    onPressed: () =>
                        setState(() => _showPassword = !_showPassword),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/forgot-password'),
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                GoldButton(
                  label: 'Sign in',
                  icon: Icons.arrow_forward_ios_rounded,
                  onPressed: _signIn,
                  isLoading: _loading,
                ),

                const SizedBox(height: 20),

                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.hairline)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.54,
                          color: AppColors.ink3,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: AppColors.hairline)),
                  ],
                ),

                const SizedBox(height: 16),

                // Social buttons
                Row(
                  children: [
                    Expanded(
                      child: GhostButton(
                        label: 'Google',
                        icon: Icons.g_mobiledata_rounded,
                        onPressed: () {},
                        fullWidth: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GhostButton(
                        label: 'Apple',
                        icon: Icons.apple_rounded,
                        onPressed: () {},
                        fullWidth: true,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Register link
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'New here? ',
                        style: TextStyle(fontSize: 14, color: AppColors.ink2),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.of(context).pushNamed('/register'),
                        child: const Text(
                          'Create an account',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.gold,
                          ),
                        ),
                      ),
                    ],
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
