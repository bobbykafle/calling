part of 'auth_bloc.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, failure }

/// Which screen of the forgot-password mini-flow we're on.
enum PasswordResetStep { emailForm, otpForm, newPasswordForm }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,

    // Login Screen
    this.loginEmail = const EmailInput.pure(),
    this.loginPassword = const PasswordInput.pure(),
    this.isLoginSubmitted = false,

    // Signup Screen
    this.signupName = const NameInput.pure(),
    this.signupEmail = const EmailInput.pure(),
    this.signupPassword = const PasswordInput.pure(),
    this.signupConfirmPassword = const ConfirmPasswordInput.pure(),
    this.signupPhotoPath,
    this.isSignupSubmitted = false,

    // Forgot Password - OTP - Change Password
    this.resetStep = PasswordResetStep.emailForm,
    this.forgotEmail = const EmailInput.pure(),
    this.otp = const OtpInput.pure(),
    this.newPassword = const PasswordInput.pure(),
    this.confirmNewPassword = const ConfirmPasswordInput.pure(),
    this.isResetSubmitted = false,
  });

  final AuthStatus status;
  final UserModel? user;
  final String? errorMessage;

  // login
  final EmailInput loginEmail;
  final PasswordInput loginPassword;
  final bool isLoginSubmitted;

  // signup
  final NameInput signupName;
  final EmailInput signupEmail;
  final PasswordInput signupPassword;
  final ConfirmPasswordInput signupConfirmPassword;
  final String? signupPhotoPath;
  final bool isSignupSubmitted;

  // forgot password -> otp -> change password
  final PasswordResetStep resetStep;
  final EmailInput forgotEmail;
  final OtpInput otp;
  final PasswordInput newPassword;
  final ConfirmPasswordInput confirmNewPassword;
  final bool isResetSubmitted;

  bool get isLoginValid => loginEmail.isValid && loginPassword.isValid;

  bool get isSignupValid =>
      signupName.isValid &&
      signupEmail.isValid &&
      signupPassword.isValid &&
      signupConfirmPassword.isValid;

  bool get isForgotEmailValid => forgotEmail.isValid;
  bool get isOtpValid => otp.isValid;
  bool get isChangePasswordValid =>
      newPassword.isValid && confirmNewPassword.isValid;

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? errorMessage,
    EmailInput? loginEmail,
    PasswordInput? loginPassword,
    bool? isLoginSubmitted,
    NameInput? signupName,
    EmailInput? signupEmail,
    PasswordInput? signupPassword,
    ConfirmPasswordInput? signupConfirmPassword,
    String? signupPhotoPath,
    bool? isSignupSubmitted,
    PasswordResetStep? resetStep,
    EmailInput? forgotEmail,
    OtpInput? otp,
    PasswordInput? newPassword,
    ConfirmPasswordInput? confirmNewPassword,
    bool? isResetSubmitted,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
      loginEmail: loginEmail ?? this.loginEmail,
      loginPassword: loginPassword ?? this.loginPassword,
      isLoginSubmitted: isLoginSubmitted ?? this.isLoginSubmitted,
      signupName: signupName ?? this.signupName,
      signupEmail: signupEmail ?? this.signupEmail,
      signupPassword: signupPassword ?? this.signupPassword,
      signupConfirmPassword: signupConfirmPassword ?? this.signupConfirmPassword,
      signupPhotoPath: signupPhotoPath ?? this.signupPhotoPath,
      isSignupSubmitted: isSignupSubmitted ?? this.isSignupSubmitted,
      resetStep: resetStep ?? this.resetStep,
      forgotEmail: forgotEmail ?? this.forgotEmail,
      otp: otp ?? this.otp,
      newPassword: newPassword ?? this.newPassword,
      confirmNewPassword: confirmNewPassword ?? this.confirmNewPassword,
      isResetSubmitted: isResetSubmitted ?? this.isResetSubmitted,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        errorMessage,
        loginEmail,
        loginPassword,
        isLoginSubmitted,
        signupName,
        signupEmail,
        signupPassword,
        signupConfirmPassword,
        signupPhotoPath,
        isSignupSubmitted,
        resetStep,
        forgotEmail,
        otp,
        newPassword,
        confirmNewPassword,
        isResetSubmitted,
      ];
}