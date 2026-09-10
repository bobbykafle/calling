import 'package:connectcall/core/theme/bloc/theme_bloc.dart';
import 'package:connectcall/utils/build_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppHomeHeader extends StatelessWidget {
  const AppHomeHeader({
    super.key,
    required this.title,
    this.avatarUrl,
    this.onAvatarTap,
  });

  final String title;
  final String? avatarUrl;
  final VoidCallback? onAvatarTap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeBloc>().state.isDark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 5),
      
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: onAvatarTap,
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: context.onSurface.withOpacity(0.15),
                  backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                  child: avatarUrl == null
                      ? Icon(
                          CupertinoIcons.person_fill,
                          color: context.primaryBlue,
                          size: 24,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 15),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
      
          // Right: Theme Toggle Button
          IconButton(
            tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
            icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
            onPressed: () => context.read<ThemeBloc>().add(const ThemeModeToggled()),
          ),
        ],
      ),
    );
  }
}