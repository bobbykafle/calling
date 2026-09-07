import 'package:formz/formz.dart';

enum ValidationError {
  empty(errorText: "This field can't be empty"),
  invalidName(errorText: "Enter a valid full name"),
  passwordIncorrect(errorText: "Use 8+ characters with uppercase, lowercase & numbers"),
  passwordNotSame(errorText: "Passwords do not match"),
  invalidEmail(errorText: "Please enter a valid email address"),
  invalidOtp(errorText: "OTP must be 6 digits");

  const ValidationError({required this.errorText});
  final String errorText;
}

class NameInput extends FormzInput<String, ValidationError> {
  const NameInput.pure({String value = ''}) : super.pure(value);
  const NameInput.dirty({String value = ''}) : super.dirty(value);

  @override
  ValidationError? validator(String? value) {
    if (isPure) return null;
    if (value == null || value.trim().isEmpty) return ValidationError.empty;
    final nameRegex = RegExp(r"^[A-Z][a-z]+\s[A-Z][a-z]+$");
    return nameRegex.hasMatch(value.trim()) ? null : ValidationError.invalidName;
  }
}

class PasswordInput extends FormzInput<String, ValidationError> {
  const PasswordInput.pure() : super.pure('');
  const PasswordInput.dirty({String value = ''}) : super.dirty(value);

  static final RegExp passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');

  @override
  ValidationError? validator(String? value) => isPure
      ? null
      : (value == null || value.trim().isEmpty)
          ? ValidationError.empty
          : passwordRegex.hasMatch(value)
              ? null
              : ValidationError.passwordIncorrect;
}

class EmailInput extends FormzInput<String, ValidationError> {
  const EmailInput.pure() : super.pure('');
  const EmailInput.dirty({String value = ''}) : super.dirty(value);

  static final RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  ValidationError? validator(String? value) => isPure
      ? null
      : (value == null || value.trim().isEmpty)
          ? ValidationError.empty
          : emailRegex.hasMatch(value.trim())
              ? null
              : ValidationError.invalidEmail;
}

class ConfirmPasswordInput extends FormzInput<String, ValidationError> {
  final String password;

  const ConfirmPasswordInput.pure({this.password = ''}) : super.pure('');
  const ConfirmPasswordInput.dirty({required String value, required this.password})
      : super.dirty(value);

  @override
  ValidationError? validator(String? value) {
    if (isPure) return null;
    if (value == null || value.trim().isEmpty) return ValidationError.empty;
    return value == password ? null : ValidationError.passwordNotSame;
  }
}

class OtpInput extends FormzInput<String, ValidationError> {
  const OtpInput.pure({String value = ''}) : super.pure(value);
  const OtpInput.dirty({String value = ''}) : super.dirty(value);

  static final RegExp otpRegex = RegExp(r'^\d{6}$');

  @override
  ValidationError? validator(String? value) {
    if (isPure) return null;
    if (value == null || value.trim().isEmpty) return ValidationError.empty;
    return otpRegex.hasMatch(value.trim()) ? null : ValidationError.invalidOtp;
  }
}