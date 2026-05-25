import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/splash_screen.dart';
import 'features/auth/screens/onboarding_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/auth/screens/forgot_password_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/converter/screens/currency_picker_screen.dart';
import 'features/help/screens/help_screen.dart';
import 'features/feedback/screens/feedback_screen.dart';
import 'features/alerts/screens/new_alert_screen.dart';

class CurrenSeeApp extends StatelessWidget {
  const CurrenSeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CurrenSee',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      initialRoute: '/splash',
      onGenerateRoute: _onGenerateRoute,
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case '/onboarding':
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case '/forgot-password':
        return MaterialPageRoute(
            builder: (_) => const ForgotPasswordScreen());

      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case '/currency-picker':
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => CurrencyPickerScreen(
            kind: args['kind'] as String? ?? 'from',
            selectedFrom: args['from'] as String? ?? 'USD',
            selectedTo: args['to'] as String? ?? 'EUR',
          ),
        );

      case '/help':
        return MaterialPageRoute(builder: (_) => const HelpScreen());

      case '/feedback':
        return MaterialPageRoute(builder: (_) => const FeedbackScreen());

      case '/new-alert':
        return MaterialPageRoute(builder: (_) => const NewAlertScreen());

      case '/alerts':
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
