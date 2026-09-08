import 'package:connectcall/utils/build_context.dart';
import 'package:connectcall/widgets/app_backbutton.dart';
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

   

    return Scaffold(
     
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    context.offWhite,
                    context.lightBlue,
                    context.reacher,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
              child: Stack(
                children: [
                  // Top-right light blue bubble
                  Positioned(
                    top: -100,
                    right: -80,
                    child: Container(
                      width: 290,
                      height: 290,
                      decoration: BoxDecoration(
                        color: context.offWhite.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  // Bottom-left off-white/white bubble
                  Positioned(
                    bottom: -110,
                    left: -90,
                    child: Container(
                      width: 310,
                      height: 310,
                      decoration: BoxDecoration(
                        color: context.lightBlue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  // Mid-left accent (Medium blue)
                  Positioned(
                    top: 220,
                    left: -40,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: context.lightBlue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  // Bottom-right accent (Off-white / light tint)
                  Positioned(
                    bottom: 150,
                    right: -40,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: context.offWhite,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  SingleChildScrollView(
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
                                  child:CustomBackButton()
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
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
