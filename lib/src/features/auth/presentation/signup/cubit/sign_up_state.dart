import 'package:betchya_frontend/src/features/auth/domain/confirm_password_input.dart';
import 'package:betchya_frontend/src/features/auth/domain/email_input.dart';
import 'package:betchya_frontend/src/features/auth/domain/full_name_input.dart';
import 'package:betchya_frontend/src/features/auth/domain/password_input.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

class SignUpState extends Equatable {
  const SignUpState({
    this.fullName = const FullNameInput.pure(),
    this.email = const EmailInput.pure(),
    this.password = const PasswordInput.pure(),
    this.confirmPassword = const ConfirmPasswordInput.pure(),
    this.consent = true,
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
  });

  final FullNameInput fullName;
  final EmailInput email;
  final PasswordInput password;
  final ConfirmPasswordInput confirmPassword;
  final bool consent;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;

  SignUpState copyWith({
    FullNameInput? fullName,
    EmailInput? email,
    PasswordInput? password,
    ConfirmPasswordInput? confirmPassword,
    bool? consent,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? Function()? errorMessage,
  }) {
    return SignUpState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      consent: consent ?? this.consent,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        fullName,
        email,
        password,
        confirmPassword,
        consent,
        status,
        isValid,
        errorMessage,
      ];
}
