import 'package:connectcall/screen/auth/bloc/auth_bloc.dart';
import 'package:connectcall/utils/custom_textfiled.dart';
import 'package:connectcall/widgets/app_auth_scafflod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectcall/routes/app_routes.dart';
import 'package:connectcall/utils/build_context.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated &&
            state.resetStep == PasswordResetStep.emailForm) {
          // Flow completed and bloc reset itself back to step 1.
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(content: Text('Password updated. Please log in.')));
          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
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
                'New Password',
                style: context.headlineML.copyWith(
                  color: isDarkMode ? context.white : context.primaryBlue,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Choose a strong new password for your account.',
                style: context.bodyMR.copyWith(
                  color: isDarkMode ? context.hintColor : context.hintColor,
                ),
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DecoratedTextField(
                aboveText: 'New Password',
                hintText: '••••••••',
                inputType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                validationError: state.isResetSubmitted ? state.newPassword.error : null,
                onChanged: (v) => context.read<AuthBloc>().add(NewPasswordChanged(v)),
              ),
              const SizedBox(height: 16),
              DecoratedTextField(
                aboveText: 'Confirm New Password',
                hintText: '••••••••',
                inputType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                validationError: state.isResetSubmitted ? state.confirmNewPassword.error : null,
                onChanged: (v) => context.read<AuthBloc>().add(ConfirmNewPasswordChanged(v)),
                onFieldSubmitted: (_) => context.read<AuthBloc>().add(const ChangePasswordSubmitted()),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.primaryBlue,
                  foregroundColor: context.white,
                ),
                onPressed: isLoading ? null : () => context.read<AuthBloc>().add(const ChangePasswordSubmitted()),
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
                        'Update Password',
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