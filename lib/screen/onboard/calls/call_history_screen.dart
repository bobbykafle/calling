import 'package:connectcall/screen/onboard/calls/asdwa.dart';
import 'package:connectcall/screen/onboard/calls/bloc/calls_bloc.dart';
import 'package:connectcall/screen/onboard/calls/bloc/calls_state.dart';
import 'package:connectcall/widgets/app_auth_scafflod.dart';
import 'package:connectcall/widgets/app_header.dart';
import 'package:connectcall/widgets/app_space.dart';
import 'package:connectcall/widgets/app_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CallLogsScreen extends HookWidget {
  const CallLogsScreen({super.key});

  // NOTE: AuthScaffold uses SliverFillRemaining(hasScrollBody: false) and does
  // NOT wrap `body` in Expanded. That means `body` is asked for its intrinsic
  // height, and a TabBarView/ListView (both Viewports) can never answer that
  // -> crash. Since AuthScaffold can't be changed, we give `body` an explicit
  // height via SizedBox so Flutter never needs to ask the TabBarView for its
  // intrinsic size, AND so the TabBarView gets a bounded height to lay out in.
  //
  // Tune this if your header/tab bar layout changes:
  //   CustomHeader height + VSpace(3) + CustomCallTabBar (42 + 16 margin)
  //   + AuthScaffold's AppPadding(vertical: 5.0) top+bottom + VSpace(2)
  static const double _reservedHeight = 230.0;
  static const double _minListHeight = 200.0;

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 3);

    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final safeAreaTop = mediaQuery.padding.top;
    final safeAreaBottom = mediaQuery.padding.bottom;

    final listAreaHeight = (screenHeight - safeAreaTop - safeAreaBottom - _reservedHeight)
        .clamp(_minListHeight, double.infinity);

    return AuthScaffold(
      appHeader: Column(
        children: [
          const CustomHeader(title: "Call Logs"),
          const VSpace(3),
          CustomCallTabBar(controller: tabController),
        ],
      ),
      body: SizedBox(
        height: listAreaHeight,
        child: BlocBuilder<CallLogBloc, CallLogState>(
          builder: (context, state) {
            return TabBarView(
              controller: tabController,
              children: [
                CallLogList(state: state, filter: CallLogFilter.all),
                CallLogList(state: state, filter: CallLogFilter.missed),
                CallLogList(state: state, filter: CallLogFilter.outgoing),
              ],
            );
          },
        ),
      ),
    );
  }
}