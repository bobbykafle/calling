import 'package:connectcall/utils/build_context.dart';
import 'package:connectcall/widgets/app_padding.dart';
import 'package:connectcall/widgets/app_responsive.dart';
import 'package:connectcall/widgets/app_space.dart';
import 'package:flutter/material.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.header,
    required this.body,
    required this.footer,
    this.showBackButton = false,
  });

  final Widget header;
  final Widget body;
  final Widget footer;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    AppResponsive.init(context);

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color backButtonColor = isDark ? context.lightBlue : context.primaryBlue;
    final Color scaffoldBg = isDark ? context.black : context.offWhite;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: AppPadding(
                horizontal: 6.4,
                vertical: 2.0,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 24,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (showBackButton)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: () => Navigator.maybePop(context),
                              icon: Icon(
                                Icons.arrow_back_ios_new,
                                color: backButtonColor,
                                size: 18,
                              ),
                            ),
                          ),
                        const VSpace(1),
                        header,
                        const VSpace(3.5),
                        body,
                        const Spacer(),
                        const VSpace(2),
                        footer,
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}