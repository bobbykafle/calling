import 'package:connectcall/core/theme/bloc/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'theme_event.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState()) {
    on<ThemeModeChanged>(_onThemeModeChanged);
    on<ThemeModeToggled>(_onThemeModeToggled);
  }

  void _onThemeModeChanged(
    ThemeModeChanged event,
    Emitter<ThemeState> emit,
  ) {
    emit(ThemeState(mode: event.mode));
  }

  void _onThemeModeToggled(
    ThemeModeToggled event,
    Emitter<ThemeState> emit,
  ) {
    final next = state.mode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;

    emit(ThemeState(mode: next));
  }
}