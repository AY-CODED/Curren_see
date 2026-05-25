import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/exchange_rate_service.dart';

// ── Services ──
final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final firestoreServiceProvider =
    Provider<FirestoreService>((ref) => FirestoreService());
final exchangeRateServiceProvider =
    Provider<ExchangeRateService>((ref) => ExchangeRateService());

// ── Auth State ──
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).value;
});

// ── Exchange Rates ──
final exchangeRatesProvider =
    FutureProvider<Map<String, double>>((ref) async {
  final service = ref.watch(exchangeRateServiceProvider);
  return service.getLatestRates();
});
