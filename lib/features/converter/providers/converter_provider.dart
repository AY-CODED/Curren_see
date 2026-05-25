import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConverterState {
  final String from;
  final String to;
  final double amount;
  final bool isConverting;

  const ConverterState({
    this.from = 'USD',
    this.to = 'EUR',
    this.amount = 1000,
    this.isConverting = false,
  });

  ConverterState copyWith({
    String? from,
    String? to,
    double? amount,
    bool? isConverting,
  }) {
    return ConverterState(
      from: from ?? this.from,
      to: to ?? this.to,
      amount: amount ?? this.amount,
      isConverting: isConverting ?? this.isConverting,
    );
  }
}

class ConverterNotifier extends StateNotifier<ConverterState> {
  ConverterNotifier() : super(const ConverterState());

  void setFrom(String code) => state = state.copyWith(from: code);
  void setTo(String code) => state = state.copyWith(to: code);
  void setAmount(double amount) => state = state.copyWith(amount: amount);
  void swap() => state = state.copyWith(from: state.to, to: state.from);
  void setConverting(bool v) => state = state.copyWith(isConverting: v);

  void reset() {
    state = state.copyWith(amount: 0);
  }
}

final converterProvider =
    StateNotifierProvider<ConverterNotifier, ConverterState>((ref) {
  return ConverterNotifier();
});
