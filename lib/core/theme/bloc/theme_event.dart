part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
  @override
  List<Object?> get props => [];
}

class ThemeModeChanged extends ThemeEvent {
  const ThemeModeChanged(this.mode);
  final ThemeMode mode;
  @override
  List<Object?> get props => [mode];
}

class ThemeModeToggled extends ThemeEvent {
  const ThemeModeToggled();
}