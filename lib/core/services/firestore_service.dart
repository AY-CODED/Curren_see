import 'package:cloud_firestore/cloud_firestore.dart';
import '../../shared/models/app_user.dart';
import '../../shared/models/conversion_history.dart';
import '../../shared/models/rate_alert.dart';

class FirestoreService {
  final FirebaseFirestore _db;

  FirestoreService({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  // ── User ──
  Future<void> createUser(AppUser user) async {
    await _db.collection('users').doc(user.uid).set(user.toFirestore());
  }

  Future<AppUser?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromFirestore(doc);
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    data['updatedAt'] = Timestamp.now();
    await _db.collection('users').doc(uid).update(data);
  }

  // ── Conversion History ──
  Future<void> addConversion(String uid, ConversionHistory conversion) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('conversion_history')
        .add(conversion.toFirestore());
  }

  Stream<List<ConversionHistory>> watchConversions(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('conversion_history')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map(ConversionHistory.fromFirestore).toList());
  }

  Future<List<ConversionHistory>> getConversions(String uid) async {
    final snap = await _db
        .collection('users')
        .doc(uid)
        .collection('conversion_history')
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs.map(ConversionHistory.fromFirestore).toList();
  }

  Future<void> clearHistory(String uid) async {
    final snap = await _db
        .collection('users')
        .doc(uid)
        .collection('conversion_history')
        .get();
    final batch = _db.batch();
    for (final doc in snap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  // ── Rate Alerts ──
  Future<void> addAlert(String uid, RateAlert alert) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('rate_alerts')
        .add(alert.toFirestore());
  }

  Stream<List<RateAlert>> watchAlerts(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('rate_alerts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(RateAlert.fromFirestore).toList());
  }

  Future<void> updateAlert(
      String uid, String alertId, Map<String, dynamic> data) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('rate_alerts')
        .doc(alertId)
        .update(data);
  }

  Future<void> deleteAlert(String uid, String alertId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('rate_alerts')
        .doc(alertId)
        .delete();
  }

  // ── Feedback ──
  Future<void> submitFeedback({
    required String userId,
    required String email,
    required String message,
    required String type,
  }) async {
    await _db.collection('feedback').add({
      'userId': userId,
      'email': email,
      'message': message,
      'type': type,
      'createdAt': Timestamp.now(),
    });
  }
}
