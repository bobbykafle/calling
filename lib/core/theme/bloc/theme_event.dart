part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
  @override
  List<Object?> get props => [];
}

/// Set the theme to a specific mode (light / dark / system).
class ThemeModeChanged extends ThemeEvent {
  const ThemeModeChanged(this.mode);
  final ThemeMode mode;
  @override
  List<Object?> get props => [mode];
}

/// Flip between light and dark — what a simple toggle button dispatches.
class ThemeModeToggled extends ThemeEvent {
  const ThemeModeToggled();
}