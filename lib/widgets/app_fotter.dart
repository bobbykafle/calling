import 'package:connectcall/utils/build_context.dart';
import 'package:flutter/material.dart';

class AppLegalFooter extends StatelessWidget {
  const AppLegalFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            '© 2026 ConnectCall.',
            style: context.labelSR.copyWith(
              color: context.black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Terms of Service  •  Privacy Policy',
            style:context.labelSR.copyWith(
              color: context.black,
            ),
          ),
        ],
      ),
    );
  }
}