part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

// Splash Screen 
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

// Login Sceen 
class LoginEmailChanged extends AuthEvent {
  const LoginEmailChanged(this.value);
  final String value;
  @override
  List<Object?> get props => [value];
}

class LoginPasswordChanged extends AuthEvent {
  const LoginPasswordChanged(this.value);
  final String value;
  @override
  List<Object?> get props => [value];
}

class LoginSubmitted extends AuthEvent {
  const LoginSubmitted();
}

// Register Screen
class SignupNameChanged extends AuthEvent {
  const SignupNameChanged(this.value);
  final String value;
  @override
  List<Object?> get props => [value];
}

class SignupEmailChanged extends AuthEvent {
  const SignupEmailChanged(this.value);
  final String value;
  @override
  List<Object?> get props => [value];
}

class SignupPasswordChanged extends AuthEvent {
  const SignupPasswordChanged(this.value);
  final String value;
  @override
  List<Object?> get props => [value];
}

class SignupConfirmPasswordChanged extends AuthEvent {
  const SignupConfirmPasswordChanged(this.value);
  final String value;
  @override
  List<Object?> get props => [value];
}

/// Local file path picked via image_picker/file_picker.
class SignupPhotoChanged extends AuthEvent {
  const SignupPhotoChanged(this.path);
  final String path;
  @override
  List<Object?> get props => [path];
}

class SignupSubmitted extends AuthEvent {
  const SignupSubmitted();
}

// Forgot Password Screen
class ForgotPasswordEmailChanged extends AuthEvent {
  const ForgotPasswordEmailChanged(this.value);
  final String value;
  @override
  List<Object?> get props => [value];
}


class ForgotPasswordOtpRequested extends AuthEvent {
  const ForgotPasswordOtpRequested();
}

// OTP Screen
class OtpChanged extends AuthEvent {
  const OtpChanged(this.value);
  final String value;
  @override
  List<Object?> get props => [value];
}


class OtpVerifySubmitted extends AuthEvent {
  const OtpVerifySubmitted();
}

class NewPasswordChanged extends AuthEvent {
  const NewPasswordChanged(this.value);
  final String value;
  @override
  List<Object?> get props => [value];
}

class ConfirmNewPasswordChanged extends AuthEvent {
  const ConfirmNewPasswordChanged(this.value);
  final String value;
  @override
  List<Object?> get props => [value];
}

// Password Reset Screen
class ChangePasswordSubmitted extends AuthEvent {
  const ChangePasswordSubmitted();
}

class PasswordResetFlowReset extends AuthEvent {
  const PasswordResetFlowReset();
}

// Logout 
class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}