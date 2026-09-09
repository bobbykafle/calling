import 'package:connectcall/screen/onboard/mainshall/bloc/mainshall_event.dart';
import 'package:connectcall/screen/onboard/mainshall/bloc/mainshall_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class NavigationBloc extends Bloc<MainshallEvent, MainshallState> {
  NavigationBloc() : super(const MainshallState(selectedIndex: 0)) {
    on<NavigationTabChanged>((event, emit) {
      emit(MainshallState(selectedIndex: event.tabIndex));
    });
  }
}