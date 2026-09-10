import 'package:connectcall/utils/build_context.dart';
import 'package:connectcall/widgets/app_backbutton.dart';
import 'package:connectcall/widgets/app_padding.dart';
import 'package:connectcall/widgets/app_responsive.dart';
import 'package:connectcall/widgets/app_space.dart';
import 'package:flutter/material.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    this.appHeader,
    this.header,
    required this.body,
    this.footer,
    this.showBackButton = false,
  });

  final Widget? appHeader;
  final Widget? header;
  final Widget body;
  final Widget? footer;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    AppResponsive.init(context);

    final theme = context.theme;
    final isDark = theme.brightness == Brightness.dark;

    final gradientColors = isDark
        ? [
            context.surface,
            context.black,
            context.surface,
          ]
        : [
            context.lightBlue.withOpacity(0.5),
            context.offWhite.withOpacity(0.5),
            context.reacher,
          ];

    final bubbleColor = isDark
        ? context.primary.withOpacity(0.08)
        : context.lightBlue.withOpacity(0.5);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Top-right background bubble
            Positioned(
              top: -100,
              right: -80,
              child: Container(
                width: 290,
                height: 290,
                decoration: BoxDecoration(
                  color: bubbleColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Bottom-left background bubble
            Positioned(
              bottom: -110,
              left: -90,
              child: Container(
                width: 310,
                height: 310,
                decoration: BoxDecoration(
                  color: bubbleColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Main content
            CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppPadding(
                    horizontal: 3,
                    vertical: 5.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                     
                        if (showBackButton || appHeader != null) ...[
                          Row(
                            children: [
                              if (showBackButton) ...[
                                const CustomBackButton(),
                                const HSpace(1.5),
                              ],
                              if (appHeader != null)
                                Expanded(
                                  child: appHeader!,
                                ),
                            ],
                          ),
                          const VSpace(2),
                        ],

                        // Page header
                        if (header != null) ...[
                          header!,
                          const VSpace(2),
                        ],

                        // Body (Expanded hataeko, ab yo aafno content anusar matra huncha)
                        body,

                        // Footer
                        if (footer != null) ...[
                          const VSpace(2),
                          footer!,
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}