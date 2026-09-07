import 'package:connectcall/routes/app_routes.dart';
import 'package:connectcall/screen/auth/bloc/auth_bloc.dart';
import 'package:connectcall/utils/build_context.dart';
import 'package:connectcall/utils/custom_textfiled.dart';
import 'package:connectcall/widgets/app_auth_scafflod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (_) => false);
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
                'Create Account',
                style: context.headlineML.copyWith(
                  color: isDarkMode ? context.white : context.primaryBlue,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Sign up to start calling on Callly',
                style: context.bodyMR.copyWith(
                  color: context.hintColor,
                ),
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: GestureDetector(
                  // TODO: hook this up to image_picker / file_picker and
                  // dispatch SignupPhotoChanged(pickedPath).
                  onTap: () {},
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: isDarkMode ? context.surface : context.lightBlue,
                    backgroundImage: state.signupPhotoPath != null
                        ? AssetImage(state.signupPhotoPath!) as ImageProvider
                        : null,
                    child: state.signupPhotoPath == null
                        ? Icon(
                            Icons.camera_alt_outlined,
                            color: isDarkMode ? context.lightBlue : context.primaryBlue,
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              DecoratedTextField(
                aboveText: 'Full Name',
                hintText: 'Jane Doe',
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validationError: state.isSignupSubmitted ? state.signupName.error : null,
                onChanged: (v) => context.read<AuthBloc>().add(SignupNameChanged(v)),
              ),
              const SizedBox(height: 16),
              DecoratedTextField(
                aboveText: 'Email',
                hintText: 'you@example.com',
                inputType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validationError: state.isSignupSubmitted ? state.signupEmail.error : null,
                onChanged: (v) => context.read<AuthBloc>().add(SignupEmailChanged(v)),
              ),
              const SizedBox(height: 16),
              DecoratedTextField(
                aboveText: 'Password',
                hintText: '••••••••',
                inputType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                validationError: state.isSignupSubmitted ? state.signupPassword.error : null,
                onChanged: (v) => context.read<AuthBloc>().add(SignupPasswordChanged(v)),
              ),
              const SizedBox(height: 16),
              DecoratedTextField(
                aboveText: 'Confirm Password',
                hintText: '••••••••',
                inputType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                validationError: state.isSignupSubmitted ? state.signupConfirmPassword.error : null,
                onChanged: (v) => context.read<AuthBloc>().add(SignupConfirmPasswordChanged(v)),
                onFieldSubmitted: (_) => context.read<AuthBloc>().add(const SignupSubmitted()),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.primaryBlue,
                  foregroundColor: context.white,
                ),
                onPressed: isLoading ? null : () => context.read<AuthBloc>().add(const SignupSubmitted()),
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
                        'Sign Up',
                        style: context.titleSB.copyWith(color: context.white),
                      ),
              ),
            ],
          ),
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account?',
                style: context.labelMR.copyWith(
                  color: isDarkMode ? context.hintColor : context.black,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                child: Text(
                  'Log In',
                  style: context.labelLB.copyWith(
                    color: isDarkMode ? context.lightBlue : context.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}