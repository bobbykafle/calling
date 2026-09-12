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

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
          header: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppImageView(type: AppImageType.login, height: 200),
              const VSpace(2),
              Text(
                'Welcome  Back'.toUpperCase(),
                style: context.headlineLarge.copyWith(
                  
                  fontWeight: FontWeight.bold,
                ),
              ),
              const VSpace(1),
              Text(
                'Ready to chat? Log in to start your call.',
                style: context.bodySSB.copyWith(color: context.lightBlue),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          body: CustomAuthContainer(
            children: [
              DecoratedTextField(
                aboveText: 'Email',
                hintText: 'you@example.com',
                inputType: TextInputType.emailAddress,
                prefixIcon: const Icon(CupertinoIcons.envelope_fill),
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
                hintText: 'Vob@134%',
                inputType: TextInputType.visiblePassword,
                prefixIcon: const Icon(CupertinoIcons.lock_fill),
                textInputAction: TextInputAction.done,
                validationError: state.isLoginSubmitted
                    ? state.loginPassword.error
                    : null,
                onChanged: (v) =>
                    context.read<AuthBloc>().add(LoginPasswordChanged(v)),
                onFieldSubmitted: (_) =>
                    context.read<AuthBloc>().add(const LoginSubmitted()),
              ),
              const VSpace(1),
              Align(
                alignment: Alignment.topRight,
                child: IntrinsicWidth(
                  child: CustomButton.text(
                    text: 'Forgot Password?',
                  
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.forgotPassword,
                    ),
                  ),
                ),
              ),
              const VSpace(1),
              CustomButton(
                variant: CustomButtonVariant.primary,
                text: 'Log In',
                isLoading: isLoading,
                icon: CupertinoIcons.arrow_right_circle_fill,
                suffixIcon:  Icon(
                  CupertinoIcons.sparkles,
                  size: 18,
                  color: context.white,
                ),
                onPressed: () =>
                    context.read<AuthBloc>().add(const LoginSubmitted()),
              ),
              const VSpace(1),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?   ",
                    style: context.labelMR
                  ),
                  CustomButton.text(text: 'Sign up'.toUpperCase(), 
                  onPressed:()=> Navigator.pushReplacementNamed(context, AppRoutes.signup),),
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