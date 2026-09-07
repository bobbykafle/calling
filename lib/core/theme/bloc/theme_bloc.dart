import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'theme_event.dart';
part 'theme_state.dart';

/// Single source of truth for the app's ThemeMode.
/// Sits ABOVE MaterialApp (see main.dart), so any screen/button anywhere
/// can dispatch an event here and the whole app rebuilds with the new
/// theme — same pattern as AuthBloc.
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(mode: ThemeMode.system)) {
    on<ThemeModeChanged>(_onThemeModeChanged);
    on<ThemeModeToggled>(_onThemeModeToggled);
  }

  void _onThemeModeChanged(ThemeModeChanged event, Emitter<ThemeState> emit) {
    emit(ThemeState(mode: event.mode));
  }

  void _onThemeModeToggled(ThemeModeToggled event, Emitter<ThemeState> emit) {
    final next = state.mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(ThemeState(mode: next));
  }
}