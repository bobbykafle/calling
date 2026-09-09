import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectcall/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContactRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<UserModel>> getContacts() {
    final currentUserId = _auth.currentUser?.uid;
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .where((doc) => doc.id != currentUserId)
          .map((doc) => UserModel.fromMap(doc.data()))
          .toList();
    });
  }
}