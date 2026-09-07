import 'package:connectcall/images/image_container.dart';
import 'package:connectcall/images/image_link.dart';
import 'package:connectcall/routes/app_routes.dart';
import 'package:connectcall/screen/auth/bloc/auth_bloc.dart';
import 'package:connectcall/utils/build_context.dart';
import 'package:connectcall/utils/custom_textfiled.dart';
import 'package:connectcall/widgets/app_auth_scafflod.dart';
import 'package:connectcall/widgets/app_padding.dart';
import 'package:connectcall/widgets/app_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
            (_) => false,
          );
        } else if (state.status == AuthStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.loading;

        return AuthScaffold(
          header: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppImageView(type: AppImageType.login, height: 280),
              const VSpace(2),
              Text(
                'Welcome Back',
                style: context.headlineML.copyWith(
                  color: isDarkMode ? context.white : context.primaryBlue,
                ),
              ),
              const VSpace(1),
              Text(
                'Log in to continue to Callly',
                style: context.bodyMR.copyWith(
                  color: isDarkMode ? context.hintColor : context.hintColor,
                ),
                textAlign: TextAlign.center,
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
                textInputAction: TextInputAction.next,
                validationError: state.isLoginSubmitted
                    ? state.loginEmail.error
                    : null,
                onChanged: (v) =>
                    context.read<AuthBloc>().add(LoginEmailChanged(v)),
              ),
              const VSpace(2),
              DecoratedTextField(
                aboveText: 'Password',
                hintText: '••••••••',
                inputType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                validationError: state.isLoginSubmitted
                    ? state.loginPassword.error
                    : null,
                onChanged: (v) =>
                    context.read<AuthBloc>().add(LoginPasswordChanged(v)),
                onFieldSubmitted: (_) =>
                    context.read<AuthBloc>().add(const LoginSubmitted()),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.forgotPassword),
                  child: Text(
                    'Forgot Password?',
                    style: context.labelMB.copyWith(
                      color: isDarkMode ? context.lightBlue : context.primaryBlue,
                    ),
                  ),
                ),
              ),
              const VSpace(1),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.primaryBlue,
                  foregroundColor: context.white,
                ),
                onPressed: isLoading
                    ? null
                    : () =>
                        context.read<AuthBloc>().add(const LoginSubmitted()),
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
                        'Log In',
                        style: context.titleSB.copyWith(color: context.white),
                      ),
              ),
            ],
          ),
          footer: AppPadding(
            vertical: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Text(
                  "Don't have an account?",
                  style: context.labelMR.copyWith(
                    color: isDarkMode ? context.hintColor : context.black,
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, AppRoutes.signup),
                  child: Text(
                    'Sign Up',
                    style: context.labelLB.copyWith(
                      color: isDarkMode ? context.lightBlue : context.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}