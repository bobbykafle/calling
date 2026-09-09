import 'package:connectcall/utils/build_context.dart';
import 'package:connectcall/widgets/app_backbutton.dart';
import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final VoidCallback? onBackPressed;

  const CustomHeader({
    super.key,
    required this.title,
    this.trailing,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomBackButton(
          onPressed: onBackPressed,
        ),

        const Spacer(),

        Text(
          title.toUpperCase(),
          style: context.titleLR.copyWith(
            fontWeight: FontWeight.bold,
            color: context.onSurface,
          ),
        ),

        const Spacer(),

        if (trailing != null)
          trailing!
        else
          const SizedBox(width: 48),
      ],
    );
  }
}