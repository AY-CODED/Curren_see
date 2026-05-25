import 'package:dio/dio.dart';

class ExchangeRateService {
  final Dio _dio;
  Map<String, double>? _cachedRates;
  DateTime? _lastFetch;

  ExchangeRateService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: 'https://api.exchangerate.host',
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ));

  bool get hasCachedRates => _cachedRates != null;
  DateTime? get lastFetchTime => _lastFetch;

  /// Fetch latest rates with USD as base.
  /// Falls back to cached rates on failure.
  Future<Map<String, double>> getLatestRates() async {
    try {
      final response = await _dio.get('/live', queryParameters: {
        'access_key':
            'YOUR_API_KEY', // Replace with actual key or use env variable
        'source': 'USD',
      });

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data['success'] == true && data['quotes'] != null) {
          final quotes = data['quotes'] as Map<String, dynamic>;
          _cachedRates = {};
          _cachedRates!['USD'] = 1.0;
          for (final entry in quotes.entries) {
            // Keys are like "USDEUR", "USDGBP"
            final code = entry.key.substring(3);
            _cachedRates![code] = (entry.value as num).toDouble();
          }
          _lastFetch = DateTime.now();
          return _cachedRates!;
        }
      }
    } catch (_) {
      // Fall through to fallback
    }

    // Try alternative free API
    try {
      final response =
          await _dio.get('https://open.er-api.com/v6/latest/USD');
      if (response.statusCode == 200 && response.data != null) {
        final rates = response.data['rates'] as Map<String, dynamic>?;
        if (rates != null) {
          _cachedRates = rates
              .map((key, value) => MapEntry(key, (value as num).toDouble()));
          _lastFetch = DateTime.now();
          return _cachedRates!;
        }
      }
    } catch (_) {
      // Fall through to fallback
    }

    if (_cachedRates != null) return _cachedRates!;
    return _fallbackRates;
  }

  double convert(
      double amount, String from, String to, Map<String, double> rates) {
    final fromRate = rates[from] ?? 1.0;
    final toRate = rates[to] ?? 1.0;
    final usdAmount = amount / fromRate;
    return usdAmount * toRate;
  }

  double getRate(String from, String to, Map<String, double> rates) {
    return convert(1, from, to, rates);
  }

  /// Generate mock 30-day price series for sparklines.
  List<double> generateSeries(
      String from, String to, Map<String, double> rates,
      {int days = 30, int seed = 1}) {
    final base = getRate(from, to, rates);
    final arr = <double>[];
    var s = seed;
    double rand() {
      s = (s * 9301 + 49297) % 233280;
      return s / 233280;
    }

    var v = base * (0.96 + rand() * 0.08);
    for (var i = 0; i < days; i++) {
      final drift = (rand() - 0.48) * 0.012;
      v = v * (1 + drift);
      arr.add(v);
    }
    arr[arr.length - 1] = base;
    return arr;
  }

  static final Map<String, double> _fallbackRates = {
    'USD': 1.0,
    'EUR': 0.9214,
    'GBP': 0.7821,
    'JPY': 156.42,
    'CHF': 0.8930,
    'CAD': 1.3654,
    'AUD': 1.5210,
    'NZD': 1.6402,
    'CNY': 7.2410,
    'HKD': 7.8104,
    'SGD': 1.3492,
    'INR': 83.47,
    'KRW': 1372.5,
    'MXN': 17.82,
    'BRL': 5.1140,
    'ZAR': 18.45,
    'AED': 3.6730,
    'SAR': 3.7510,
    'TRY': 32.18,
    'SEK': 10.62,
    'NOK': 10.85,
    'DKK': 6.8740,
    'NGN': 1550.0,
  };
}
