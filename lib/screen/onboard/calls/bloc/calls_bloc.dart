import 'dart:async';
import 'package:connectcall/repo/call_repo.dart';
import 'package:connectcall/screen/onboard/calls/bloc/calls_event.dart';
import 'package:connectcall/screen/onboard/calls/bloc/calls_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class CallLogBloc extends Bloc<CallLogEvent, CallLogState> {
  final CallLogRepository _repository;
  StreamSubscription? _subscription;

  CallLogBloc(this._repository) : super(const CallLogState()) {
    on<LoadCallLogs>(_onLoad);
    on<CallLogsUpdated>(_onUpdated);
  }

  void _onLoad(LoadCallLogs event, Emitter<CallLogState> emit) {
    emit(state.copyWith(status: CallLogStatusEnum.loading));
    _subscription?.cancel();
    _subscription = _repository.getCallLogs().listen(
      (logs) => add(CallLogsUpdated(logs)),
      onError: (e) => emit(state.copyWith(
        status: CallLogStatusEnum.failure,
        errorMessage: e.toString(),
      )),
    );
  }

  void _onUpdated(CallLogsUpdated event, Emitter<CallLogState> emit) {
    emit(state.copyWith(status: CallLogStatusEnum.loaded, logs: event.logs));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}