part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  const ThemeState({required this.mode});

  final ThemeMode mode;

  bool get isDark => mode == ThemeMode.dark;

  @override
  List<Object?> get props => [mode];
}