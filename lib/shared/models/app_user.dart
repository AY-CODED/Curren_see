import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String fullName;
  final String email;
  final String defaultBaseCurrency;
  final String lastBaseCurrency;
  final String lastTargetCurrency;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AppUser({
    required this.uid,
    required this.fullName,
    required this.email,
    this.defaultBaseCurrency = 'USD',
    this.lastBaseCurrency = 'USD',
    this.lastTargetCurrency = 'EUR',
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      uid: doc.id,
      fullName: data['fullName'] as String? ?? '',
      email: data['email'] as String? ?? '',
      defaultBaseCurrency: data['defaultBaseCurrency'] as String? ?? 'USD',
      lastBaseCurrency: data['lastBaseCurrency'] as String? ?? 'USD',
      lastTargetCurrency: data['lastTargetCurrency'] as String? ?? 'EUR',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'fullName': fullName,
        'email': email,
        'defaultBaseCurrency': defaultBaseCurrency,
        'lastBaseCurrency': lastBaseCurrency,
        'lastTargetCurrency': lastTargetCurrency,
        'createdAt': Timestamp.fromDate(createdAt),
        'updatedAt': Timestamp.fromDate(updatedAt),
      };

  AppUser copyWith({
    String? fullName,
    String? email,
    String? defaultBaseCurrency,
    String? lastBaseCurrency,
    String? lastTargetCurrency,
    DateTime? updatedAt,
  }) {
    return AppUser(
      uid: uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      defaultBaseCurrency: defaultBaseCurrency ?? this.defaultBaseCurrency,
      lastBaseCurrency: lastBaseCurrency ?? this.lastBaseCurrency,
      lastTargetCurrency: lastTargetCurrency ?? this.lastTargetCurrency,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
