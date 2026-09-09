import 'package:connectcall/utils/build_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    super.key,
    this.onPressed,
    this.color,
    this.padding = EdgeInsets.zero,
  });

  final VoidCallback? onPressed;
  final Color? color;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: IconButton(
        onPressed: onPressed ?? () => Navigator.of(context).pop(),

        icon: Icon(
          CupertinoIcons.arrow_left,
          color: color ?? context.onSurface,
        ),

        padding: EdgeInsets.zero,

        constraints: const BoxConstraints(),

        splashRadius: 22,
      ),
    );
  }
}
