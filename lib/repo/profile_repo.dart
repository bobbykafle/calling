import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectcall/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileRepository {
  final Dio _dio;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const _cloudName = 'ljbchavw';
  static const _uploadPreset = 'connectcall';

  ProfileRepository({Dio? dio}) : _dio = dio ?? Dio();

  String? get currentUid => _auth.currentUser?.uid;

  Stream<UserModel> getCurrentUserProfile() {
    final uid = currentUid;
    if (uid == null) return const Stream.empty();

    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) => UserModel.fromMap(doc.data() ?? {}));
  }

  Future<String> uploadProfilePhoto(File file) async {
    final uri = 'https://api.cloudinary.com/v1_1/$_cloudName/image/upload';

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
      'upload_preset': _uploadPreset,
    });

    final response = await _dio.post(
      uri,
      data: formData,
    );

    if (response.statusCode != 200) {
      throw Exception('Upload failed: ${response.data}');
    }

    final data = response.data as Map<String, dynamic>;
    return data['secure_url'] as String;
  }

  Future<void> updateProfile({
    String? name,
    String? phone,
    String? photoUrl,
  }) async {
    final uid = currentUid;
    if (uid == null) return;

    final data = <String, dynamic>{};

    if (name != null && name.trim().isNotEmpty) {
      data['name'] = name.trim();
    }

    if (phone != null) {
      data['phone'] = phone.trim();
    }

    if (photoUrl != null) {
      data['photoUrl'] = photoUrl;
    }

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