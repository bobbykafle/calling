import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectcall/models/call_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CallLogRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>>? get _logsRef {
    final uid = _uid;
    if (uid == null) return null;
    return _firestore.collection('users').doc(uid).collection('callLogs');
  }

  Future<void> addLog({
    required String otherUserId,
    required String otherUserName,
    String otherUserPhotoUrl = '',
    required bool isVideoCall,
    required CallDirection direction,
    required CallLogStatus status,
    int durationSeconds = 0,
  }) async {
    final ref = _logsRef;
    if (ref == null) return;
    final log = CallLog(
      id: '',
      otherUserId: otherUserId,
      otherUserName: otherUserName,
      otherUserPhotoUrl: otherUserPhotoUrl,
      isVideoCall: isVideoCall,
      direction: direction,
      status: status,
      durationSeconds: durationSeconds,
      timestamp: DateTime.now(),
    );
    await ref.add(log.toMap());
  }

  Stream<List<CallLog>> getCallLogs() {
    final ref = _logsRef;
    if (ref == null) return const Stream.empty();
    return ref
        .orderBy('timestamp', descending: true)
        .limit(100)
        .snapshots()
        .map((snap) => snap.docs.map((d) => CallLog.fromMap(d.id, d.data())).toList());
  }
Stream<List<String>> getFrequentContactIds({int limit = 5}) {
  final ref = _logsRef;
  if (ref == null) return const Stream.empty();
  return ref.orderBy('timestamp', descending: true).limit(50).snapshots().map((snap) {
    final counts = <String, int>{};
    for (final doc in snap.docs) {
      final uid = doc.data()['otherUserId'] as String? ?? '';
      if (uid.isEmpty) continue;
      counts[uid] = (counts[uid] ?? 0) + 1;
    }
    final sorted = counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(limit).map((e) => e.key).toList();
  });
}
}