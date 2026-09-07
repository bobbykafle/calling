import 'package:connectcall/core/theme/bloc/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


/// Drop this anywhere in the tree (AppBar actions, a settings row, etc.)
/// Tapping it flips the ENTIRE app between light and dark — no per-screen
/// wiring needed, because ThemeBloc sits above MaterialApp.
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeBloc>().state.isDark;

    return IconButton(
      tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
      icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
      onPressed: () => context.read<ThemeBloc>().add(const ThemeModeToggled()),
    );
  }
}