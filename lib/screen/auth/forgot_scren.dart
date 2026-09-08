import 'package:connectcall/images/image_container.dart';
import 'package:connectcall/images/image_link.dart';
import 'package:connectcall/routes/app_routes.dart';
import 'package:connectcall/screen/auth/bloc/auth_bloc.dart';
import 'package:connectcall/utils/build_context.dart';
import 'package:connectcall/utils/custom_textfiled.dart';
import 'package:connectcall/widgets/app_container.dart';
import 'package:connectcall/widgets/app_auth_scafflod.dart';
import 'package:connectcall/widgets/app_button.dart';
import 'package:connectcall/widgets/app_error.dart';
import 'package:connectcall/widgets/app_fotter.dart';
import 'package:connectcall/widgets/app_padding.dart';
import 'package:connectcall/widgets/app_space.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.resetStep == PasswordResetStep.otpForm) {
          Navigator.pushNamed(
            context,
            AppRoutes.otp,
            arguments: state.forgotEmail.value,
          );
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
              AppImageView(type: AppImageType.forgot, height: 200),
              const VSpace(2),
              Text(
                'Forgot Password',
                style: context.headlineLarge.copyWith(
                  color: context.black,
                  fontWeight: FontWeight.bold,
                )
              ),
              const VSpace(1),
              Text(
                "Enter your email and we'll send you a 6-digit code.",
                 style: context.bodySSB.copyWith(color: context.white),
                textAlign: TextAlign.center,
              )
            ],
          ),
          body: CustomAuthContainer(
            children: [
              DecoratedTextField(
                aboveText: 'Email',
                hintText: 'you@example.com',
                inputType: TextInputType.emailAddress,
                prefixIcon: const Icon(CupertinoIcons.envelope_fill),
                textInputAction: TextInputAction.done,
                validationError:
                    state.isResetSubmitted ? state.forgotEmail.error : null,
                onChanged: (v) => context
                    .read<AuthBloc>()
                    .add(ForgotPasswordEmailChanged(v)),
                onFieldSubmitted: (_) => context
                    .read<AuthBloc>()
                    .add(const ForgotPasswordOtpRequested()),
              ),
              const VSpace(2),
              CustomButton(
                text: 'Send Code',
                isLoading: isLoading,
                icon: CupertinoIcons.paperplane_fill,
                suffixIcon: Icon(
                  CupertinoIcons.sparkles,
                  size: 18,
                  color: context.white,
                ),
                onPressed: () => context
                    .read<AuthBloc>()
                    .add(const ForgotPasswordOtpRequested()),
              ),
              const VSpace(1.5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Remembered Password?   ',
                    style: context.labelMR.copyWith(color: context.black),
                  ),

                  CustomButton.text(
                    text: 'Log In'.toUpperCase(),
                    onPressed: () => Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.login,
                    ),
                  ),
                ],
              ),
            ],
          ),
          footer: const AppPadding(vertical: 2, child: AppLegalFooter()),
        );
      },
    );
  }
}