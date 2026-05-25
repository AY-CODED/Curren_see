import 'package:flutter/material.dart';

class Currency {
  final String code;
  final String name;
  final String symbol;
  final String flag;
  final String country;
  final Color tone;

  const Currency({
    required this.code,
    required this.name,
    required this.symbol,
    required this.flag,
    required this.country,
    required this.tone,
  });
}

class CurrencyData {
  CurrencyData._();

  static const List<Currency> all = [
    Currency(code: 'USD', name: 'US Dollar', symbol: '\$', flag: '\u{1F1FA}\u{1F1F8}', country: 'United States', tone: Color(0xFF3C5A7E)),
    Currency(code: 'EUR', name: 'Euro', symbol: '\u20ac', flag: '\u{1F1EA}\u{1F1FA}', country: 'European Union', tone: Color(0xFF1B3A8A)),
    Currency(code: 'GBP', name: 'British Pound', symbol: '\u00a3', flag: '\u{1F1EC}\u{1F1E7}', country: 'United Kingdom', tone: Color(0xFF9B2D2D)),
    Currency(code: 'JPY', name: 'Japanese Yen', symbol: '\u00a5', flag: '\u{1F1EF}\u{1F1F5}', country: 'Japan', tone: Color(0xFFC03A3A)),
    Currency(code: 'CHF', name: 'Swiss Franc', symbol: 'Fr', flag: '\u{1F1E8}\u{1F1ED}', country: 'Switzerland', tone: Color(0xFF9B1B1B)),
    Currency(code: 'CAD', name: 'Canadian Dollar', symbol: 'C\$', flag: '\u{1F1E8}\u{1F1E6}', country: 'Canada', tone: Color(0xFFB83A3A)),
    Currency(code: 'AUD', name: 'Australian Dollar', symbol: 'A\$', flag: '\u{1F1E6}\u{1F1FA}', country: 'Australia', tone: Color(0xFF1B3A6E)),
    Currency(code: 'NZD', name: 'New Zealand Dollar', symbol: 'NZ\$', flag: '\u{1F1F3}\u{1F1FF}', country: 'New Zealand', tone: Color(0xFF1B2E5C)),
    Currency(code: 'CNY', name: 'Chinese Yuan', symbol: '\u00a5', flag: '\u{1F1E8}\u{1F1F3}', country: 'China', tone: Color(0xFFB82828)),
    Currency(code: 'HKD', name: 'Hong Kong Dollar', symbol: 'HK\$', flag: '\u{1F1ED}\u{1F1F0}', country: 'Hong Kong', tone: Color(0xFFC0342B)),
    Currency(code: 'SGD', name: 'Singapore Dollar', symbol: 'S\$', flag: '\u{1F1F8}\u{1F1EC}', country: 'Singapore', tone: Color(0xFFC0342B)),
    Currency(code: 'INR', name: 'Indian Rupee', symbol: '\u20b9', flag: '\u{1F1EE}\u{1F1F3}', country: 'India', tone: Color(0xFFD17A1F)),
    Currency(code: 'KRW', name: 'South Korean Won', symbol: '\u20a9', flag: '\u{1F1F0}\u{1F1F7}', country: 'South Korea', tone: Color(0xFF1F3F8A)),
    Currency(code: 'MXN', name: 'Mexican Peso', symbol: 'Mex\$', flag: '\u{1F1F2}\u{1F1FD}', country: 'Mexico', tone: Color(0xFF1F7A3A)),
    Currency(code: 'BRL', name: 'Brazilian Real', symbol: 'R\$', flag: '\u{1F1E7}\u{1F1F7}', country: 'Brazil', tone: Color(0xFF1F7A4A)),
    Currency(code: 'ZAR', name: 'South African Rand', symbol: 'R', flag: '\u{1F1FF}\u{1F1E6}', country: 'South Africa', tone: Color(0xFF1F6E3A)),
    Currency(code: 'AED', name: 'UAE Dirham', symbol: '\u062f.\u0625', flag: '\u{1F1E6}\u{1F1EA}', country: 'United Arab Emirates', tone: Color(0xFF1F5C3F)),
    Currency(code: 'SAR', name: 'Saudi Riyal', symbol: '\ufdfc', flag: '\u{1F1F8}\u{1F1E6}', country: 'Saudi Arabia', tone: Color(0xFF1B5532)),
    Currency(code: 'TRY', name: 'Turkish Lira', symbol: '\u20ba', flag: '\u{1F1F9}\u{1F1F7}', country: 'Turkey', tone: Color(0xFFA6232E)),
    Currency(code: 'SEK', name: 'Swedish Krona', symbol: 'kr', flag: '\u{1F1F8}\u{1F1EA}', country: 'Sweden', tone: Color(0xFF1F4A8A)),
    Currency(code: 'NOK', name: 'Norwegian Krone', symbol: 'kr', flag: '\u{1F1F3}\u{1F1F4}', country: 'Norway', tone: Color(0xFF1B3F7E)),
    Currency(code: 'DKK', name: 'Danish Krone', symbol: 'kr', flag: '\u{1F1E9}\u{1F1F0}', country: 'Denmark', tone: Color(0xFF9B1B1B)),
    Currency(code: 'NGN', name: 'Nigerian Naira', symbol: '\u20a6', flag: '\u{1F1F3}\u{1F1EC}', country: 'Nigeria', tone: Color(0xFF1F6E3A)),
  ];

  static final Map<String, Currency> byCode = {
    for (final c in all) c.code: c,
  };

  static Currency? get(String code) => byCode[code];
}
