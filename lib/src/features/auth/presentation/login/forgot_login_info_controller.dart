import 'package:betchya_frontend/src/features/auth/domain/email_input.dart';
import 'package:betchya_frontend/src/features/auth/domain/date_of_birth_input.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

class ForgotLoginInfoState {
  const ForgotLoginInfoState({
    this.email = const EmailInput.pure(),
    this.dob = const DateOfBirthInput.pure(),
    this.status = FormzStatus.pure,
    this.error,
    this.isSubmitting = false,
    this.dobObscured = true,
  });

  final EmailInput email;
  final DateOfBirthInput dob;
  final FormzStatus status;
  final String? error;
  final bool isSubmitting;
  final bool dobObscured;

  ForgotLoginInfoState copyWith({
    EmailInput? email,
    DateOfBirthInput? dob,
    FormzStatus? status,
    String? error,
    bool? isSubmitting,
    bool? dobObscured,
  }) {
    return ForgotLoginInfoState(
      email: email ?? this.email,
      dob: dob ?? this.dob,
      status: status ?? this.status,
      error: error,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      dobObscured: dobObscured ?? this.dobObscured,
    );
  }
}

class ForgotLoginInfoController extends StateNotifier<ForgotLoginInfoState> {
  ForgotLoginInfoController() : super(const ForgotLoginInfoState());

  void emailChanged(String value) {
    final email = EmailInput.dirty(value);
    state = state.copyWith(
      email: email,
      status: Formz.validate([email, state.dob]),
    );
  }

  void dobChanged(String value) {
    final dob = DateOfBirthInput.dirty(value);
    state = state.copyWith(
      dob: dob,
      status: Formz.validate([state.email, dob]),
    );
  }

  void toggleDobObscured() {
    state = state.copyWith(dobObscured: !state.dobObscured);
  }

  Future<void> submit() async {
    if (state.status != FormzStatus.valid) return;
    state = state.copyWith(isSubmitting: true);
    // Simulate a network call
    await Future<void>.delayed(const Duration(seconds: 1));
    state = state.copyWith(isSubmitting: false);
    // TODO: Implement actual forgot login info logic
  }
}

final forgotLoginInfoControllerProvider = StateNotifierProvider.autoDispose<ForgotLoginInfoController, ForgotLoginInfoState>((ref) {
  return ForgotLoginInfoController();
});