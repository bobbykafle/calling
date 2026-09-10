import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class SearchRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<UserModel>> searchUsers(String query) async {
    if (query.trim().isEmpty) return [];

    final lower = query.trim().toLowerCase();
    final upper = lower + '\uf8ff';

    final snapshot = await _firestore
        .collection('users')
        .where('nameLower', isGreaterThanOrEqualTo: lower)
        .limit(20)
        .get();

    return snapshot.docs
        .map((doc) => UserModel.fromMap(doc.data()!))
        .toList();
  }

  Future<List<UserModel>> getAllUsers() async {
    final snapshot = await _firestore
        .collection('users')
        .limit(30)
        .get();

    return snapshot.docs
        .map((doc) => UserModel.fromMap(doc.data()!))
        .toList();
  }
}