import 'package:connectcall/screen/auth/forgot_scren.dart';
import 'package:connectcall/screen/auth/login_screen.dart';
import 'package:connectcall/screen/auth/otpp_screen.dart';
import 'package:connectcall/screen/auth/register_screen.dart';
import 'package:connectcall/screen/auth/update_screen.dart';
import 'package:connectcall/screen/onboard/mainshall/main_shall_screen.dart';
import 'package:connectcall/screen/splash_screen.dart';
import 'package:flutter/material.dart';

import 'package:connectcall/routes/app_routes.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _page(const SplashScreen(), settings);

      case AppRoutes.login:
        return _page(const LoginScreen(), settings);

      case AppRoutes.signup:
        return _page(const SignupScreen(), settings);

      case AppRoutes.forgotPassword:
        return _page(const ForgotPasswordScreen(), settings);

      case AppRoutes.otp:
        final email = settings.arguments as String? ?? '';
        return _page(OtpScreen(email: email), settings);

      case AppRoutes.resetPassword:
        return _page(const ResetPasswordScreen(), settings);

      case AppRoutes.mainshall:
        return _page(const MainShell(), settings);

      case AppRoutes.home:
        return _page(const MainShell(), settings);

      default:
        return _page(
          Scaffold(
            body: Center(child: Text('No route defined for "${settings.name}"')),
          ),
          settings,
        );
    }
  }

  static PageRoute<dynamic> _page(Widget child, RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => child, settings: settings);
  }
}