import 'package:cloud_firestore/cloud_firestore.dart';

class RateAlert {
  final String? id;
  final String baseCurrency;
  final String targetCurrency;
  final double targetRate;
  final String condition; // "above" or "below"
  final bool isActive;
  final DateTime createdAt;

  const RateAlert({
    this.id,
    required this.baseCurrency,
    required this.targetCurrency,
    required this.targetRate,
    required this.condition,
    this.isActive = true,
    required this.createdAt,
  });

  factory RateAlert.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RateAlert(
      id: doc.id,
      baseCurrency: data['baseCurrency'] as String,
      targetCurrency: data['targetCurrency'] as String,
      targetRate: (data['targetRate'] as num).toDouble(),
      condition: data['condition'] as String,
      isActive: data['isActive'] as bool? ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'baseCurrency': baseCurrency,
        'targetCurrency': targetCurrency,
        'targetRate': targetRate,
        'condition': condition,
        'isActive': isActive,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  RateAlert copyWith({
    String? id,
    String? baseCurrency,
    String? targetCurrency,
    double? targetRate,
    String? condition,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return RateAlert(
      id: id ?? this.id,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      targetCurrency: targetCurrency ?? this.targetCurrency,
      targetRate: targetRate ?? this.targetRate,
      condition: condition ?? this.condition,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
