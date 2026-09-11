import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum CallDirection { incoming, outgoing }

enum CallLogStatus { completed, missed, declined }

class CallLog extends Equatable {
  final String id;
  final String otherUserId;
  final String otherUserName;
  final String otherUserPhotoUrl;
  final bool isVideoCall;
  final CallDirection direction;
  final CallLogStatus status;
  final int durationSeconds;
  final DateTime timestamp;

  const CallLog({
    required this.id,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserPhotoUrl = '',
    required this.isVideoCall,
    required this.direction,
    required this.status,
    this.durationSeconds = 0,
    required this.timestamp,
  });

  String get formattedDuration {
    final m = durationSeconds ~/ 60;
    final s = durationSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  factory CallLog.fromMap(String id, Map<String, dynamic> map) {
    return CallLog(
      id: id,
      otherUserId: map['otherUserId'] as String? ?? '',
      otherUserName: map['otherUserName'] as String? ?? 'Unknown',
      otherUserPhotoUrl: map['otherUserPhotoUrl'] as String? ?? '',
      isVideoCall: map['isVideoCall'] as bool? ?? false,
      direction: CallDirection.values.firstWhere(
        (d) => d.name == map['direction'],
        orElse: () => CallDirection.outgoing,
      ),
      status: CallLogStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => CallLogStatus.completed,
      ),
      durationSeconds: map['durationSeconds'] as int? ?? 0,
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'otherUserId': otherUserId,
      'otherUserName': otherUserName,
      'otherUserPhotoUrl': otherUserPhotoUrl,
      'isVideoCall': isVideoCall,
      'direction': direction.name,
      'status': status.name,
      'durationSeconds': durationSeconds,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }

  @override
  List<Object?> get props =>
      [id, otherUserId, otherUserName, isVideoCall, direction, status, durationSeconds, timestamp];
}