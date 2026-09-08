import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';
import 'package:connectcall/models/user_model.dart';

class AuthRepository {
  AuthRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    Dio? dio,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _dio = dio ?? Dio();

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final Dio _dio;

  User? get currentUser => _firebaseAuth.currentUser;

  Future<UserModel> fetchUserModel(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) throw Exception('User profile not found.');
    final data = doc.data()!;
    data['uid'] = uid;
    return UserModel.fromMap(data);
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return await fetchUserModel(credential.user!.uid);
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    String? photoPath,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final uid = credential.user!.uid;
    String photoUrl = '';

    if (photoPath != null && photoPath.isNotEmpty) {
      photoUrl = await _uploadToCloudinary(photoPath) ?? '';
    }

    final userModel = UserModel(
      uid: uid,
      name: name.trim(),
      email: email.trim(),
      phone: '',
      photoUrl: photoUrl,
      isOnline: true,
      fcmToken: null,
      createdAt: DateTime.now(),
    );

    await _firestore.collection('users').doc(uid).set(userModel.toMap());
    return userModel;
  }

  Future<String?> _uploadToCloudinary(String filePath) async {
    try {
      const cloudName = 'YOUR_CLOUDINARY_CLOUD_NAME';
      const uploadPreset = 'YOUR_UNSIGNED_PRESET';

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
        'upload_preset': uploadPreset,
      });

      final response = await _dio.post(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data['secure_url'] as String?;
      }
    } catch (_) {}
    return null;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  static String messageFromAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
        case 'invalid-credential':
          return 'No account exists for that email.';
        case 'wrong-password':
          return 'Incorrect password.';
        case 'email-already-in-use':
          return 'An account already exists for that email.';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        default:
          return error.message ?? 'Authentication error occurred.';
      }
    }
    return error.toString();
  }
}