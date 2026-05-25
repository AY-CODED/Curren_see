import 'package:cloud_firestore/cloud_firestore.dart';

class ConversionHistory {
  final String? id;
  final String baseCurrency;
  final String targetCurrency;
  final double amount;
  final double rate;
  final double convertedAmount;
  final DateTime createdAt;

  const ConversionHistory({
    this.id,
    required this.baseCurrency,
    required this.targetCurrency,
    required this.amount,
    required this.rate,
    required this.convertedAmount,
    required this.createdAt,
  });

  factory ConversionHistory.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ConversionHistory(
      id: doc.id,
      baseCurrency: data['baseCurrency'] as String,
      targetCurrency: data['targetCurrency'] as String,
      amount: (data['amount'] as num).toDouble(),
      rate: (data['rate'] as num).toDouble(),
      convertedAmount: (data['convertedAmount'] as num).toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'baseCurrency': baseCurrency,
        'targetCurrency': targetCurrency,
        'amount': amount,
        'rate': rate,
        'convertedAmount': convertedAmount,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
