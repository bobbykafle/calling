import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String photoUrl;
  final bool isOnline;
  final String? fcmToken;
  final DateTime createdAt;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.phone = '',
    this.photoUrl = '',
    this.isOnline = false,
    this.fcmToken,
    required this.createdAt,
  });

  UserModel copyWith({
    String? name,
    String? phone,
    String? photoUrl,
    bool? isOnline,
    String? fcmToken,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      isOnline: isOnline ?? this.isOnline,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'isOnline': isOnline,
      'fcmToken': fcmToken,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String? ?? '',
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      photoUrl: map['photoUrl'] as String? ?? '',
      isOnline: map['isOnline'] as bool? ?? false,
      fcmToken: map['fcmToken'] as String?,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [uid, name, email, phone, photoUrl, isOnline, fcmToken];
}