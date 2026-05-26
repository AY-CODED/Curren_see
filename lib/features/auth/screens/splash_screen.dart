import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/providers.dart';
import '../widgets/cs_logo.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _retries = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _navigate();
  }

  Future<void> _navigate() async {
    // Preload rates
    ref.read(exchangeRatesProvider);

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    try {
      final authState = ref.read(authStateProvider);
      authState.when(
        data: (user) {
          if (user != null) {
            Navigator.of(context).pushReplacementNamed('/home');
          } else {
            Navigator.of(context).pushReplacementNamed('/onboarding');
          }
        },
        loading: () {
          _retries++;
          if (_retries > 4) {
            // Firebase may not be configured — go to onboarding
            Navigator.of(context).pushReplacementNamed('/onboarding');
          } else {
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) _navigate();
            });
          }
        },
        error: (_, __) {
          Navigator.of(context).pushReplacementNamed('/onboarding');
        },
      );
    } catch (_) {
      // Firebase not initialized — skip auth, go to onboarding
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/onboarding');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // Concentric gold rings
          Center(
            child: SizedBox(
              width: 380,
              height: 380,
              child: Stack(
                children: List.generate(4, (i) {
                  return Positioned.fill(
                    child: Container(
                      margin: EdgeInsets.all(i * 30.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.gold.withValues(alpha: 0.08),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          // Logo + tagline
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CSMark(size: 72),
                const SizedBox(height: 28),
                const CSWordmark(size: 42),
                const SizedBox(height: 16),
                Text(
                  'MONEY \u00b7 AT A GLANCE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.42,
                    color: AppColors.ink3,
                  ),
                ),
              ],
            ),
          ),
          // Bottom loading indicator
          Positioned(
            bottom: 36,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: AppColors.gold,
                    backgroundColor: Colors.transparent,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'FETCHING RATES',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.98,
                    color: AppColors.ink3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
