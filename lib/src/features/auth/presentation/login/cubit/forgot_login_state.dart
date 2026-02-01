import 'package:betchya_frontend/src/features/auth/domain/date_of_birth_input.dart';
import 'package:betchya_frontend/src/features/auth/domain/email_input.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

class ForgotLoginState extends Equatable {
  const ForgotLoginState({
    this.email = const EmailInput.pure(),
    this.dob = const DateOfBirthInput.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.dobObscured = true,
    this.isValid = false,
    this.errorMessage,
  });

  final EmailInput email;
  final DateOfBirthInput dob;
  final FormzSubmissionStatus status;
  final bool dobObscured;
  final bool isValid;
  final String? errorMessage;

  ForgotLoginState copyWith({
    EmailInput? email,
    DateOfBirthInput? dob,
    FormzSubmissionStatus? status,
    bool? dobObscured,
    bool? isValid,
    String? Function()? errorMessage,
  }) {
    return ForgotLoginState(
      email: email ?? this.email,
      dob: dob ?? this.dob,
      status: status ?? this.status,
      dobObscured: dobObscured ?? this.dobObscured,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        email,
        dob,
        status,
        dobObscured,
        isValid,
        errorMessage,
      ];
}
