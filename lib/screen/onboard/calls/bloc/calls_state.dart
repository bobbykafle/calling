import 'package:connectcall/models/call_model.dart';
import 'package:equatable/equatable.dart';

enum CallLogStatusEnum { initial, loading, loaded, failure }

enum CallLogFilter { all, missed, outgoing }

class CallLogState extends Equatable {
  final CallLogStatusEnum status;
  final List<CallLog> logs;
  final String? errorMessage;

  const CallLogState({
    this.status = CallLogStatusEnum.initial,
    this.logs = const [],
    this.errorMessage,
  });

  List<CallLog> filteredBy(CallLogFilter filter) {
    switch (filter) {
      case CallLogFilter.all:
        return logs;
      case CallLogFilter.missed:
        return logs.where((l) => l.status == CallLogStatus.missed || l.status == CallLogStatus.declined).toList();
      case CallLogFilter.outgoing:
        return logs.where((l) => l.direction == CallDirection.outgoing).toList();
    }
  }

  CallLogState copyWith({
    CallLogStatusEnum? status,
    List<CallLog>? logs,
    String? errorMessage,
  }) {
    return CallLogState(
      status: status ?? this.status,
      logs: logs ?? this.logs,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, logs, errorMessage];
}