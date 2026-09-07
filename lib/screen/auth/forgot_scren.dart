import 'package:connectcall/screen/auth/bloc/auth_bloc.dart';
import 'package:connectcall/utils/custom_textfiled.dart';
import 'package:connectcall/widgets/app_auth_scafflod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectcall/routes/app_routes.dart';
import 'package:connectcall/utils/build_context.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // Theme-adapted colors from your extensions
    final Color primaryColor = context.primaryBlue;
    final Color headerSubColor = isDark ? context.lightBlue : context.hintColor;
    final Color footerTextColor = isDark ? context.lightBlue : context.black;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.resetStep == PasswordResetStep.otpForm) {
          Navigator.pushNamed(context, AppRoutes.otp, arguments: state.forgotEmail.value);
        } else if (state.status == AuthStatus.failure && state.errorMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.loading;

        return AuthScaffold(
          showBackButton: true,
          header: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Forgot Password', style: context.headlineML.copyWith(color: primaryColor)),
              const SizedBox(height: 6),
              Text(
                "Enter your email and we'll send you a 6-digit code.",
                style: context.bodyMR.copyWith(color: headerSubColor),
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DecoratedTextField(
                aboveText: 'Email',
                hintText: 'you@example.com',
                inputType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                validationError: state.isResetSubmitted ? state.forgotEmail.error : null,
                onChanged: (v) => context.read<AuthBloc>().add(ForgotPasswordEmailChanged(v)),
                onFieldSubmitted: (_) => context.read<AuthBloc>().add(const ForgotPasswordOtpRequested()),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () => context.read<AuthBloc>().add(const ForgotPasswordOtpRequested()),
                child: isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                      )
                    : const Text('Send Code'),
              ),
            ],
          ),
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Remembered it?', style: context.labelMR.copyWith(color: footerTextColor)),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                child: const Text('Log In'),
              ),
            ],
          ),
        );
      },
    );
  }
}