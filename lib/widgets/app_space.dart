import 'package:connectcall/widgets/app_responsive.dart';
import 'package:flutter/widgets.dart';

class VSpace extends StatelessWidget {
  final double percent;
  const VSpace(this.percent, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: AppResponsive.h(percent));
  }
}

class HSpace extends StatelessWidget {
  final double percent;
  const HSpace(this.percent, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: AppResponsive.w(percent));
  }
}