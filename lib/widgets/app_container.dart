import 'package:connectcall/utils/build_context.dart';
import 'package:flutter/material.dart';

class CustomAuthContainer extends StatelessWidget {
  const CustomAuthContainer({
    super.key,
    required this.children,
    this.expand = false,
  });

  final List<Widget> children;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: context.onSurface.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: context.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
          side: BorderSide(
            color: context.primaryBlue, 
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            children: children,
          ),
        ),
      ),
    );
  }
}