import 'dart:async';
import 'package:connectcall/screen/auth/bloc/auth_bloc.dart';
import 'package:connectcall/widgets/app_auth_scafflod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectcall/routes/app_routes.dart';
import 'package:connectcall/utils/build_context.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends HookWidget {
  const OtpScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final otpController = useTextEditingController();
    final secondsLeft = useState(30);

    // Runs once on mount, cancels on unmount
    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (secondsLeft.value > 0) secondsLeft.value -= 1;
      });
      return timer.cancel;
    }, const []);

    final defaultPinTheme = PinTheme(
      width: 48,
      height: 52,
      textStyle: context.titleLR.copyWith(
        color: isDarkMode ? context.white : context.primaryBlue,
      ),
      decoration: BoxDecoration(
        color: isDarkMode ? context.surface : context.lightBlue,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDarkMode ? context.surface : context.primaryBlue.withOpacity(0.3),
        ),
      ),
    );

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.resetStep == PasswordResetStep.newPasswordForm) {
          Navigator.pushReplacementNamed(context, AppRoutes.resetPassword);
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
              Text(
                'Enter Code',
                style: context.headlineML.copyWith(
                  color: isDarkMode ? context.white : context.primaryBlue,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'We sent a 6-digit code to $email',
                style: context.bodyMR.copyWith(
                  color: isDarkMode ? context.hintColor : context.hintColor,
                ),
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Pinput(
                  length: 6,
                  controller: otpController,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyDecorationWith(
                    border: Border.all(
                      color: isDarkMode ? context.lightBlue : context.primaryBlue,
                      width: 2,
                    ),
                  ),
                  errorPinTheme: defaultPinTheme.copyDecorationWith(
                    border: Border.all(
                      color: isDarkMode ? Colors.redAccent : Colors.red,
                      width: 1.5,
                    ),
                  ),
                  forceErrorState: state.isResetSubmitted && !state.otp.isValid,
                  onChanged: (v) => context.read<AuthBloc>().add(OtpChanged(v)),
                  onCompleted: (v) {
                    context.read<AuthBloc>().add(OtpChanged(v));
                    context.read<AuthBloc>().add(const OtpVerifySubmitted());
                  },
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: secondsLeft.value > 0
                    ? Text(
                        'Resend code in ${secondsLeft.value}s',
                        style: context.labelMR.copyWith(
                          color: isDarkMode ? context.hintColor : context.hintColor,
                        ),
                      )
                    : TextButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(const ForgotPasswordOtpRequested());
                          secondsLeft.value = 30;
                        },
                        child: Text(
                          'Resend Code',
                          style: context.labelMB.copyWith(
                            color: isDarkMode ? context.lightBlue : context.primaryBlue,
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.primaryBlue,
                  foregroundColor: context.white,
                ),
                onPressed: isLoading ? null : () => context.read<AuthBloc>().add(const OtpVerifySubmitted()),
                child: isLoading
                    ? SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: context.white,
                        ),
                      )
                    : Text(
                        'Verify',
                        style: context.titleSB.copyWith(color: context.white),
                      ),
              ),
            ],
          ),
          footer: const SizedBox.shrink(),
        );
      },
    );
  }
}