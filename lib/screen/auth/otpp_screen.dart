import 'dart:async';
import 'package:connectcall/images/image_container.dart';
import 'package:connectcall/images/image_link.dart';
import 'package:connectcall/routes/app_routes.dart';
import 'package:connectcall/screen/auth/bloc/auth_bloc.dart';
import 'package:connectcall/utils/build_context.dart';
import 'package:connectcall/widgets/app_container.dart';
import 'package:connectcall/widgets/app_auth_scafflod.dart';
import 'package:connectcall/widgets/app_button.dart';
import 'package:connectcall/widgets/app_error.dart';
import 'package:connectcall/widgets/app_fotter.dart';
import 'package:connectcall/widgets/app_padding.dart';
import 'package:connectcall/widgets/app_space.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends HookWidget {
  const OtpScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final otpController = useTextEditingController();
    final secondsLeft = useState(30);

    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (secondsLeft.value > 0) secondsLeft.value -= 1;
      });
      return timer.cancel;
    }, const []);

    final defaultPinTheme = PinTheme(
      width: 48,
      height: 52,
      textStyle: context.titleLR.copyWith(color: context.primaryBlue),
      decoration: BoxDecoration(
        color: context.lightBlue,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.primaryBlue.withOpacity(0.3)),
      ),
    );

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.resetStep == PasswordResetStep.newPasswordForm) {
          Navigator.pushReplacementNamed(context, AppRoutes.resetPassword);
        } else if (state.status == AuthStatus.failure &&
            state.errorMessage != null) {
          AppTErrorNotification.show(
            context,
            message: state.errorMessage!,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.loading;

        return AuthScaffold(
          showBackButton: false,
          header: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              AppImageView(type: AppImageType.otp, height: 200),

                const VSpace(2),
              Text(
                'Enter Code'.toUpperCase(),
                style: context.headlineLarge.copyWith(
                  color: context.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const VSpace(1),
              Text(
                'We sent a 6-digit code to $email',
                style: context.bodySSB.copyWith(color: context.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          body: CustomAuthContainer(
            children: [
              Center(
                child: Pinput(
                  length: 6,
                  controller: otpController,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyDecorationWith(
                    border: Border.all(color: context.primaryBlue, width: 2),
                  ),
                  errorPinTheme: defaultPinTheme.copyDecorationWith(
                    border: Border.all(
                      color: CupertinoColors.destructiveRed,
                      width: 1.5,
                    ),
                  ),
                  forceErrorState:
                      state.isResetSubmitted && !state.otp.isValid,
                  onChanged: (v) =>
                      context.read<AuthBloc>().add(OtpChanged(v)),
                  onCompleted: (v) {
                    context.read<AuthBloc>().add(OtpChanged(v));
                    context.read<AuthBloc>().add(const OtpVerifySubmitted());
                  },
                ),
              ),
              const VSpace(2),
              Center(
                child: secondsLeft.value > 0
                    ? Text(
                        'Resend code in ${secondsLeft.value}s',
                        style: context.labelMR
                            .copyWith(color: context.primaryBlue),
                      )
                    : CustomButton.text(
                        text: 'Resend Code',
                        onPressed: () {
                          context
                              .read<AuthBloc>()
                              .add(const ForgotPasswordOtpRequested());
                          secondsLeft.value = 30;
                        },
                      ),
              ),
              const VSpace(1),
              CustomButton(
                text: 'Verify',
                isLoading: isLoading,
                icon: CupertinoIcons.checkmark_shield_fill,
                suffixIcon: Icon(
                  CupertinoIcons.sparkles,
                  size: 18,
                  color: context.white,
                ),
                onPressed: () =>
                    context.read<AuthBloc>().add(const OtpVerifySubmitted()),
              ),
            ],
          ),
          footer: const AppPadding(vertical: 2, child: AppLegalFooter()),
        );
      },
    );
  }
}