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

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                AppImageView(type: AppImageType.createAccount, height: 200),
              const VSpace(2),
              Text(
                'Create   Account'.toUpperCase(),
                style: context.headlineLarge.copyWith(
                  color: context.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const VSpace(1),
              Text(
                'Sign up to start calling on Callly',
                style: context.bodySSB.copyWith(color: context.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          body: CustomAuthContainer(
            children: [
              Center(
                child: GestureDetector(
                  // TODO: hook this up to image_picker / file_picker and
                  // dispatch SignupPhotoChanged(pickedPath).
                  onTap: () {},
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.lightBlue,
                      image: state.signupPhotoPath != null
                          ? DecorationImage(
                              image: AssetImage(state.signupPhotoPath!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: state.signupPhotoPath == null
                        ? Icon(
                            CupertinoIcons.camera_fill,
                            color: context.primaryBlue,
                          )
                        : null,
                  ),
                ),
              ),
              const VSpace(2),
              DecoratedTextField(
                aboveText: 'Full Name',
                hintText: 'Jane Doe',
                textCapitalization: TextCapitalization.words,
                prefixIcon: const Icon(CupertinoIcons.person_fill),
                textInputAction: TextInputAction.next,
                validationError:
                    state.isSignupSubmitted ? state.signupName.error : null,
                onChanged: (v) =>
                    context.read<AuthBloc>().add(SignupNameChanged(v)),
              ),
              const VSpace(2),
              DecoratedTextField(
                aboveText: 'Email',
                hintText: 'you@example.com',
                inputType: TextInputType.emailAddress,
                prefixIcon: const Icon(CupertinoIcons.envelope_fill),
                textInputAction: TextInputAction.next,
                validationError:
                    state.isSignupSubmitted ? state.signupEmail.error : null,
                onChanged: (v) =>
                    context.read<AuthBloc>().add(SignupEmailChanged(v)),
              ),
              const VSpace(2),
              DecoratedTextField(
                aboveText: 'Password',
                hintText: 'Vob@134%',
                inputType: TextInputType.visiblePassword,
                prefixIcon: const Icon(CupertinoIcons.lock_fill),
                textInputAction: TextInputAction.next,
                validationError: state.isSignupSubmitted
                    ? state.signupPassword.error
                    : null,
                onChanged: (v) =>
                    context.read<AuthBloc>().add(SignupPasswordChanged(v)),
              ),
              const VSpace(2),
              DecoratedTextField(
                aboveText: 'Confirm Password',
                hintText: 'Vob@134%',
                inputType: TextInputType.visiblePassword,
                prefixIcon: const Icon(CupertinoIcons.lock_fill),
                textInputAction: TextInputAction.done,
                validationError: state.isSignupSubmitted
                    ? state.signupConfirmPassword.error
                    : null,
                onChanged: (v) => context
                    .read<AuthBloc>()
                    .add(SignupConfirmPasswordChanged(v)),
                onFieldSubmitted: (_) =>
                    context.read<AuthBloc>().add(const SignupSubmitted()),
              ),
              const VSpace(1),
              CustomButton(
                text: 'Sign Up',
                isLoading: isLoading,
                icon: CupertinoIcons.person_add_solid,
                suffixIcon: Icon(
                  CupertinoIcons.sparkles,
                  size: 18,
                  color: context.white,
                ),
                onPressed: () =>
                    context.read<AuthBloc>().add(const SignupSubmitted()),
              ),
              const VSpace(1),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?   ',
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