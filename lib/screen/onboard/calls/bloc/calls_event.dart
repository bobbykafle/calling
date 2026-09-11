import 'package:connectcall/models/call_model.dart';
import 'package:equatable/equatable.dart';

abstract class CallLogEvent extends Equatable {
  const CallLogEvent();
  @override
  List<Object?> get props => [];
}

class LoadCallLogs extends CallLogEvent {}

class CallLogsUpdated extends CallLogEvent {
  final List<CallLog> logs;
  const CallLogsUpdated(this.logs);
  @override
  List<Object?> get props => [logs];
}