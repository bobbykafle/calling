import 'package:connectcall/models/call_model.dart';
import 'package:connectcall/repo/call_repo.dart';

class CallLogService {
  CallLogService(this._repository);
  final CallLogRepository _repository;

  DateTime? _callStartedAt;
  String? _otherUserId;
  String? _otherUserName;
  bool _isVideoCall = false;
  CallDirection? _direction;

  void _reset() {
    _callStartedAt = null;
    _otherUserId = null;
    _otherUserName = null;
    _direction = null;
  }

  // Callee receives a ring — remember who's calling, in case it goes missed.
  void trackIncoming(String callerId, String callerName, bool isVideoCall) {
    _otherUserId = callerId;
    _otherUserName = callerName;
    _isVideoCall = isVideoCall;
    _direction = CallDirection.incoming;
  }

  // Callee actually joins the call — start the duration timer.
  void markIncomingAccepted() {
    _callStartedAt = DateTime.now();
  }

  // Caller's invite got accepted — start the duration timer.
  void markOutgoingAccepted(String calleeId, String calleeName, bool isVideoCall) {
    _otherUserId = calleeId;
    _otherUserName = calleeName;
    _isVideoCall = isVideoCall;
    _direction = CallDirection.outgoing;
    _callStartedAt = DateTime.now();
  }

  Future<void> logMissedIncoming() async {
    if (_otherUserId != null && _direction == CallDirection.incoming) {
      await _repository.addLog(
        otherUserId: _otherUserId!,
        otherUserName: _otherUserName ?? 'Unknown',
        isVideoCall: _isVideoCall,
        direction: CallDirection.incoming,
        status: CallLogStatus.missed,
      );
    }
    _reset();
  }

  Future<void> logMissedOutgoing(String calleeId, String calleeName, {bool isVideoCall = false}) async {
    await _repository.addLog(
      otherUserId: calleeId,
      otherUserName: calleeName,
      isVideoCall: isVideoCall,
      direction: CallDirection.outgoing,
      status: CallLogStatus.missed,
    );
  }

  Future<void> onCallEnd() async {
    if (_callStartedAt != null && _otherUserId != null && _direction != null) {
      final duration = DateTime.now().difference(_callStartedAt!).inSeconds;
      await _repository.addLog(
        otherUserId: _otherUserId!,
        otherUserName: _otherUserName ?? 'Unknown',
        isVideoCall: _isVideoCall,
        direction: _direction!,
        status: CallLogStatus.completed,
        durationSeconds: duration,
      );
    }
    _reset();
  }
}