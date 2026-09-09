import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectcall/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class ProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const _cloudName = 'ljbchavw';
  static const _uploadPreset = 'connectcall';

  String? get currentUid => _auth.currentUser?.uid;

  Stream<UserModel> getCurrentUserProfile() {
    final uid = currentUid;
    if (uid == null) return const Stream.empty();
    return _firestore.collection('users').doc(uid).snapshots().map(
          (doc) => UserModel.fromMap(doc.data() ?? {}),
        );
  }


  Future<String> uploadProfilePhoto(File file) async {
    final uri = Uri.parse('https://api.cloudinary.com/v1_1/$_cloudName/image/upload');
    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = _uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      throw Exception('Upload failed: $body');
    }

    final data = jsonDecode(body) as Map<String, dynamic>;
    return data['secure_url'] as String;
  }

  Future<void> updateProfile({String? name, String? phone, String? photoUrl}) async {
    final uid = currentUid;
    if (uid == null) return;

    final data = <String, dynamic>{};
    if (name != null && name.trim().isNotEmpty) data['name'] = name.trim();
    if (phone != null) data['phone'] = phone.trim();
    if (photoUrl != null) data['photoUrl'] = photoUrl;
    if (data.isEmpty) return;

    await _firestore.collection('users').doc(uid).update(data);
  }

  Future<void> logout() async {
    final uid = currentUid;
    if (uid != null) {
      await _firestore
          .collection('users')
          .doc(uid)
          .update({'isOnline': false})
          .catchError((_) {});
    }
    await _auth.signOut();
  }
}