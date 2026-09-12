import 'dart:async';
import 'package:connectcall/repo/auth_repo.dart';
import 'package:connectcall/service/zego_initialization.dart';
import 'package:connectcall/utils/formz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:connectcall/models/user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._authRepository) : super(const AuthState()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<LoginEmailChanged>(_onLoginEmailChanged);
    on<LoginPasswordChanged>(_onLoginPasswordChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<SignupNameChanged>(_onSignupNameChanged);
    on<SignupEmailChanged>(_onSignupEmailChanged);
    on<SignupPasswordChanged>(_onSignupPasswordChanged);
    on<SignupConfirmPasswordChanged>(_onSignupConfirmPasswordChanged);
    on<SignupPhotoChanged>((e, emit) => emit(state.copyWith(signupPhotoPath: e.path)));
    on<SignupSubmitted>(_onSignupSubmitted);
    on<ForgotPasswordEmailChanged>(_onForgotPasswordEmailChanged);
    on<ForgotPasswordOtpRequested>(_onForgotPasswordOtpRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  final AuthRepository _authRepository;

  Future<void> _onCheckRequested(
      AuthCheckRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final firebaseUser = _authRepository.currentUser;
    if (firebaseUser == null) {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
      return;
    }
    try {
      final user = await _authRepository.fetchUserModel(firebaseUser.uid);
      await ZegoCallManager.init(user);
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (_) {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  void _onLoginEmailChanged(LoginEmailChanged e, Emitter<AuthState> emit) {
    emit(state.copyWith(loginEmail: EmailInput.dirty(value: e.value)));
  }

  void _onLoginPasswordChanged(LoginPasswordChanged e, Emitter<AuthState> emit) {
    emit(state.copyWith(loginPassword: PasswordInput.dirty(value: e.value)));
  }

  Future<void> _onLoginSubmitted(
      LoginSubmitted event, Emitter<AuthState> emit) async {
    final email = EmailInput.dirty(value: state.loginEmail.value);
    final password = PasswordInput.dirty(value: state.loginPassword.value);

    emit(state.copyWith(
      loginEmail: email,
      loginPassword: password,
      isLoginSubmitted: true,
    ));

    if (!state.isLoginValid) return;

    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = await _authRepository.login(
          email: email.value, password: password.value);
      await ZegoCallManager.init(user);
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: AuthRepository.messageFromAuthError(e),
      ));
    }
  }

  void _onSignupNameChanged(SignupNameChanged e, Emitter<AuthState> emit) {
    emit(state.copyWith(signupName: NameInput.dirty(value: e.value)));
  }

  void _onSignupEmailChanged(SignupEmailChanged e, Emitter<AuthState> emit) {
    emit(state.copyWith(signupEmail: EmailInput.dirty(value: e.value)));
  }

  void _onSignupPasswordChanged(SignupPasswordChanged e, Emitter<AuthState> emit) {
    final password = PasswordInput.dirty(value: e.value);
    final confirm = ConfirmPasswordInput.dirty(
      value: state.signupConfirmPassword.value,
      password: password.value,
    );
    emit(state.copyWith(signupPassword: password, signupConfirmPassword: confirm));
  }

  void _onSignupConfirmPasswordChanged(
      SignupConfirmPasswordChanged e, Emitter<AuthState> emit) {
    emit(state.copyWith(
      signupConfirmPassword: ConfirmPasswordInput.dirty(
        value: e.value,
        password: state.signupPassword.value,
      ),
    ));
  }

  Future<void> _onSignupSubmitted(
      SignupSubmitted event, Emitter<AuthState> emit) async {
    final name = NameInput.dirty(value: state.signupName.value);
    final email = EmailInput.dirty(value: state.signupEmail.value);
    final password = PasswordInput.dirty(value: state.signupPassword.value);
    final confirm = ConfirmPasswordInput.dirty(
      value: state.signupConfirmPassword.value,
      password: password.value,
    );

    emit(state.copyWith(
      signupName: name,
      signupEmail: email,
      signupPassword: password,
      signupConfirmPassword: confirm,
      isSignupSubmitted: true,
    ));

    if (!state.isSignupValid) return;

    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = await _authRepository.register(
        name: name.value,
        email: email.value,
        password: password.value,
        photoPath: state.signupPhotoPath,
      );

      emit(state.copyWith(status: AuthStatus.authenticated, user: user));

      unawaited(ZegoCallManager.init(user).catchError((e) {
        
      }));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: AuthRepository.messageFromAuthError(e),
      ));
    }
  }

  void _onForgotPasswordEmailChanged(
      ForgotPasswordEmailChanged e, Emitter<AuthState> emit) {
    emit(state.copyWith(forgotEmail: EmailInput.dirty(value: e.value)));
  }

  Future<void> _onForgotPasswordOtpRequested(
      ForgotPasswordOtpRequested event, Emitter<AuthState> emit) async {
    final email = EmailInput.dirty(value: state.forgotEmail.value);
    emit(state.copyWith(forgotEmail: email, isResetSubmitted: true));

    if (!email.isValid) return;

    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await _authRepository.sendPasswordResetEmail(email.value);
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        isResetSubmitted: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: AuthRepository.messageFromAuthError(e),
      ));
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<AuthState> emit) async {
    await ZegoCallManager.deinit();
    await _authRepository.logout();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}