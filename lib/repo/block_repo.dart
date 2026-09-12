import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BlockRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  Future<void> blockUser(String targetUid) async {
    final uid = _uid;
    if (uid == null) return;
    await _firestore.collection('users').doc(uid).update({
      'blockedUserIds': FieldValue.arrayUnion([targetUid]),
    });
  }

  Future<void> unblockUser(String targetUid) async {
    final uid = _uid;
    if (uid == null) return;
    await _firestore.collection('users').doc(uid).update({
      'blockedUserIds': FieldValue.arrayRemove([targetUid]),
    });
  }
}