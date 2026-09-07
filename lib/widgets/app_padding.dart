import 'package:connectcall/widgets/app_responsive.dart';
import 'package:flutter/widgets.dart';

class AppPadding extends StatelessWidget {
  final Widget child;
  final double? all;
  final double? horizontal;
  final double? vertical;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  const AppPadding({
    super.key,
    required this.child,
    this.all,
    this.horizontal,
    this.vertical,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    EdgeInsets resolvedPadding;

    if (all != null) {
      resolvedPadding = EdgeInsets.all(AppResponsive.w(all!));
    } else {
      resolvedPadding = EdgeInsets.only(
        left: AppResponsive.w(left ?? horizontal ?? 0),
        right: AppResponsive.w(right ?? horizontal ?? 0),
        top: AppResponsive.h(top ?? vertical ?? 0),
        bottom: AppResponsive.h(bottom ?? vertical ?? 0),
      );
    }

    return Padding(
      padding: resolvedPadding,
      child: child,
    );
  }
}