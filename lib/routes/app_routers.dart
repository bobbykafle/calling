import 'package:connectcall/repo/call_repo.dart';
import 'package:connectcall/repo/contract_repo.dart';
import 'package:connectcall/screen/auth/forgot_scren.dart';
import 'package:connectcall/screen/auth/login_screen.dart';
import 'package:connectcall/screen/auth/otpp_screen.dart';
import 'package:connectcall/screen/auth/register_screen.dart';
import 'package:connectcall/screen/auth/update_screen.dart';
import 'package:connectcall/screen/onboard/calls/bloc/calls_bloc.dart';
import 'package:connectcall/screen/onboard/calls/bloc/calls_event.dart';
import 'package:connectcall/screen/onboard/calls/call_history_screen.dart';
import 'package:connectcall/screen/onboard/contact/bloc/contact_bloc.dart';
import 'package:connectcall/screen/onboard/contact/bloc/contact_event.dart';
import 'package:connectcall/screen/onboard/contact/contact_screen.dart';
import 'package:connectcall/screen/onboard/mainshall/main_shall_screen.dart';
import 'package:connectcall/screen/splash_screen.dart';
import 'package:flutter/material.dart';

import 'package:connectcall/routes/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      
      case AppRoutes.contacts:
        return _page(
          BlocProvider(
           
            create: (_) => ContactBloc(ContactRepository(), CallLogRepository())..add(LoadContacts()),
            child: const ContactsScreen(),
          ),
          settings,
        );
        
      case AppRoutes.calls:
        return _page(
          BlocProvider(
            create: (_) => CallLogBloc(CallLogRepository())..add(LoadCallLogs()),
            child: const CallLogsScreen(),
          ), 
          settings,
        );

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